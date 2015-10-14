//
//  AuthorizedCommentors.h
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/13/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import <Parse/Parse.h>

@interface AuthorizedCommentors : PFObject<PFSubclassing, NSCoding>

+ (NSString *)parseClassName;

@property (nonatomic, strong) NSString *userObjectId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic) BOOL canComment;

@end
