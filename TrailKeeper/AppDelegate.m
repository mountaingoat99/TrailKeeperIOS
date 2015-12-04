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
#import "LeftDrawerController.h"
#import "MainViewController.h"
#import "MMDrawerVisualState.h"
#import "AlertControllerHelper.h"

@interface AppDelegate ()

-(BOOL)isUserWhoUpdated:(NSDictionary*)userInfo;

@end

@implementation AppDelegate

@synthesize drawerController;
@synthesize locationManager;
@synthesize currentLocation;

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // get the storyboard
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    // get the ViewController by their identifiers
    id mainViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MainViewController"];
    id leftDrawerController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"LeftDrawerController"];
    
    // init the Navigation controllers
    UINavigationController *centerNav = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    UINavigationController *leftNav = [[UINavigationController alloc] initWithRootViewController:leftDrawerController];
    
    // create the drawer
    drawerController = [[MMDrawerController alloc] initWithCenterViewController:centerNav leftDrawerViewController:leftNav];
    
    // drawer properties
    [drawerController setShowsShadow:YES];
    [drawerController setRestorationIdentifier:@"MMDrawer"];
    
    // gesture masks
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    // style of drawer open
    [drawerController setDrawerVisualStateBlock:[MMDrawerVisualState swingingDoorVisualStateBlock]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIColor *tintColor = [UIColor colorWithRed:29.0/255.0 green:173.0/255.0 blue:234.0/255.0 alpha:1.0];
    [self.window setTintColor:tintColor];
    
    [self.window setRootViewController:self.drawerController];
    
    return YES;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // location manager
    if(self.locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc] init];
        
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 30;  // might change this one we start creating trail maps
        [self.locationManager requestWhenInUseAuthorization];
        //[self.locationManager requestAlwaysAuthorization];
    }
    
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager startUpdatingLocation];
    }
    
    // Parse stuff
    [Parse enableLocalDatastore];
    [Trails registerSubclass];
    [TrailStatus registerSubclass];
    [User registerSubclass];
    [AuthorizedCommentors registerSubclass];
    [Comments registerSubclass];
    [Installation registerSubclass];
    
    
    // Parse key
    [Parse setApplicationId:@"uU8JsEF9eLEYcFzUrwqmrWzblj65IoQ0G6S4DkI8" clientKey:@"4S7u2tedpm9yeE6DR3J6mDyJHHpgmUgktu6Q6QvD"];
    
    // Override point for customization after application launch.
    NSDictionary *notificationPayload = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];

    // we do not want to show the notification to the user is the one who sent the update
    if (![self isUserWhoUpdated:notificationPayload]) {
        //Open up the TrailInfo View Controller for the correct trail
        [PushNotificationHelper GetNewPush:notificationPayload];
    }
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0/255.0 green:150.0/255.00 blue:136.0/255.0 alpha:1]];
    [[UINavigationBar appearance] setTranslucent:NO];
    //set back button color
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UINavigationBar class]]] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    //set back button arrow color
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    // UIAlertViewController
    [[UIView appearanceWhenContainedInInstancesOfClasses:@[[UIAlertController class]]] setTintColor:[UIColor blackColor]];
    [[UIView appearanceWhenContainedInInstancesOfClasses:@[[UIAlertController class]]] setBackgroundColor:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current Installation and save it to Parse
    Installation *install = [[Installation alloc] init];
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    if ([install GetUserChannels] != nil) {
        currentInstallation.channels = [install GetUserChannels];
        NSLog(@"Channels %@ ", currentInstallation.channels);
        NSLog(@"InstallId %@ ", currentInstallation.objectId);
        [currentInstallation saveInBackground];
    }
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

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusDenied:
            NSLog(@"kCLAuthorizationStatusDenied");
        {
            MainViewController  *main = [[MainViewController alloc] init];
            
            [AlertControllerHelper ShowAlert:@"Location Services Not Enabled" message:@"The app can’t access your current location.\n\nTo enable, please turn on location access in the Settings app under Location Services." view:main];
        }
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            self.locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
            [self.locationManager startUpdatingLocation];
            
            self.currentLocation = self.locationManager.location;
        }
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            self.locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
            [self.locationManager startUpdatingLocation];
            
            self.currentLocation = self.locationManager.location;
        }
            break;
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"kCLAuthorizationStatusNotDetermined");
            break;
        case kCLAuthorizationStatusRestricted:
            NSLog(@"kCLAuthorizationStatusRestricted");
            break;
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    // not implemented now but will use it later
    
}

#pragma private methods

-(BOOL)isUserWhoUpdated:(NSDictionary*)userInfo {
    PFUser *user = [PFUser currentUser];
    NSString *userObjectId = [userInfo objectForKey:@"userObjectId"];
    return ([userObjectId isEqualToString:user.objectId]);
}

@end
