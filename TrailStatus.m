//
//  TrailStatus.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/13/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "TrailStatus.h"
#import <Parse/PFObject+Subclass.h>
#include <stdlib.h>
#import "DBManager.h"

@interface TrailStatus ()

@property (nonatomic, strong) DBManager *dbManager;

-(void)addOfflineTrailStatus:(TrailStatus*)trailStatus;
-(void)deleteOneOfflineTrailStatus:(int)tableId;
-(NSNumber*)GenerateRandomPin;

@end

@implementation TrailStatus

@synthesize dbManager;

#pragma properties

@dynamic trailName;
@dynamic updateStatusPin;
@dynamic authorizedUserNames;

#pragma init methods

-(id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        self.trailName = [aDecoder decodeObjectForKey:@"trailName"];
        self.updateStatusPin = [aDecoder decodeObjectForKey:@"updateStatusPin"];
        self.authorizedUserNames = [aDecoder decodeObjectForKey:@"authorizedUserNames"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.trailName forKey:@"trailName"];
    [aCoder encodeObject:self.updateStatusPin forKey:@"updateStatusPin"];
    [aCoder encodeObject:self.authorizedUserNames forKey:@"authorizedUserNames"];
}

+(void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return @"TrailStatus";
}

#pragma public methods

-(NSString*)GetTrailPin:(NSString*)trailName {
    __block NSString *trailPin = nil;
    PFQuery *query = [PFQuery queryWithClassName:@"TrailStatus"];
    [query whereKey:@"trailName" equalTo:trailName];
    [query fromLocalDatastore];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"Successfully Retrieved %@ pin Object ID", object.objectId);
            trailPin = [object objectForKey:@"updateStatusPin"];
        } else {
            NSLog(@"Did not retrieved the trail pin");
        }
        
    }];
    return trailPin;
}

-(void)SaveNewTrailStatus:(Trails*)trailname {
    PFObject *trailS = [PFObject objectWithClassName:@"TrailStatus"];
    trailS[@"trailName"] = trailname.trailName;
    // Call method to get the random number generator
    trailS[@"updateStatusPin"] = [self GenerateRandomPin];
    
    [trailS pinInBackground];
    [trailS saveEventually];
}

-(void)UpdateTrailStatusUser:(NSString*)trailName {
    PFUser *currentUser = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"TrailStatus"];
    
    [query whereKey:@"trailName" equalTo:trailName];
    [query fromLocalDatastore];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *status, NSError *error) {
        [status addUniqueObjectsFromArray:@[currentUser.username] forKey:@"authorizedUserName"];
        [status pinInBackground];
        [status saveInBackground];
    }];
}

//TODO write generic methods for these in a DBUpdate class

-(TrailStatus*)GetOffTrailStatus {
    TrailStatus *status = [[TrailStatus alloc] init];
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"offline_trails.db"];
    NSString *query = [NSString stringWithFormat:@"select * from offline_status LIMIT 1"];
    NSArray *statusArray = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // get all the items from the array and put them into the status object
    if (statusArray.count > 0) {
        status.trailName = [[NSString alloc] initWithString:[[statusArray objectAtIndex:0] objectAtIndex:0]];
        status.updateStatusPin = [[NSString alloc] initWithString:[[statusArray objectAtIndex:0] objectAtIndex:1]];
    }
    return status;
}

-(NSNumber*)GetDbCommentRowCount {
    NSNumber *num;
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"offline_trails.db"];
    NSString *query = [NSString stringWithFormat:@"SELECT Count(*) FROM offline_status"];
    
    return num = [self.dbManager loadNumberFromDB:query];
}

#pragma private methods

-(void)addOfflineTrailStatus:(TrailStatus*)trailStatus {
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"offline_trails.db"];
    NSString *query = [NSString stringWithFormat:@"insert into offline_status(trailName, updateStatusPin) values('%@','%@')",
                       trailStatus.trailName,
                       [self GenerateRandomPin]];
    [self.dbManager executeQuery:query];
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"AddOffLineTrailStatus query has been successfully inserted. Rows: %d", self.dbManager.affectedRows);
    } else {
        NSLog(@"AddOffLineTrailStatus query has failed");
    }
}

-(void)deleteOneOfflineTrailStatus:(int)tableId {
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"offline_trails.db"];
    NSString *query = [NSString stringWithFormat:@"delete from offline_status where id=%d", tableId];
    [self.dbManager executeQuery:query];
}

-(NSNumber*)GenerateRandomPin {
    return [NSNumber numberWithInt:arc4random() % 9000 + 1000];
}

@end
