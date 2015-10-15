//
//  TrailStatus.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/13/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "TrailStatus.h"
#import <Parse/PFObject+Subclass.h>

@interface TrailStatus ()

-(void)addOfflineTrailStatus:(TrailStatus*)trailStatus;
-(void)deleteOneOfflineTrailStatus:(int)tableId;

@end

@implementation TrailStatus

@dynamic trailName;
@dynamic updateStatusPin;
@dynamic authorizedUserNames;

+(void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return @"TrailStatus";
}

@end
