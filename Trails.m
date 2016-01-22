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
#import "AppDelegate.h"
#import "StateListHelper.h"

@interface Trails ()

@property (nonatomic, strong) DBManager *dbManager;

-(void)AddOfflineTrail:(Trails*)trail;
-(void)AddOfflineTrailStatus:(NSString*)objectid Choice:(NSNumber*)choice;

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
@dynamic distanceFromUser;
@dynamic lastUpdatedByUserObjectId;

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
        self.distanceFromUser = [aDecoder decodeDoubleForKey:@"distanceFromUser"];
        self.lastUpdatedByUserObjectId = [aDecoder decodeObjectForKey:@"lastUpdatedByUserObjectId"];
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
    [aCoder encodeObject:self.length forKey:@"length"];
    [aCoder encodeObject:self.geoLocation forKey:@"geoLocation"];
    [aCoder encodeBool:self.privateTrail forKey:@"privateTrail"];
    [aCoder encodeBool:self.skillEasy forKey:@"skillEasy"];
    [aCoder encodeBool:self.skillMedium forKey:@"skillMedium"];
    [aCoder encodeBool:self.skillHard forKey:@"skillHard"];
    [aCoder encodeDouble:self.distanceFromUser forKey:@"distanceFromUser"];
    [aCoder encodeObject:self.lastUpdatedByUserObjectId forKey:@"lastUpdatedByUserObjectId"];
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

