//
//  GeoLocationHelper.h
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/11/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Trails.h"

@interface GeoLocationHelper : NSObject

+(NSArray*)GetClosestTrailsForMap:(PFGeoPoint*)currentLocation;
+(PFGeoPoint*)GetUsersCurrentPostion;

@end
