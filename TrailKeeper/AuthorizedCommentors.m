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

-(id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        self.userObjectId = [aDecoder decodeObjectForKey:@"userObjectId"];
        self.userName = [aDecoder decodeObjectForKey:@"userName"];
        self.canComment = [aDecoder decodeBoolForKey:@"canComment"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.userObjectId forKey:@"emailVerified"];
    [aCoder encodeObject:self.userName forKey:@"userName"];
    [aCoder encodeBool:self.canComment forKey:@"canComment"];
}


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
