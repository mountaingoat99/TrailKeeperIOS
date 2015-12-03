//
//  AuthorizedCommentors.h
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/13/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import <Parse/Parse.h>

@interface AuthorizedCommentors : PFObject<PFSubclassing, NSCoding>

@property (nonatomic, strong) NSString *userObjectId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic) BOOL canComment;

+ (NSString *)parseClassName;

-(void)AddAuthorizedCommentor:(AuthorizedCommentors*)commentor;
-(void)UpdateAuthorizedCommentorsUserName:(NSString*)objectId Username:(NSString*)username;
-(void)DeleteAuthorizedCommentor:(NSString*)userName;

@end
