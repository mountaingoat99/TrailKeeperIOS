//
//  Installation.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/13/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "Installation.h"
#import <Parse/PFObject+Subclass.h>

@implementation Installation

#pragma Properties

@dynamic user;
@dynamic userName;

#pragma init methods

+(void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return @"Installation";
}

#pragma public methods

-(void)SubscribeToChannel:(NSString*)trailName Choice:(BOOL)choice {
    
}

-(BOOL)isSubscribedToChannel:(NSString*)channelName {
    
    
    return true;
}

@end
