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

-(id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        self.trailName = [aDecoder decodeObjectForKey:@"trailName"];
        self.status = [aDecoder decodeObjectForKey:@"status"];
        self.mapLink = [aDecoder decodeObjectForKey:@"mapLink"];
        self.city = [aDecoder decodeObjectForKey:@"city"];
        self.state = [aDecoder decodeObjectForKey:@"state"];
        self.country = [aDecoder decodeObjectForKey:@"country"];
        self.geoLocation = [aDecoder decodeObjectForKey:@"geoLocation"];
        self.privateTrail = [aDecoder decodeBoolForKey:@"privateTrail"];
        self.skillEasy = [aDecoder decodeBoolForKey:@"skillEasy"];
        self.skillMedium = [aDecoder decodeBoolForKey:@"skillMedium"];
        self.skillHard = [aDecoder decodeBoolForKey:@"skillHard"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.trailName forKey:@"trailName"];
    [aCoder encodeObject:self.status forKey:@"status"];
    [aCoder encodeObject:self.mapLink forKey:@"mapLink"];
    [aCoder encodeObject:self.city forKey:@"city"];
    [aCoder encodeObject:self.state forKey:@"state"];
    [aCoder encodeObject:self.country forKey:@"country"];
    [aCoder encodeObject:self.geoLocation forKey:@"geoLocation"];
    [aCoder encodeBool:self.privateTrail forKey:@"privateTrail"];
    [aCoder encodeBool:self.skillEasy forKey:@"skillEasy"];
    [aCoder encodeBool:self.skillMedium forKey:@"skillMedium"];
    [aCoder encodeBool:self.skillHard forKey:@"skillHard"];
}

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
