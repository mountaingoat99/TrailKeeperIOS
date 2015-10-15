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

#pragma properties

@dynamic trailName;
@dynamic updateStatusPin;
@dynamic authorizedUserNames;

#pragma init methods

+(void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return @"TrailStatus";
}

#pragma public methods

-(NSString*)GetTrailPin:(NSString*)trailName {
    NSString *trailPin;
    
    
    return trailPin;
}

-(void)CreateNewTrailStatus:(Trails*)trailName {
    
}

-(void)UpdateTrailStatus:(NSString*)objectId Choice:(NSNumber*)choice TrailName:(NSString*)trailName {
    
}

-(void)UpdateTrailStatusUser:(NSString*)trailName {
    
}

//TODO write generic methods for these in a DBUpdate class

-(TrailStatus*)GetOffTrailStatus {
    TrailStatus *status = [[TrailStatus alloc] init];
    
    
    return status;
}

-(int)GetDbCommentRowCount {
    int rows = 0;
    
    
    return rows;
}


#pragma private methods

-(void)addOfflineTrailStatus:(TrailStatus*)trailStatus {
    
}

-(void)deleteOneOfflineTrailStatus:(int)tableId {
    
}

@end
