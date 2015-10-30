//
//  AppDelegate.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/11/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "AppDelegate.h"
#import "PushNotificationHelper.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

-(BOOL)isUserWhoUpdated:(NSDictionary*)userInfo;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Parse enableLocalDatastore];
    [Trails registerSubclass];
    [TrailStatus registerSubclass];
    [User registerSubclass];
    [AuthorizedCommentors registerSubclass];
    [Comments registerSubclass];
    [Installation registerSubclass];
    // push
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes  categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    // key
    [Parse setApplicationId:@"uU8JsEF9eLEYcFzUrwqmrWzblj65IoQ0G6S4DkI8" clientKey:@"4S7u2tedpm9yeE6DR3J6mDyJHHpgmUgktu6Q6QvD"];
    
    // Override point for customization after application launch.
    NSDictionary *notificationPayload = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];

    // we do not want to show the notification is the user is the one who sent the update
    if (![self isUserWhoUpdated:notificationPayload]) {
        //Open up the TrailInfo View Controller for the correct trail
        [PushNotificationHelper GetNewPush:notificationPayload];
    }
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current Installation and save it to Parse
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[@"global"];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"JSON: %@", userInfo);
    
    // we do not want to show the notification is the user is the one who sent the update
    if (![self isUserWhoUpdated:userInfo]) {
        [PFPush handlePush:userInfo];
        // if the app is open we do not want to show anything on the badge
        if ([application applicationState] == UIApplicationStateActive) {
            PFInstallation *currentInstallation = [PFInstallation currentInstallation];
            if (currentInstallation.badge != 0) {
                currentInstallation.badge = 0;
                [currentInstallation saveEventually];
            }
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // watching and clearing the badge on the app
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveEventually];
    }
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma private methods

-(BOOL)isUserWhoUpdated:(NSDictionary*)userInfo {
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    NSString *userObjectId = [userInfo objectForKey:@"userObjectId"];
    return ([userObjectId isEqualToString:currentInstallation.objectId]);
}

@end
