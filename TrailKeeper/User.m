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

#pragma properties

@dynamic emailVerified;

#pragma init methods

+(void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return @"User";
}

#pragma public methods

-(BOOL)isEmailVerified:(User*)user {
    
    
    return true;
}

@end
