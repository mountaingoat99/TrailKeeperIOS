//
//  Trails.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/13/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "Trails.h"
#import <Parse/PFObject+Subclass.h>

@implementation Trails

+(void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return @"Trails";
}

@end
