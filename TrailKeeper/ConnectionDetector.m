//
//  ConnectionDetector.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/11/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "ConnectionDetector.h"
#import "Trails.h"
#import "TrailStatus.h"
#import "Comments.h"
#import "AppDelegate.h"

@implementation ConnectionDetector

/*
 Connectivity testing code pulled from Apple's Reachability Example: http://developer.apple.com/library/ios/#samplecode/Reachability
 */
+(BOOL)hasConnectivity {
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
    if(reachability != NULL) {
        //NetworkStatus retVal = NotReachable;
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(reachability, &flags)) {
            if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
            {
                // if target host is not reachable
                return NO;
            }
            
            if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
            {
                // if target host is reachable and no connection is required
                //  then we'll assume (for now) that your on Wi-Fi
                return YES;
            }
            
            
            if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
                 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
            {
                // ... and the connection is on-demand (or on-traffic) if the
                //     calling application is using the CFSocketStream or higher APIs
                
                if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
                {
                    // ... and no [user] intervention is needed
                    return YES;
                }
            }
            
            if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
            {
                // ... but WWAN connections are OK if the calling application
                //     is using the CFNetwork (CFSocketStream?) APIs.
                return YES;
            }
        }
    }
    
    return NO;
}

+(void)checkForOfflineTrailData {
    Trails *trails = [[Trails alloc]init];
    if ([trails GetDbTrailsRowCount] > 0) {
        do {
            // get the a trail
            Trails *trail = [[Trails alloc] init];
            trail = [trails GetOffLineTrail];
            // save the trailname
            NSString *trailName = trail.trailName;
            // save the trail
            [trails SaveNewTrail:trail];
            // delete the trail from the DB
            [trails DeleteNewTrail:trailName];
        } while ([trails GetDbTrailsRowCount] > 0);
        NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
        [preferences setBool:NO forKey:HasOfflineTrailKey];
    }
}

+(void)checkForOfflineTrailStatusData {
    TrailStatus *status = [[TrailStatus alloc] init];
    if ([status GetDbCommentRowCount] > 0) {
        do {
            TrailStatus *trailStatus = [[TrailStatus alloc]init];
            trailStatus = [status GetOffTrailStatus];
            NSString *trailName = trailStatus.trailName;
            [status SaveStatus:trailStatus];
            [status deleteOneOfflineTrailStatus:trailName];
        } while ([status GetDbCommentRowCount] > 0);
        NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
        [preferences setBool:NO forKey:HasOfflineTrailStatusKey];
    }
}

+(void)checkForOfflineTrailCommentData {
    Comments *comments = [[Comments alloc] init];
    if ([comments GetDbCommentRowCount] > 0) {
        do {
            Comments *oneComment = [[Comments alloc] init];
            oneComment =[comments GetOfflineComments];
            NSString *comment = oneComment.comment;
            [comments SaveNewComment:oneComment];
            [comments deleteOneOfflineComment:comment];
        } while ([comments GetDbCommentRowCount] > 0);
        NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
        [preferences setBool:NO forKey:HasOfflineCommentKey];
    }
}

@end
