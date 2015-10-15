//
//  User.h
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/13/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import <Parse/Parse.h>

@interface User : PFUser<PFSubclassing, NSCoding>

+ (NSString *)parseClassName;

@property (nonatomic) BOOL emailVerified;

-(BOOL)isEmailVerified:(User*)user;

@end