-(NSMutableArray*)GetAllTrailLocationsByDistance; {
    NSMutableArray *trailLocations = [[NSMutableArray alloc] init];
    // User's location
    PFGeoPoint *userGeoPoint = [GeoLocationHelper GetUsersCurrentPostion];
    // Create a query for places
    PFQuery *query = [PFQuery queryWithClassName:@"Trails"];
    [query fromLocalDatastore];
    // Interested in locations near user.
    [query whereKey:@"geoLocation" nearGeoPoint:userGeoPoint];
    NSArray * _Nullable objects = [query findObjects];
    
    for (PFObject *object in objects) {
        Trails *trail = [[Trails alloc] init];
        trail.trailName = [object objectForKey:@"trailName"];
        trail.status = [object objectForKey:@"status"];
        trail.mapLink = [object objectForKey:@"mapLink"];
        trail.city = [object objectForKey:@"city"];
        trail.state = [object objectForKey:@"state"];
        trail.country = [object objectForKey:@"country"];
        trail.length = [object objectForKey:@"distance"];
        trail.geoLocation = [object objectForKey:@"geoLocation"];
        trail.privateTrail = [Converters getBoolValueFromNSNumber:[object objectForKey:@"private"]];
        trail.skillEasy = [Converters getBoolValueFromNSNumber:[object objectForKey:@"skillEasy"]];
        trail.skillMedium = [Converters getBoolValueFromNSNumber:[object objectForKey:@"skillMedium"]];
        trail.skillHard = [Converters getBoolValueFromNSNumber:[object objectForKey:@"skillHard"]];
        trail.distanceFromUser = [GeoLocationHelper GetDistanceFromCurrentLocation:userGeoPoint traillocation:trail.geoLocation];
        
        [trailLocations addObject:trail];
    }
    
    // sort the array by distance
    NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distanceFromUser" ascending:YES];
    [trailLocations sortUsingDescriptors:[NSArray arrayWithObject:valueDescriptor]];
    
    return trailLocations;
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
        trail.length = [object objectForKey:@"distance"];
        trail.geoLocation = [object objectForKey:@"geoLocation"];
        trail.privateTrail = [Converters getBoolValueFromNSNumber:[object objectForKey:@"private"]];
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
        trail.length = [object objectForKey:@"distance"];
        trail.geoLocation = [object objectForKey:@"geoLocation"];
        trail.privateTrail = [Converters getBoolValueFromNSNumber:[object objectForKey:@"private"]];
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
                trail.length = [object objectForKey:@"distance"];
                trail.geoLocation = [object objectForKey:@"geoLocation"];
                trail.privateTrail = [Converters getBoolValueFromNSNumber:[object objectForKey:@"private"]];
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

-(void)UpdateTrailStatus:(NSString*)objectId Choice:(NSNumber*)choice {
    if ([ConnectionDetector hasConnectivity]) {
        [self SaveNewTrailStatus:objectId Choice:choice];
    } else {
        [self AddOfflineTrailStatus:objectId Choice:choice];
    }
}

-(void)SaveNewTrailStatus:(NSString*)objectId Choice:(NSNumber*)choice {
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Trails"];
    [query fromLocalDatastore];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:objectId block:^(PFObject *trail, NSError *error) {
        trail[@"lastUpdatedByUserObjectId"] = user.objectId;
        trail[@"status"] = choice;
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
    NSLog(@"Save New Trail Method - TrailName: %@, status: %@, mapLink: %@, city: %@ state: %@, country: %@, distance: %@, lat: %f, long: %f, private: %@, skillEasy: %@, skillMedium: %@, skillHard: %@, ",
          newTrail.trailName, newTrail.status, newTrail.mapLink, newTrail.city, newTrail.state, newTrail.country, newTrail.length, newTrail.geoLocation.latitude, newTrail.geoLocation.longitude,
          [Converters ConvertBoolToNSNumber:newTrail.privateTrail], [Converters ConvertBoolToNSNumber:newTrail.skillEasy], [Converters ConvertBoolToNSNumber:newTrail.skillMedium], [Converters ConvertBoolToNSNumber:newTrail.skillHard]);
    trail[@"trailName"] = newTrail.trailName;
    trail[@"status"] = newTrail.status;
    trail[@"mapLink"] = newTrail.state;
    trail[@"city"] = newTrail.city;
    trail[@"state"] = [StateListHelper GetStateAbbreviation:newTrail.state];
    trail[@"country"] = newTrail.country;
    trail[@"distance"] = newTrail.length;
    trail[@"geoLocation"] = [PFGeoPoint geoPointWithLatitude:newTrail.geoLocation.latitude longitude:newTrail.geoLocation.longitude];
    //trail[@"geoLocation"] = newTrail.geoLocation;
    trail[@"private"] = [Converters ConvertBoolToNSNumber:newTrail.privateTrail];
    trail[@"skillEasy"] = [Converters ConvertBoolToNSNumber:newTrail.skillEasy];
    trail[@"skillMedium"] = [Converters ConvertBoolToNSNumber:newTrail.skillMedium];
    trail[@"skillHard"] = [Converters ConvertBoolToNSNumber:newTrail.skillHard];
    trail[@"lastUpdatedByUserObjectId"] = user.objectId;
    trail[@"createdBy"] = user.username;
    
    [trail pinInBackground];
    [trail saveInBackground];
}

-(Trails*)GetOffLineTrail {
    Trails *offlineTrail = [[Trails alloc] init];
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"offline_trails.db"];
    NSString *query = [NSString stringWithFormat:@"select * from offline_trail LIMIT 1"];
    NSArray *trail = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // get all the items from the array and out them into the trail object
    if (trail.count > 0) {
        offlineTrail.trailName = [[NSString alloc] initWithString:[[trail objectAtIndex:0] objectAtIndex:1]];
        offlineTrail.city = [[NSString alloc] initWithString:[[trail objectAtIndex:0] objectAtIndex:2]];
        offlineTrail.state = [[NSString alloc] initWithString:[[trail objectAtIndex:0] objectAtIndex:3]];
        offlineTrail.country = [[NSString alloc] initWithString:[[trail objectAtIndex:0] objectAtIndex:4]];
        NSString *length = [[NSString alloc] initWithString:[[trail objectAtIndex:0] objectAtIndex:5]];
        offlineTrail.length = [NSNumber numberWithInteger:[length integerValue]];
        NSLog(@"Database trail Latitude: %@", [[NSString alloc] initWithString:[[trail objectAtIndex:0] objectAtIndex:6]]);
        NSLog(@"Database trail Longitude: %@", [[NSString alloc] initWithString:[[trail objectAtIndex:0] objectAtIndex:7]]);
        //offlineTrail.geoLocation = [PFGeoPoint geoPointWithLatitude:[[NSString alloc] initWithString:[[trail objectAtIndex:0] objectAtIndex:6]]
                                                          //longitude:[[NSString alloc] initWithString:[[trail objectAtIndex:0] objectAtIndex:7]]];
        
        double latitude = [[[NSString alloc] initWithString:[[trail objectAtIndex:0] objectAtIndex:6]] doubleValue];
        double longitude = [[[NSString alloc] initWithString:[[trail objectAtIndex:0] objectAtIndex:7]] doubleValue];
        offlineTrail.geoLocation = [PFGeoPoint geoPointWithLatitude:latitude longitude:longitude];
        //offlineTrail.geoLocation.latitude = latitude;
        //offlineTrail.geoLocation.longitude = longitude;
        NSString *status = [[NSString alloc] initWithString:[[trail objectAtIndex:0] objectAtIndex:8]];
        offlineTrail.status = [NSNumber numberWithInteger:[status integerValue]];
        offlineTrail.skillEasy = [[[NSString alloc] initWithString:[[trail objectAtIndex:0] objectAtIndex:9]] boolValue];
        offlineTrail.skillMedium = [[[NSString alloc] initWithString:[[trail objectAtIndex:0] objectAtIndex:10]] boolValue];
        offlineTrail.skillHard = [[[NSString alloc] initWithString:[[trail objectAtIndex:0] objectAtIndex:11]] boolValue];
        offlineTrail.privateTrail = [[[NSString alloc] initWithString:[[trail objectAtIndex:0] objectAtIndex:12]] boolValue];
    }
    NSLog(@"TrailName: %@, status: %@, mapLink: %@, city: %@ state: %@, country: %@, distance: %@, lat: %f, long: %f, private: %@, skillEasy: %@, skillMedium: %@, skillHard: %@, ",
          offlineTrail.trailName, offlineTrail.status, offlineTrail.mapLink, offlineTrail.city, offlineTrail.state, offlineTrail.country, offlineTrail.length, offlineTrail.geoLocation.latitude, offlineTrail.geoLocation.longitude,
          [Converters ConvertBoolToNSNumber:offlineTrail.privateTrail], [Converters ConvertBoolToNSNumber:offlineTrail.skillEasy], [Converters ConvertBoolToNSNumber:offlineTrail.skillMedium], [Converters ConvertBoolToNSNumber:offlineTrail.skillHard]);
    return offlineTrail;
}

-(int)GetDbTrailsRowCount {
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"offline_trails.db"];
    NSString *query = [NSString stringWithFormat:@"SELECT Count(*) FROM offline_trail"];
    
    return [[self.dbManager loadNumberFromDB:query] intValue];
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
    
    NSLog(@"Add offline trail Query: %@", query);
    [self.dbManager executeQuery:query];
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"AddOffLineTrail query has been successfully inserted. Rows: %d", self.dbManager.affectedRows);
        // set the preferences so we know to look for it later to save
        NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
        [preferences setBool:YES forKey:HasOfflineTrailKey];
    } else {
        NSLog(@"AddOffLineTrail query has failed");
    }
}

