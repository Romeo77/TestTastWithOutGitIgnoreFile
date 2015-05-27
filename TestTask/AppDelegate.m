//
//  AppDelegate.m
//  TestTask
//
//  Created by Roman on 5/25/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //[[DataManager manager]deleteAllData]; // if you need to check the first loading of the data ;)
    
    if (![[DataManager manager] getAllUsersInfo].count) {
        [UsersModel model];
    }
    return YES;
}
@end
