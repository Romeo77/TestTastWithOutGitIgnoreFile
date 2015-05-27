//
//  DataManager.m
//  TestTask
//
//  Created by Roman on 5/25/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import "DataManager.h"

@interface DataManager ()
@property (strong, nonatomic) MDMPersistenceController *persistenceController;
@end

@implementation DataManager

+ (instancetype) manager
{
    static DataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [DataManager new];
        [manager openCoreData];
    });
    
    return  manager;
}

- (BOOL)isModel:(NSURL *) modelUrl compatibleWithStoreAtUrl:(NSURL *)storeUrl
{
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl]];
    return [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:nil] != nil;
}

- (void) openCoreData
{
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ModelUsers" withExtension:@"momd"];
    if ([self isModel:modelURL compatibleWithStoreAtUrl:[self storeUrl]] == NO)
    {
        NSLog(@"Existing core data store is removed, as it is not compatible with the new version");
        [[NSFileManager defaultManager]removeItemAtPath:[self storeUrl].path error:nil];
    }
    
    self.persistenceController = [[MDMPersistenceController alloc] initWithStoreURL:[self storeUrl] modelURL:modelURL];
}

- (NSURL*) storeUrl
{
    NSString *storePath = [@"~/Documents/storefile" stringByExpandingTildeInPath];
    return [NSURL fileURLWithPath:storePath];
}

- (id) errorBlockHandler
{
    return ^(NSError *error) {
        if (error) NSLog(@"Error: %@", error.localizedDescription);
        NSAssert(error == nil, @"");
    };
}

- (NSArray*) getAllUsersInfo
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([UserInfo class])];
    NSArray *Info = [self.persistenceController executeFetchRequest:fetchRequest error:[self errorBlockHandler]];
    return Info;
}

- (void) insertUserInfoWithName :(NSString*) name userName :(NSString*) userName phoneNumber : (NSString*) phoneNumber longitude:(double) longitude latitude : (double) latitude
{
    UserInfo *info = [UserInfo MDMCoreDataAdditionsInsertNewObjectIntoContext:self.persistenceController.managedObjectContext];
    info.name = name;
    info.userName = userName;
    info.phoneNumber = phoneNumber;
    info.longitude = @(longitude);
    info.latitude = @(latitude);
    
    [self.persistenceController saveContextAndWait:TRUE completion:[self errorBlockHandler]];
}

- (void) changeInfoWithName :(NSString*) name userName :(NSString*) userName phoneNumber : (NSString*) phoneNumber andIndex :(NSInteger) index
{
    [[self getAllUsersInfo] enumerateObjectsUsingBlock:^(UserInfo *obj, NSUInteger idx, BOOL *stop) {
        if (idx == index) {
            obj.name = name;
            obj.userName = userName;
            obj.phoneNumber = phoneNumber;
            [self.persistenceController saveContextAndWait:TRUE completion:[self errorBlockHandler]];
            return;
        }
    }];
}

- (void) deleteInfo :(NSInteger) index
{
    [[self getAllUsersInfo] enumerateObjectsUsingBlock:^(UserInfo *obj, NSUInteger idx, BOOL *stop) {
        if (idx == index) {
            [self.persistenceController.managedObjectContext deleteObject:obj];
            [self.persistenceController saveContextAndWait:TRUE completion:[self errorBlockHandler]];
            return;
        }
    }];
}

- (void)deleteAllData
{
    self.persistenceController = nil;
    
    NSError *error;
    [[NSFileManager defaultManager]removeItemAtPath:[self storeUrl].path error:&error];
    NSAssert(error == nil, @"failed to delete store");
    [self openCoreData];
}

@end
