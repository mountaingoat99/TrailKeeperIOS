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
#import "Converters.h"
#import "GeoLocationHelper.h"
#import "MainViewController.h"

@interface Trails ()

@property (nonatomic, strong) DBManager *dbManager;

-(void)AddOfflineTrail:(Trails*)trail;
-(void)DeleteNewTrail:(int)tableId;

@end

@implementation Trails

@synthesize dbManager;

#pragma public properties

@dynamic trailObjectId;
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
        self.trailObjectId = [aDecoder decodeObjectForKey:@"trailObjectId"];
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
    [aCoder encodeObject:self.trailObjectId forKey:@"trailObectId"];
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

+(UIImage*)GetStatusIcon:(NSNumber*)status {
    UIImage *statusImage;
    
    switch ([status intValue]) {
        case 1:
            statusImage = [UIImage imageNamed:@"closed"];
            break;
        case 2:
            statusImage = [UIImage imageNamed:@"open"];
            break;
        case 3:
            statusImage =[UIImage imageNamed:@"unknown_status"];
            break;
        default:
            break;
    }
    return statusImage;
}

+(NSString *)ConvertTrailStatus:(NSNumber*)status {
    
    NSString *statusString;
    
    switch ([status intValue]) {
        case 1:
            statusString = @"Closed";
            break;
        case 2:
            statusString = @"Open";
            break;
        case 3:
            statusString = @"UnKnown";
            break;
        default:
            break;
    }
    return statusString;
}

+(NSString *)ConvertTrailStatusForPush:(NSNumber*)status trailname:(NSString*)trailName {
    NSString *statusString;
    
    switch ([status intValue]) {
        case 1:
            statusString = @" trails are closed!";
            break;
        case 2:
            statusString = @"trails are open";
            break;
        case 3:
            statusString = [NSString stringWithFormat:@"We don't know if %@ trails are open or closed", trailName];
            break;
        default:
            break;
    }
    return statusString;
}

-(NSArray*)GetClosestTrailsForHomeScreen; {
    // User's location
    PFGeoPoint *userGeoPoint = [GeoLocationHelper GetUsersCurrentPostion];
    // Create a query for places
    PFQuery *query = [PFQuery queryWithClassName:@"Trails"];
    [query fromLocalDatastore];
    // Interested in locations near user.
    [query whereKey:@"geoLocation" nearGeoPoint:userGeoPoint];
    // Limit what could be a lot of points.
    query.limit = 5;
    NSArray * _Nullable objects = [query findObjects];
    return objects;
}

-(Trails*)GetTrailObject:(NSString*)trailObjectId {
    Trails *trail = [[Trails alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"Trails"];
    [query fromLocalDatastore];
    [query whereKey:@"objectId" equalTo:trailObjectId];
    NSArray * _Nullable objects = [query findObjects];
    
    for (PFObject *object in objects ){
        trail.trailName = [object objectForKey:@"trailName"];
        trail.status = [object objectForKey:@"status"];
        trail.mapLink = [object objectForKey:@"mapLink"];
        trail.city = [object objectForKey:@"city"];
        trail.state = [object objectForKey:@"state"];
        trail.country = [object objectForKey:@"country"];
        trail.length = [object objectForKey:@"length"];
        trail.geoLocation = [object objectForKey:@"geoLocation"];
        trail.privateTrail = [Converters getBoolValueFromNSNumber:[object objectForKey:@"privateTrail"]];
        trail.skillEasy = [Converters getBoolValueFromNSNumber:[object objectForKey:@"skillEasy"]];
        trail.skillMedium = [Converters getBoolValueFromNSNumber:[object objectForKey:@"skillMedium"]];
        trail.skillHard = [Converters getBoolValueFromNSNumber:[object objectForKey:@"skillHard"]];
    }
    return trail;
}

-(NSMutableArray *)GetAllTrailInfo {
    NSMutableArray *allTrails = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"Trails"];
    [query fromLocalDatastore];
    NSArray * _Nullable objects = [query findObjects];
    for (PFObject *object in objects) {
        Trails *trail = [[Trails alloc] init];
        NSString *parseId = object.objectId;
        trail.trailObjectId = parseId;
        //trail.objectId = object.objectId;
        trail.trailName = [object objectForKey:@"trailName"];
        trail.status = [object objectForKey:@"status"];
        trail.mapLink = [object objectForKey:@"mapLink"];
        trail.city = [object objectForKey:@"city"];
        trail.state = [object objectForKey:@"state"];
        trail.country = [object objectForKey:@"country"];
        trail.length = [object objectForKey:@"length"];
        trail.geoLocation = [object objectForKey:@"geoLocation"];
        trail.privateTrail = [Converters getBoolValueFromNSNumber:[object objectForKey:@"privateTrail"]];
        trail.skillEasy = [Converters getBoolValueFromNSNumber:[object objectForKey:@"skillEasy"]];
        trail.skillMedium = [Converters getBoolValueFromNSNumber:[object objectForKey:@"skillMedium"]];
        trail.skillHard = [Converters getBoolValueFromNSNumber:[object objectForKey:@"skillHard"]];
        
        [allTrails addObject:trail];
    }
    return allTrails;
}

