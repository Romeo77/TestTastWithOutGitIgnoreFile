//
//  DataManager.h
//  TestTask
//
//  Created by Roman on 5/25/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MDMCoreData.h>
#import "UserInfo.h"

@interface DataManager : NSObject

+ (instancetype) manager;
- (NSArray*) getAllUsersInfo;
- (void) insertUserInfoWithName :(NSString*) name userName :(NSString*) userName phoneNumber : (NSString*) phoneNumber longitude:(double) longitude latitude : (double) latitude;
- (void) changeInfoWithName :(NSString*) name userName :(NSString*) userName phoneNumber : (NSString*) phoneNumber andIndex :(NSInteger) index;
- (void) deleteInfo :(NSInteger) index;
- (void)deleteAllData;

@end

