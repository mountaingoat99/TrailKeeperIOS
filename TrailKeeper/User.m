//
//  User.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/13/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "User.h"
#import <Parse/PFObject+Subclass.h>

@implementation User

#pragma properties

@dynamic emailVerified;

#pragma init methods

-(id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        self.emailVerified = [aDecoder decodeBoolForKey:@"emailVerified"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeBool:self.emailVerified forKey:@"emailVerified"];
}


+(void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return @"User";
}

#pragma Class Methods

+(BOOL)isAnonUser {
    
    return false;
}

+(BOOL)isEmailVerified:(User*)user {
    
    return false;
}

+(BOOL)isValidUserName:(NSString*)userName {
    
    return false;
}

+(BOOL)isValidEmail:(NSString*)userEmail {
    
    return false;
}

+(BOOL)isValidPassword:(NSString*)userPassword {
    
    return false;
}


#pragma public methods

-(NSString*)SignUpNewUser:(User*)newUser {
    __block NSString *errorString;
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            errorString = @"success";
        } else {
            errorString = [error userInfo][@"error"];
        }
    }];
    return errorString;
}

-(BOOL)UserLogIn:(User*)user {
    
    return false;
}

-(BOOL)UserLogOut:(User*)user {
    
    return false;
}

-(BOOL)DeleteUserAccount:(User*)user {
    
    return false;
}

-(BOOL)UpdateUserName:(User*)user NewName:(NSString*)newName {
    
    return false;
}

-(BOOL)UpdateUserEmail:(User*)user NewEmail:(NSString*)newEmail {
    
    return false;
}

-(BOOL)ResendVerifyUserEmail:(User*)user {
    // send a fake email
    
    return false;
}

-(BOOL)resendRealEmailAfterCreatingFake:(NSString*)realEmail {
    // then send a real one
    
    return false;
}

-(BOOL)ResetUserPassword:(User*)user {
    
    return false;
}

-(NSString*)FindUserName:(User*)user {
    
    return @"";
}

-(void)CreateAnonUser {
    
}

@end
