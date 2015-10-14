//
//  AuthorizedCommentors.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/13/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "AuthorizedCommentors.h"
#import <Parse/PFObject+Subclass.h>

@implementation AuthorizedCommentors

@dynamic userObjectId;
@dynamic userName;
@dynamic canComment;

+(void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return @"AuthorizedCommentors";
}

@end
