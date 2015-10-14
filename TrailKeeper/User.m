//
//  User.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/13/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "User.h"
#import <Parse/PFObject+Subclass.h>

@implementation User

+(void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return @"User";
}

@end
