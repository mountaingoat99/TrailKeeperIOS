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
+(BOOL)isAnonUser;
+(BOOL)isEmailVerified:(User*)user;
+(BOOL)isValidUserName:(NSString*)userName;
+(BOOL)isValidEmail:(NSString*)userEmail;
+(BOOL)isValidPassword:(NSString*)userPassword;

-(NSString*)SignUpNewUser:(User*)newUser;
-(BOOL)UserLogIn:(User*)user;
-(BOOL)UserLogOut:(User*)user;
-(BOOL)DeleteUserAccount:(User*)user;
-(BOOL)UpdateUserName:(User*)user NewName:(NSString*)newName;
-(BOOL)UpdateUserEmail:(User*)user NewEmail:(NSString*)newEmail;
-(BOOL)ResendVerifyUserEmail:(User*)user;  // send a new fake email
-(BOOL)resendRealEmailAfterCreatingFake:(NSString*)realEmail;
-(BOOL)ResetUserPassword:(User*)user;
-(NSString*)FindUserName:(User*)user;
-(void)CreateAnonUser;

@end
