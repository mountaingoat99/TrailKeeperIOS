//
//  GeoLocationHelper.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/11/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "GeoLocationHelper.h"
#import "AppDelegate.h"

@interface GeoLocationHelper ()

@end

@implementation GeoLocationHelper

+(double)GetDistanceFromCurrentLocation:(PFGeoPoint*)userLocation traillocation:(PFGeoPoint*)trailLocation {
    double distance = 0.0;
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    if ([[preferences objectForKey:@"userMeasurements"] isEqualToString:@"imperial"]) {
        distance = [userLocation distanceInMilesTo:trailLocation];
    } else {
        distance = [userLocation distanceInKilometersTo:trailLocation];
    }
    return distance;
}

+(PFGeoPoint*)GetUsersCurrentPostion {
    PFGeoPoint *location = nil;
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    CLLocation *userLocation = appDelegate.locationManager.location;
    NSLog(@"GeoLocationHelper userLocation: %f, %f", userLocation.coordinate.latitude, userLocation.coordinate.longitude);
    
    if (userLocation != nil) {
        location = [PFGeoPoint geoPointWithLocation:userLocation];
    } else {
        location = [PFGeoPoint geoPointWithLatitude:42.566763 longitude:-87.887405];   // default location if we don't have users
    }    
    return location;
}



@end
