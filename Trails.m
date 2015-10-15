//
//  Trails.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/13/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "Trails.h"
#import <Parse/PFObject+Subclass.h>

@interface Trails ()

@property (nonatomic, strong) NSString *tStatus;

-(void)AddOfflineTrail:(Trails*)trail;
-(void)DeleteNewTrail:(int)tableId;

@end

@implementation Trails

@synthesize tStatus;

#pragma public properties

@dynamic trailName;
@dynamic status;
@dynamic mapLink;
@dynamic city;
@dynamic state;
@dynamic country;
@dynamic geoLocation;
@dynamic privateTrail;
@dynamic skillEasy;
@dynamic skillMedium;
@dynamic skillHard;

#pragma init

+(void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return @"Trails";
}

#pragma Public methods

-(NSString *)ConvertTrailStatus:(NSNumber*)status {
    
    self.tStatus = @"";
    
    return self.tStatus;
}

-(NSArray *)GetAllTrailInfo {
    NSArray *trailInfo;
    
    
    
    return trailInfo;
}

-(NSArray*)GetTrailNames {
    NSArray *trailNames;
    
    
    return trailNames;
    
}

-(NSDictionary*)GetTrailStates {
    NSDictionary *trailStates;
    
    
    
    return trailStates;
}

-(NSArray*)getTrailsByState:(NSString*)state {
    NSArray *trailsByState;
    
    
    
    return trailsByState;
}

-(NSString*)GetTrailObjectId:(NSString*)trailName {
    NSString *trailObjectId;
    
    
    
    return trailObjectId;
}

-(void)CreateNewTrail:(Trails*)newTrail {
    
}

-(void)SaveNewTrail:(Trails*)newTrail {
    
}

-(Trails*)GetOffLineTrail {
    Trails *offlineTrail = [[Trails alloc] init];
    
    
    return offlineTrail;
}

-(int)GetDbTrailsRowCount {
    int rows = 0;
    
    
    return rows;
}

#pragma Private methods

-(void)AddOfflineTrail:(Trails*)trail {
    
}

-(void)DeleteNewTrail:(int)tableId {
    
}

@end
