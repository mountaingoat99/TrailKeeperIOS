//
//  TrailMapLocations.h
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 12/20/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface TrailMapLocations : NSObject <MKAnnotation>

- (id)initWithName:(NSString*)trailName coordinate:(CLLocationCoordinate2D)coordinate;
- (MKMapItem*)mapItem;

@end
