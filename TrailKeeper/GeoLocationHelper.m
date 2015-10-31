//
//  GeoLocationHelper.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/11/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "GeoLocationHelper.h"

@implementation GeoLocationHelper

+(NSArray*)GetClosestTrailsForHomeScreen:(PFGeoPoint*)currentLocation {
        
    // User's location
    PFGeoPoint *userGeoPoint = [self GetUsersCurrentPostion];
    // Create a query for places
    PFQuery *query = [PFQuery queryWithClassName:@"Trails"];
    [query fromLocalDatastore];
    // Interested in locations near user.
    [query whereKey:@"geoLocation" nearGeoPoint:userGeoPoint];
    // Limit what could be a lot of points.
    query.limit = 5;
    // Final list of objects
    NSArray *trails = [query findObjects];
    
    return trails;
}

+(NSArray*)GetClosestTrailsForMap:(PFGeoPoint*)currentLocation {
    
    // User's location
    PFGeoPoint *userGeoPoint = [self GetUsersCurrentPostion];
    // Create a query for places
    PFQuery *query = [PFQuery queryWithClassName:@"Trails"];
    [query fromLocalDatastore];
    // Interested in locations near user.
    [query whereKey:@"geoLocation" nearGeoPoint:userGeoPoint];
    // Limit what could be a lot of points.
    //query.limit = 5;
    // Final list of objects
    NSArray *trails = [query findObjects];
    
    return trails;
    
}

+(PFGeoPoint*)GetUsersCurrentPostion {
    __block PFGeoPoint *location = nil;
    
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            location = geoPoint;
        } else {
            NSLog(@"Could not get users location");
        }
    }];
    
    return location;
}

@end
