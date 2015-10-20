//
//  Trails.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/13/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "Trails.h"
#import <Parse/PFObject+Subclass.h>
#import "DBManager.h"
#import "TrailStatus.h"
#import "ConnectionDetector.h"

@interface Trails ()

@property (nonatomic, strong) NSString *tStatus;
@property (nonatomic, strong) DBManager *dbManager;

-(void)AddOfflineTrail:(Trails*)trail;
-(void)DeleteNewTrail:(int)tableId;
-(BOOL)getBoolValueFromNSNumber:(NSNumber *)number;
-(NSNumber*)ConvertBoolToNSNumber:(BOOL)boolValue;

@end

@implementation Trails

@synthesize tStatus;
@synthesize dbManager;

#pragma public properties

@dynamic trailName;
@dynamic status;
@dynamic mapLink;
@dynamic city;
@dynamic state;
@dynamic country;
@dynamic length;
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
        self.length = [aDecoder decodeObjectForKey:@"length"];
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
    [aCoder encodeObject:self.length forKey:@"lenght"];
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
    
    switch ([status intValue]) {
        case 1:
            self.tStatus = @"Closed";
            break;
        case 2:
            self.tStatus = @"Open";
            break;
        case 3:
            self.tStatus = @"UnKnown";
            break;
        default:
            break;
    }
    return self.tStatus;
}

-(NSMutableArray *)GetAllTrailInfo {
    NSMutableArray *allTrails = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"Trails"];
    [query fromLocalDatastore];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"Successfully Retrieved %lu Trails", objects.count);
            // add the items to the NSArray
            for (PFObject *object in objects) {
                Trails *trail = [[Trails alloc] init];
                trail.objectId = object.objectId;
                trail.trailName = [object objectForKey:@"trailName"];
                trail.status = [object objectForKey:@"status"];
                trail.mapLink = [object objectForKey:@"mapLink"];
                trail.city = [object objectForKey:@"city"];
                trail.state = [object objectForKey:@"state"];
                trail.country = [object objectForKey:@"country"];
                trail.length = [object objectForKey:@"length"];
                trail.geoLocation = [object objectForKey:@"geoLocation"];
                trail.privateTrail = [self getBoolValueFromNSNumber:[object objectForKey:@"privateTrail"]];
                trail.skillEasy = [self getBoolValueFromNSNumber:[object objectForKey:@"skillEasy"]];
                trail.skillMedium = [self getBoolValueFromNSNumber:[object objectForKey:@"skillMedium"]];
                trail.skillHard = [self getBoolValueFromNSNumber:[object objectForKey:@"skillHard"]];
                
                [allTrails addObject:trail];
            }
            
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    return allTrails;
}

-(NSMutableArray*)GetTrailNames {
    NSMutableArray *trailNames;
    PFQuery *query = [PFQuery queryWithClassName:@"Trails"];
    [query fromLocalDatastore];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"Successfully Retrieved %lu Trails", objects.count);
            // add the items to the NSArray
            for (PFObject *object in objects) {
                Trails *trail = [[Trails alloc] init];
                trail.trailName = [object objectForKey:@"trailName"];
                
                [trailNames addObject:trail];
            }
            
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    return trailNames;
}

-(NSMutableOrderedSet*)GetTrailStates {
    NSMutableOrderedSet *trailStates;
    PFQuery *query = [PFQuery queryWithClassName:@"Trails"];
    [query fromLocalDatastore];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"Successfully Retrieved %lu Trails", objects.count);
            // add the items to the NSArray
            for (PFObject *object in objects) {
                Trails *trail = [[Trails alloc] init];
                trail.state = [object objectForKey:@"state"];
                
                // NSMustableOrderedSet only allows unique values
                [trailStates addObject:trail];
            }
            
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    return trailStates;
}

-(NSMutableArray*)getTrailsByState:(NSString*)state {
    NSMutableArray *trailsByState;
    PFQuery *query = [PFQuery queryWithClassName:@"Trails"];
    [query whereKey:@"state" equalTo:state];
    [query fromLocalDatastore];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"Successfully Retrieved %lu Trails", objects.count);
            // add the items to the NSArray
            for (PFObject *object in objects) {
                Trails *trail = [[Trails alloc] init];
                trail.objectId = object.objectId;
                trail.trailName = [object objectForKey:@"trailName"];
                trail.status = [object objectForKey:@"status"];
                trail.mapLink = [object objectForKey:@"mapLink"];
                trail.city = [object objectForKey:@"city"];
                trail.state = [object objectForKey:@"state"];
                trail.country = [object objectForKey:@"country"];
                trail.length = [object objectForKey:@"length"];
                trail.geoLocation = [object objectForKey:@"geoLocation"];
                trail.privateTrail = [self getBoolValueFromNSNumber:[object objectForKey:@"privateTrail"]];
                trail.skillEasy = [self getBoolValueFromNSNumber:[object objectForKey:@"skillEasy"]];
                trail.skillMedium = [self getBoolValueFromNSNumber:[object objectForKey:@"skillMedium"]];
                trail.skillHard = [self getBoolValueFromNSNumber:[object objectForKey:@"skillHard"]];
                
                // NSMustableOrderedSet only allows unique values
                [trailsByState addObject:trail];
            }
            
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    return trailsByState;
}

-(NSString*)GetTrailObjectId:(NSString*)trailName {
    __block NSString *trailObjectId = nil;
    PFQuery *query = [PFQuery queryWithClassName:@"Trails"];
    [query whereKey:@"trailName" equalTo:trailName];
    [query fromLocalDatastore];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"Successfully Retrieved %@ Trails", object.objectId);
            // add the items to the NSArray
            trailObjectId = object.objectId;
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    return trailObjectId;
}

