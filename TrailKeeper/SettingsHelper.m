//
//  SettingsHelper.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 11/1/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "SettingsHelper.h"

@implementation SettingsHelper

+(NSArray*)getSettingsList {
    NSArray *settingsList = [NSArray arrayWithObjects:
                             @"Home",
                             @"Find Trail",
                             @"Comments",
                             @"Map",
                             @"Add Trail",
                             @"Trail Subscriptions",
                             @"Account Settings",
                             @"Get Trail Pin",
                             @"Contact Us"
                             , nil];
    
    return settingsList;
}

+(NSArray*)getAccountSettingsList {
    NSArray *settingsList = [NSArray arrayWithObjects:
                             @"Home",
                             @"Create Account",
                             @"Update Account",
                             @"Sign-In",
                             @"Sign-Out",
                             @"Delete Account",
                             @"Verify Email",
                             @"Units of Measure",
                             nil];
 
    return settingsList;
}

@end
