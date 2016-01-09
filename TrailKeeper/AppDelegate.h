//
//  AppDelegate.h
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/11/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Trails.h"
#import "TrailStatus.h"
#import "User.h"
#import "AuthorizedCommentors.h"
#import "Comments.h"
#import "Installation.h"
#import "MMDrawerController.h"
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) MMDrawerController *drawerController;
@property (nonatomic, strong) UIViewController *whichController;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) NSString *notificationTrailId;

@end

