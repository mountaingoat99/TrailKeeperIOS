//
//  TrailMapLocations.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 12/20/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "TrailMapLocations.h"
#import "Trails.h"
#import "GeoLocationHelper.h"

@interface TrailMapLocations ()

@property (nonatomic, copy) NSString *trailName;
@property (nonatomic, assign) CLLocationCoordinate2D theCoordinate;

@end

@implementation TrailMapLocations

- (id)initWithName:(NSString*)name coordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init])) {
        if ([_trailName isKindOfClass:[NSString class]]) {
            self.trailName = _trailName;
        } else {
            self.trailName = @"Unknown charge";
        }
        self.theCoordinate = coordinate;
    }
    return self;
}

- (NSString *)title {
    return _trailName;
}

- (CLLocationCoordinate2D)coordinate {
    return _theCoordinate;
}

- (MKMapItem*)mapItem {
    Trails *trails = [[Trails alloc] init];
    NSArray *locs = [trails GetClosestTrailsForHomeScreen];
    
    
    NSDictionary *trailDict = @{(NSString*)locs : _trailName};
    
    MKPlacemark *placemark = [[MKPlacemark alloc]
                              initWithCoordinate:self.coordinate
                              addressDictionary:trailDict];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.title;
    
    return mapItem;
}

@end
