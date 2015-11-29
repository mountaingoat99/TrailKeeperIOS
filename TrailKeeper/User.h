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

+ (NSString *)parseClassName;
+(BOOL)isParseUser;
+(BOOL)isAnonUser;
+(BOOL)isEmailVerified:(User*)user;
+(BOOL)isValidUserName:(NSString*)userName;
+(BOOL)isValidEmail:(NSString*)userEmail;
+(BOOL)isValidPassword:(NSString*)userPassword;

//-(void)SignUpNewUser:(User*)newUser;
//-(void)UserLogIn:(User*)user;
-(void)UserLogOut;
//-(void)DeleteUserAccount;
-(void)UpdateUserName:(NSString*)newName;
-(void)UpdateUserEmail:(NSString*)newEmail;
-(void)ResendVerifyUserEmail:(User*)user;  // send a new fake email
-(void)ResetUserPassword:(User*)user;
-(NSString*)FindUserName:(NSString*)email ;

@end
