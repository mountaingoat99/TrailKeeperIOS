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

#pragma properties

@dynamic userObjectId;
@dynamic userName;
@dynamic canComment;

#pragma init methods

+(void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return @"AuthorizedCommentors";
}

#pragma public methods

-(void)AddAuthorizedCommentor:(NSString*)userObjectId {
    
}

@end
