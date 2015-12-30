//
//  GetAllObjectsFromParseHelper.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/30/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "GetAllObjectsFromParseHelper.h"
#import "ConnectionDetector.h"

@implementation GetAllObjectsFromParseHelper

+(void)UnpinallAllTrailObjects {
    if ([ConnectionDetector hasConnectivity]) {
        NSLog(@"Unpinning all Current Trail Objects");
        [PFObject unpinAllObjects];
    } else {
        NSLog(@"No Connection, we will not be unpinning all Current Trail Objects");
    }
}

+(void)RefreshTrails {
    PFQuery *query = [PFQuery queryWithClassName:@"Trails"];
    [[query findObjectsInBackground] continueWithSuccessBlock:^id(BFTask *task) {
        return [[PFObject unpinAllObjectsInBackgroundWithName:@"Trails"] continueWithSuccessBlock:^id(BFTask *ignored) {
            NSArray *trails = task.result;
            NSLog(@"Trail Count from refresh %lu", (unsigned long)trails.count);
            NSLog(@"First Trail Name %@", [[trails objectAtIndex:0] objectForKey:@"trailName"]);
            return [PFObject pinAllInBackground:trails withName:@"Trails"];
        }];
    }];
}

+(void)RefreshTrailStatus {
    PFQuery *query = [PFQuery queryWithClassName:@"TrailStatus"];
    [[query findObjectsInBackground] continueWithSuccessBlock:^id(BFTask *task) {
        return [[PFObject unpinAllObjectsInBackgroundWithName:@"TrailStatus"] continueWithSuccessBlock:^id(BFTask *ignored) {
            NSArray *trailStatuses = task.result;
            NSLog(@"TrailStatus Count from refresh %lu", (unsigned long)trailStatuses.count);
            return [PFObject pinAllInBackground:trailStatuses withName:@"TrailStatus"];
        }];
    }];
}

+(void)RefreshAuthorizedCommentors {
    PFQuery *query = [PFQuery queryWithClassName:@"AuthorizedCommentors"];
    [[query findObjectsInBackground] continueWithSuccessBlock:^id(BFTask *task) {
        return [[PFObject unpinAllObjectsInBackgroundWithName:@"AuthorizedCommentors"] continueWithSuccessBlock:^id(BFTask *ignored) {
            NSArray *commentors = task.result;
            NSLog(@"Commentor Count from refresh %lu", (unsigned long)commentors.count);
            return [PFObject pinAllInBackground:commentors withName:@"AuthorizedCommentors"];
        }];
    }];
}

+(void)RefreshComments {
    PFQuery *query = [PFQuery queryWithClassName:@"Comments"];
    [[query findObjectsInBackground] continueWithSuccessBlock:^id(BFTask *task) {
        return [[PFObject unpinAllObjectsInBackgroundWithName:@"Comments"] continueWithSuccessBlock:^id(BFTask *ignored) {
            NSArray *comments = task.result;
            NSLog(@"Comment Count from refresh %lu", (unsigned long)comments.count);
            return [PFObject pinAllInBackground:comments withName:@"Comments"];
        }];
    }];
}

@end