-(void)CreateNewTrail:(Trails*)newTrail {
    // call the async first to check for connection
    if ([ConnectionDetector hasConnectivity]) {
        [self SaveNewTrail:newTrail];
        
    } else {
        [self AddOfflineTrail:newTrail];
    }
    
    TrailStatus *status = [[TrailStatus alloc] init];
    [status CreateNewTrailStatus:newTrail];
}

-(void)SaveNewTrail:(Trails*)newTrail {
    PFObject *trail = [PFObject objectWithClassName:@"Trails"];
    trail[@"trailName"] = newTrail.trailName;
    trail[@"status"] = newTrail.status;
    trail[@"mapLink"] = newTrail.state;
    trail[@"city"] = newTrail.city;
    trail[@"state"] = newTrail.state;
    trail[@"country"] = newTrail.country;
    trail[@"length"] = newTrail.length;
    trail[@"geoLocation"] = newTrail.geoLocation;
    trail[@"privateTrail"] = [self ConvertBoolToNSNumber:newTrail.privateTrail];
    trail[@"skillEasy"] = [self ConvertBoolToNSNumber:newTrail.skillEasy];
    trail[@"skillMedium"] = [self ConvertBoolToNSNumber:newTrail.skillMedium];
    trail[@"skillHard"] = [self ConvertBoolToNSNumber:newTrail.skillHard];
    
    [trail pinInBackground];
    [trail saveEventually];
}

-(Trails*)GetOffLineTrail {
    Trails *offlineTrail = [[Trails alloc] init];
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"offline_trails.db"];
    NSString *query = [NSString stringWithFormat:@"select * from offline_trail LIMIT 1"];
    NSArray *trail = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // get all the items from the array and out them into the trail object
    if (trail.count > 0) {
        offlineTrail.trailName = [[NSString alloc] initWithString:[[trail objectAtIndex:0] objectAtIndex:0]];
        offlineTrail.city = [[NSString alloc] initWithString:[[trail objectAtIndex:0] objectAtIndex:1]];
        offlineTrail.state = [[NSString alloc] initWithString:[[trail objectAtIndex:0] objectAtIndex:2]];
        offlineTrail.country = [[NSString alloc] initWithString:[[trail objectAtIndex:0] objectAtIndex:3]];
        NSString *length = [[NSString alloc] initWithString:[[trail objectAtIndex:0] objectAtIndex:4]];
        offlineTrail.length = [NSNumber numberWithInteger:[length integerValue]];
        double latitude = [[[NSString alloc] initWithString:[[trail objectAtIndex:0] objectAtIndex:5]] doubleValue];
        double longitude = [[[NSString alloc] initWithString:[[trail objectAtIndex:0] objectAtIndex:6]] doubleValue];
        offlineTrail.geoLocation.latitude = latitude;
        offlineTrail.geoLocation.longitude = longitude;
        NSString *status = [[NSString alloc] initWithString:[[trail objectAtIndex:0] objectAtIndex:7]];
        offlineTrail.status = [NSNumber numberWithInteger:[status integerValue]];
        offlineTrail.skillEasy = [[[NSString alloc] initWithString:[[trail objectAtIndex:0] objectAtIndex:8]] boolValue];
        offlineTrail.skillMedium = [[[NSString alloc] initWithString:[[trail objectAtIndex:0] objectAtIndex:9]] boolValue];
        offlineTrail.skillHard = [[[NSString alloc] initWithString:[[trail objectAtIndex:0] objectAtIndex:10]] boolValue];
        offlineTrail.privateTrail = [[[NSString alloc] initWithString:[[trail objectAtIndex:0] objectAtIndex:11]] boolValue];
    }
    return offlineTrail;
}

-(NSNumber*)GetDbTrailsRowCount {
    NSNumber *num;
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"offline_trails.db"];
    NSString *query = [NSString stringWithFormat:@"SELECT Count(*) FROM offline_trail"];
    
    return num = [self.dbManager loadNumberFromDB:query];
}

#pragma Private methods

-(void)AddOfflineTrail:(Trails*)trail {
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"offline_trails.db"];
    NSString *query = [NSString stringWithFormat:@"insert into offline_trail(name, city, state, country, length, latitude, longitude, status, easy, medium, hard, private) values('%@','%@','%@','%@','%@','%f','%f','%@','%@','%@','%@','%@')",
             trail.trailName,
             trail.city,
             trail.state,
             trail.country,
             trail.length,
             trail.geoLocation.latitude,
             trail.geoLocation.longitude,
             trail.status,
             [self ConvertBoolToNSNumber:trail.skillEasy],
             [self ConvertBoolToNSNumber:trail.skillMedium],
             [self ConvertBoolToNSNumber:trail.skillHard],
             [self ConvertBoolToNSNumber:trail.privateTrail]];
    
    [self.dbManager executeQuery:query];
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"AddOffLineTrail query has been successfully inserted. Rows: %d", self.dbManager.affectedRows);
    } else {
        NSLog(@"AddOffLineTrail query has failed");
    }
}

-(void)DeleteNewTrail:(int)tableId {
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"offline_trails.db"];
    NSString *query = [NSString stringWithFormat:@"delete from offline_trail where id=%d", tableId];
    [self.dbManager executeQuery:query];
}

-(BOOL)getBoolValueFromNSNumber:(NSNumber *)number {
    return [number boolValue];
}

-(NSNumber*)ConvertBoolToNSNumber:(BOOL)boolValue {
    return [NSNumber  numberWithBool:boolValue];
}

@end
