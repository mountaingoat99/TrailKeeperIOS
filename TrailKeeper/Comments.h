//
//  Comments.h
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/13/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import <Parse/Parse.h>

@interface Comments : PFObject<PFSubclassing, NSCoding>

+ (NSString *)parseClassName;

@property (nonatomic, strong) NSString *trailObjectId;
@property (nonatomic, strong) NSString *trailName;
@property (nonatomic, strong) NSString *userObjectId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *comment;

@end
