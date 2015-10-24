//
//  Installation.h
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/13/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import <Parse/Parse.h>

@interface Installation : PFInstallation<PFSubclassing, NSCoding>

+ (NSString *)parseClassName;

@property (nonatomic, strong) NSArray *user;
@property (nonatomic, strong) NSArray *userName;

+(BOOL)isSubscribedToChannel:(NSString*)channelName;

-(void)SubscribeToChannel:(NSString*)trailName Choice:(BOOL)choice;
-(void)AddUserToCurrentInsallation;
-(NSArray*)GetUserChannels;

@end
