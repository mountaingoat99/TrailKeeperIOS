//
//  User.h
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/13/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import <Parse/Parse.h>

@interface User : PFUser<PFSubclassing, NSCoding>

@property (nonatomic) BOOL emailVerified;

//+ (NSString *)parseClassName;
+(BOOL)isParseUser;
+(BOOL)isAnonUser;
+(BOOL)isEmailVerified:(User*)user;
+(BOOL)isValidUserName:(NSString*)userName;
+(BOOL)isValidEmail:(NSString*)userEmail;
+(BOOL)isValidPassword:(NSString*)userPassword;

-(void)UserLogOut;
-(void)UpdateUserName:(NSString*)newName;
-(void)UpdateUserEmail:(NSString*)newEmail;
-(void)ResendVerifyUserEmail; // send a new fake email
-(NSString*)FindUserName:(NSString*)email ;

@end
