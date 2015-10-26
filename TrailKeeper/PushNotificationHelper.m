//
//  PushNotificationHelper.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/11/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "PushNotificationHelper.h"
#import <Parse.h>
#import "Installation.h"
#import "Trails.h"

@interface PushNotificationHelper ()

+(void)ConvertCommentPush:(NSDictionary*)object;
+(void)ConvertStatusPush:(NSDictionary*)object;

@end

@implementation PushNotificationHelper

#pragma CONSTANTS

NSString* const COMMENT_ACTION = @"com.singlecog.trailkeeper.NEW_COMMENT_NOTIF";
NSString* const STATUS_ACTION = @"com.singlecog.trailkeeper.NEW_STATUS_NOTIF";

#pragma class methods

+(NSString*)FormatChannelName:(NSString*)trail {
    trail = [trail stringByReplacingOccurrencesOfString:@"Channel" withString:@""];
    
    NSRegularExpression *regexp = [NSRegularExpression
                                   regularExpressionWithPattern:@"([a-z])([A-Z])"
                                   options:0
                                   error:NULL];
    
    NSString *newTrailName = [regexp
                           stringByReplacingMatchesInString:trail
                           options:0
                           range:NSMakeRange(0, trail.length)
                           withTemplate:@"$1 $2"];
    NSLog(@"Changed '%@' -> '%@'", trail, newTrailName);
    
    return newTrailName;
}

+(NSString*)CreateChannelName:(NSString*)trail {
    NSString *newTrailName = [trail stringByAppendingString:@"Channel"];
    
    return newTrailName;
}

+(void)SendOutAPushNotificationForNewComment:(NSString*)trailNameString trailObjectId:(NSString*)trailObjectId comment:(NSString*)Comment {
    NSString *channel = [self CreateChannelName:trailNameString];
    PFInstallation *installation = [PFInstallation currentInstallation];
    
    // serialize the object to JSON
    NSDictionary *dict = @{@"action" : COMMENT_ACTION,
                           @"com.Parse.Channel" : channel,
                           @"trailObjectId" : trailObjectId,
                           @"trailName" : trailNameString,
                           @"comment" : Comment,
                           @"InstallationObjectId" : installation.objectId};
    
    NSError *error = nil;
    NSData *json;
    NSString *jsonString;
    
    // Dictionary convertable to JSON?
    if ([NSJSONSerialization isValidJSONObject:dict]) {
        // serialize the object
        json = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        
        // if no errors, view the JSON for testing
        if (json != nil && error == nil) {
            jsonString = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
            NSLog(@"JSON: %@", jsonString);
        }
    }
    
    PFPush *push = [[PFPush alloc] init];
    [push setChannel:channel];
    [push setMessage:jsonString];  
    [push sendPushInBackground];
}

+(void)SendOutAPushNotificationForStatusUpdate:(NSString*)trailNameString trailObjectId:(NSString*)trailObjectId status:(NSNumber*)Status {
    NSString *channel = [self CreateChannelName:trailNameString];
    PFInstallation *installation = [PFInstallation currentInstallation];
    NSString *statusString = [Trails ConvertTrailStatusForPush:Status trailname:trailNameString];
    
    // serialize the object to JSON
    NSDictionary *dict = @{@"action" : STATUS_ACTION,
                           @"com.Parse.Channel" : channel,
                           @"trailObjectId" : trailObjectId,
                           @"statusUpdate" : statusString,
                           @"InstallationObjectId" : installation.objectId};
    
    NSError *error = nil;
    NSData *json;
    NSString *jsonString;
    
    // Dictionary convertable to JSON?
    if ([NSJSONSerialization isValidJSONObject:dict]) {
        // serialize the object
        json = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        
        // if no errors, view the JSON for testing
        if (json != nil && error == nil) {
            jsonString = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
            NSLog(@"JSON: %@", jsonString);
        }
    }
    
    PFPush *push = [[PFPush alloc] init];
    [push setChannel:channel];
    [push setMessage:jsonString];
    [push sendPushInBackground];
}

+(void)GetNewPush:(NSDictionary*)jsonString {
    //NSData *json = [[NSData alloc] initWithBase64EncodedString:jsonString options:NSUTF8StringEncoding];
    //NSData *jsonData = [NSData dataWithContentsOfFile:jsonString];
    NSError *error;
    
    // get JSON data into a foundation object
    //id object = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    
    // verify object recieved is dictionary
    if ([jsonString isKindOfClass:[NSDictionary class]] && error == nil) {
        NSLog(@"dictionary: %@", jsonString);
        
        // get the value string for the next key page
        NSString *action = [jsonString objectForKey:@"action"];
        if ([action isEqualToString:COMMENT_ACTION]) {
            [self ConvertCommentPush:jsonString];
        } else if ([action isEqualToString:STATUS_ACTION]){
            [self ConvertStatusPush:jsonString];
        } else {
            NSLog(@"dictionary: %@ did not have the correct type of action", jsonString);
        }
    }
}

#pragma private methods

+(void)ConvertCommentPush:(NSDictionary*)object {
    // first lets get the variables from the JSON object
    NSString *channel = [object objectForKey:@"com.Parse.Channel"];
    NSString *trailObjectId = [object objectForKey:@"trailObjectId"];
    NSString *trailName = [object objectForKey:@"trailName"];
    NSString *comment = [object objectForKey:@"comment"];
    NSString *installationObjectId = [object objectForKey:@"InstallationObjectId"];
    
    // create a string for the comment
    NSString *commentWithTrailName = [NSString stringWithFormat:@"%@ has a new Comment.\n%@", trailName, comment];
    
    // create the array that the Parse Push class is looking for from our custom notification object
    //TODO figure out the app badges
    // TODO figure out the sounds dealio
    NSDictionary *aps = @{@"alert" : commentWithTrailName,
                           @"badge" : @"3",
                           @"sound" : @"default"};
    
    NSDictionary *userInfo = @{@"aps" : aps};
    NSLog(@"dictionary: %@", userInfo);
    
    // then call the parse class to handle it
    [PFPush handlePush:userInfo];
    
    // TODO do something to get the other info and have that page pull up when user clicks on the notification
    
}

+(void)ConvertStatusPush:(NSDictionary*)object {
    // first lets get the variables from the JSON object
    NSString *channel = [object objectForKey:@"com.Parse.Channel"];
    NSString *trailObjectId = [object objectForKey:@"trailObjectId"];
    NSString *statusString = [object objectForKey:@"statusUpdate"];
    NSString *installationObjectId = [object objectForKey:@"InstallationObjectId"];
    
    // create the array that the Parse Push class is looking for from our custom notification object
    //TODO figure out the app badges
    // TODO figure out the sounds dealio
    NSDictionary *aps = @{@"alert" : statusString,
                          @"badge" : @"3",
                          @"sound" : @"default"};
    
    NSDictionary *userInfo = @{@"aps" : aps};
    NSLog(@"dictionary: %@", userInfo);
    
    // then call the parse class to handle it
    [PFPush handlePush:userInfo];
    
    // TODO do something to get the other info and have that page pull up when user clicks on the notification
}

@end
