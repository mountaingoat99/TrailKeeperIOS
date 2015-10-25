//
//  Installation.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/13/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "Installation.h"
#import <Parse/PFObject+Subclass.h>
#import "User.h"

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
//
//+(NSString *)parseClassName {
//    return @"Installation";
//}

#pragma public methods

+(BOOL)isSubscribedToChannel:(NSString*)channelName {
    BOOL isSubscribed = NO;
    PFInstallation *installation = [PFInstallation currentInstallation];
    NSArray *channels = [installation objectForKey:@"channels"];
    if (channels.count > 0) {
        for (NSString *channel in channels) {
            if ([channel isEqualToString:channelName]) {
                isSubscribed = YES;
            }
        }
    }
    return isSubscribed;
}

-(void)SubscribeToChannel:(NSString*)trailName Choice:(BOOL)choice {
    if (choice) {
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        [currentInstallation addUniqueObject:trailName forKey:@"channels"];
        [currentInstallation saveInBackground];
    } else {
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        [currentInstallation removeObjectsInArray:@[trailName] forKey:@"channels"];
        [currentInstallation saveInBackground];
    }
}

-(void)AddUserToCurrentInsallation {
    PFUser *currentUser = [PFUser currentUser];
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation addUniqueObject:currentUser forKey:@"user"];
    [currentInstallation saveInBackground];
}

-(NSArray*)GetUserChannels {
    PFInstallation *installation = [PFInstallation currentInstallation];
    NSArray *channels = [installation objectForKey:@"channels"];
    
    return channels;
}

@end
