//
//  UsersModel.m
//  TestTask
//
//  Created by Roman on 5/26/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#define kJsonURL [NSURL URLWithString:@"http://jsonplaceholder.typicode.com/users"]

#import "UsersModel.h"

@implementation UsersModel
+ (instancetype) model
{
    static UsersModel *model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [UsersModel new];
        [model parseJson];
    });
    return  model;
}

- (void) parseJson
{
    NSData* data = [NSData dataWithContentsOfURL:
                    kJsonURL];
    [self performSelectorOnMainThread:@selector(fetchedData:)
                           withObject:data waitUntilDone:YES];
}

- (void)fetchedData:(NSData *)responseData
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    NSAssert(error == nil, @"JSON parsing error");
    
    NSArray* name = [json valueForKey:@"name"];
    NSArray* userName = [json valueForKey:@"username"];
    NSArray* phoneNumber = [json valueForKey:@"phone"];
    NSArray* lat = [[[json valueForKey:@"address"] valueForKey:@"geo"]valueForKey:@"lat"];
    NSArray* lng = [[[json valueForKey:@"address"] valueForKey:@"geo"]valueForKey:@"lng"];
    
    NSAssert(name.count > 0 &&
             userName.count > 0 && phoneNumber.count > 0 &&
             lat.count > 0 && lng.count > 0, @"faild to parse json");
    
    for (int i = 0; i < name.count; i++) {
        [[DataManager manager]insertUserInfoWithName:name[i] userName:userName[i] phoneNumber:phoneNumber[i]longitude:[lng[i] doubleValue] latitude:[lat[i] doubleValue]];//as variant it can be done by dictionary
    }
}
@end
