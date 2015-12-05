//
//  CustomFindTrailCell.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 12/4/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "CustomFindTrailCell.h"
#import "Trails.h"
#import "GeoLocationHelper.h"

@interface CustomFindTrailCell ()

@property (nonatomic, strong) PFGeoPoint *userLocation;

@end


@implementation CustomFindTrailCell

-(void)settrails:(Trails*)newTrail {
    
    if(_trails != newTrail) {
        _trails = newTrail;
        
        // get users current location
        self.userLocation = [GeoLocationHelper GetUsersCurrentPostion];
        
        self.trailName.text = _trails.trailName;
        self.trailCity.text = _trails.city;
        PFGeoPoint *trailLocation = _trails.geoLocation;
        NSString *milesFromCurrent = [NSString stringWithFormat:@"%.2f", [GeoLocationHelper GetDistanceFromCurrentLocation:self.userLocation traillocation:trailLocation]];
        milesFromCurrent = [milesFromCurrent stringByAppendingString:@" Miles"];
        self.distance.text = milesFromCurrent;
        self.statusImage.image = [Trails GetStatusIcon:_trails.status];
    }
}

-(void)setLongPressRecognizer:(UILongPressGestureRecognizer *)newLongPressRecognizer {
    if (_longPressRecognizer != newLongPressRecognizer) {
        if (_longPressRecognizer != nil) {
            [self removeGestureRecognizer:_longPressRecognizer];
        }
        if (newLongPressRecognizer != nil) {
            [self addGestureRecognizer:newLongPressRecognizer];
        }
        _longPressRecognizer = newLongPressRecognizer;
    }
}

@end