-(NSString*)GetIdByTrailName:(NSString*)trailName {
    PFQuery *query = [PFQuery queryWithClassName:@"Trails"];
    [query fromLocalDatastore];
    [query whereKey:@"trailName" matchesRegex:trailName modifiers:@"i"];
    //[query whereKey:@"trailName" equalTo:trailName];
    PFObject * _Nullable trailObject = [query getFirstObject];
    return trailObject.objectId;
}

-(NSArray*)GetTrailNames {
    NSMutableArray *trailNames= [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"Trails"];
    [query fromLocalDatastore];
    NSArray * _Nullable objects = [query findObjects];
    NSLog(@"Successfully Retrieved Trails");
    // add the items to the NSArray
    for (PFObject *object in objects) {
        Trails *trail = [[Trails alloc] init];
        trail.trailName = [object objectForKey:@"trailName"];
        
        [trailNames addObject:trail.trailName];
    }
    return trailNames;
}

-(NSMutableOrderedSet*)GetTrailStates {
    NSMutableOrderedSet *trailStates;
    PFQuery *query = [PFQuery queryWithClassName:@"Trails"];
    [query fromLocalDatastore];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"Successfully Retrieved Trails");
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
            NSLog(@"Successfully Retrieved Trails");
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
                trail.privateTrail = [Converters getBoolValueFromNSNumber:[object objectForKey:@"privateTrail"]];
                trail.skillEasy = [Converters getBoolValueFromNSNumber:[object objectForKey:@"skillEasy"]];
                trail.skillMedium = [Converters getBoolValueFromNSNumber:[object objectForKey:@"skillMedium"]];
                trail.skillHard = [Converters getBoolValueFromNSNumber:[object objectForKey:@"skillHard"]];
                
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

-(void)UpdateTrailStatus:(NSString*)objectId Choice:(NSNumber*)choice TrailName:(NSString*)trailName {
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Trails"];
    [query fromLocalDatastore];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:objectId block:^(PFObject *trail, NSError *error) {
        trail[@"status"] = choice;
        //trail[@"lastUpdatedByUserObjectd"] = user.objectId;  // TODO user needs to be signed in first
        [trail pinInBackground];
        [trail saveInBackground];
     }];
}

-(void)CreateNewTrail:(Trails*)newTrail {
    // call the async first to check for connection
    if ([ConnectionDetector hasConnectivity]) {
        [self SaveNewTrail:newTrail];
        
    } else {
        [self AddOfflineTrail:newTrail];
    }
    
    TrailStatus *status = [[TrailStatus alloc] init];
    [status SaveNewTrailStatus:newTrail];
}

-(void)SaveNewTrail:(Trails*)newTrail {
    PFUser *user = [PFUser currentUser];
    PFObject *trail = [PFObject objectWithClassName:@"Trails"];
    trail[@"trailName"] = newTrail.trailName;
    trail[@"status"] = newTrail.status;
    trail[@"mapLink"] = newTrail.state;
    trail[@"city"] = newTrail.city;
    trail[@"state"] = newTrail.state;
    trail[@"country"] = newTrail.country;
    trail[@"length"] = newTrail.length;
    trail[@"geoLocation"] = newTrail.geoLocation;
    trail[@"privateTrail"] = [Converters ConvertBoolToNSNumber:newTrail.privateTrail];
    trail[@"skillEasy"] = [Converters ConvertBoolToNSNumber:newTrail.skillEasy];
    trail[@"skillMedium"] = [Converters ConvertBoolToNSNumber:newTrail.skillMedium];
    trail[@"skillHard"] = [Converters ConvertBoolToNSNumber:newTrail.skillHard];
    trail[@"lastUpdatedByUserObjectd"] = user.objectId;
    
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
             [Converters ConvertBoolToNSNumber:trail.skillEasy],
             [Converters ConvertBoolToNSNumber:trail.skillMedium],
             [Converters ConvertBoolToNSNumber:trail.skillHard],
             [Converters ConvertBoolToNSNumber:trail.privateTrail]];
    
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

@end
