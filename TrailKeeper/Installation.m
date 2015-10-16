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

-(id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        self.user = [aDecoder decodeObjectForKey:@"user"];
        self.userName = [aDecoder decodeObjectForKey:@"userName"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.user forKey:@"user"];
    [aCoder encodeObject:self.userName forKey:@"userName"];
}


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
