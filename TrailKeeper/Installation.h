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

@end
