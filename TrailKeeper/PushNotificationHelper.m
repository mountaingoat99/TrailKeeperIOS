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

+(void)GetNewPush:(NSDictionary*)jsonString {
    NSError *error;
    
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
    NSString *trailObjectId = [object objectForKey:@"trailObjectId"];
    NSString *trailName = [object objectForKey:@"trailName"];
    NSString *comment = [object objectForKey:@"fullComment"];
    NSString *userId = [object objectForKey:@"userObjectId"];
    
    // do something with this info, send the to the correct view controller?
}

+(void)ConvertStatusPush:(NSDictionary*)object {
    // first lets get the variables from the JSON object
    NSString *trailObjectId = [object objectForKey:@"trailObjectId"];
    NSString *trailName = [object objectForKey:@"trailName"];
    NSString *statusString = [object objectForKey:@"statusUpdate"];
    NSString *userId = [object objectForKey:@"userObjectId"];
    
    // do something with this info, send the to the correct view controller?
}

@end
