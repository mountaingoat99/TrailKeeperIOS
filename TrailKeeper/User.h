//
//  User.h
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/13/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import <Parse/Parse.h>

@interface User : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

@end
