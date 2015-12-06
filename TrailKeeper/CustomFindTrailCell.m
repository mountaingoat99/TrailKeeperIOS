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

@end


@implementation CustomFindTrailCell

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