-(void)AddOfflineTrailStatus:(NSString*)objectid Choice:(NSNumber*)choice {
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"offline_trails.db"];
    NSString *query = [NSString stringWithFormat:@"insert into offline_trail_status(trailObjectId, choice) values('%@','%@')",
                       objectid, choice];
    
    NSLog(@"Add offline trail status Query: %@", query);
    [self.dbManager executeQuery:query];
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"AddOffLineTrailStatus query has been successfully inserted. Rows: %d", self.dbManager.affectedRows);
        // set the preferences so we know to look for it later to save
        NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
        [preferences setBool:YES forKey:HasOfflineTrailStatusUpdate];
    } else {
        NSLog(@"AddOffLineTrailStatus query has failed");
    }
}

-(void)DeleteNewTrail:(NSString*)trailName {
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"offline_trails.db"];
    NSString *query = [NSString stringWithFormat:@"delete from offline_trail where name='%@'", trailName];
    NSLog(@"Delete the old Trail Query: %@", query);
    [self.dbManager executeQuery:query];
}



-(Trails*)GetOffLineTrailStatus {
    Trails *offlineTrail = [[Trails alloc] init];
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"offline_trails.db"];
    NSString *query = [NSString stringWithFormat:@"select * from offline_trail_status LIMIT 1"];
    NSArray *trail = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // get all the items from the array and out them into the trail object
    if (trail.count > 0) {
        offlineTrail.objectId = [[NSString alloc] initWithString:[[trail objectAtIndex:0] objectAtIndex:1]];
        offlineTrail.status = [NSNumber numberWithInt:[[[NSString alloc] initWithString:[[trail objectAtIndex:0] objectAtIndex:2]] intValue]];
    }
    NSLog(@"TrailObjectId: %@, status: %@", offlineTrail.objectId, offlineTrail.status);
    return offlineTrail;
}

-(int)GetDbTrailStatusRowCount {
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"offline_trails.db"];
    NSString *query = [NSString stringWithFormat:@"SELECT Count(*) FROM offline_trail_status"];
    
    return [[self.dbManager loadNumberFromDB:query] intValue];
}

-(void)DeleteNewTrailStatus:(NSString*)objectId {
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"offline_trails.db"];
    NSString *query = [NSString stringWithFormat:@"delete from offline_trail_status where trailObjectId='%@'", objectId];
    NSLog(@"Delete the old Trail Query: %@", query);
    [self.dbManager executeQuery:query];
}

@end
