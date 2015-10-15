//
//  Comments.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/13/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "Comments.h"
#import <Parse/PFObject+Subclass.h>

@interface Comments ()

-(void)addOfflineComment:(Comments*)comment;
-(void)deleteOneOfflineComment:(int)tableId;

@end

@implementation Comments

@dynamic trailObjectId;
@dynamic trailName;
@dynamic userObjectId;
@dynamic userName;
@dynamic comment;

+(void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return @"Comments";
}

@end
