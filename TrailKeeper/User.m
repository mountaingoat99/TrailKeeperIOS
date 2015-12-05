//
//  User.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/13/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "User.h"
#import <Parse/PFObject+Subclass.h>
#import "AuthorizedCommentors.h"
#import "Installation.h"

@interface User ()

-(void)resendRealEmailAfterCreatingFake:(NSString*)realEmail;

@end

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
//
//+(NSString *)parseClassName {
//    return @"User";
//}

#pragma Class Methods

+(BOOL)isParseUser {
    if ([PFUser currentUser] != nil) {
        return true;
    } else {
        return false;
    }
}

+(BOOL)isAnonUser {
    NSLog(@"IsAnonUser is %d ", [PFAnonymousUtils isLinkedWithUser:[PFUser currentUser]]);
    return [PFAnonymousUtils isLinkedWithUser:[PFUser currentUser]];
}

+(BOOL)isEmailVerified:(User*)user {
    return user.emailVerified;
}

+(BOOL)isValidUserName:(NSString*)userName {
    
    if (userName.length >= 6) {
        return true;
    } else {
        return false;
    }
}

+(BOOL)isValidEmail:(NSString*)userEmail {
    
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:userEmail];
    
}

+(BOOL)isValidPassword:(NSString*)userPassword {
    
    if (userPassword.length >= 8) {
        return true;
    } else {
        return false;
    }
}


#pragma public methods

-(void)UserLogOut {
    [User logOut];
}

-(void)UpdateUserName:(NSString*)newName {
    [[PFUser currentUser] setUsername:newName];
    [[PFUser currentUser] save];
    
    // update the username in authorizedCommentors
    AuthorizedCommentors *auth = [[AuthorizedCommentors alloc] init];
    [auth UpdateAuthorizedCommentorsUserName:[PFUser currentUser].objectId Username:newName];
}

-(void)UpdateUserEmail:(NSString*)newEmail {
    [[PFUser currentUser] setEmail:newEmail];
    [[PFUser currentUser] save];
}

-(void)ResendVerifyUserEmail {  
    // get the real email first
    PFUser *pfUser = [[PFUser currentUser] fetch];
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:pfUser.username];
    PFUser *user = [query getFirstObject];
    
    NSString *realEmail = user.email;
    // send a fake email
    [[PFUser currentUser] setEmail:@"fakeemail@gmail.com"];
    NSLog(@"Current User email %@", [PFUser currentUser].email);
    [[PFUser currentUser] save];
    // call method to update the real email so it sends the verification again
    [self resendRealEmailAfterCreatingFake:realEmail];
}

-(NSString*)FindUserName:(NSString*)email {
    PFQuery *query = [PFUser query];
    [query whereKey:@"email" equalTo:email]; 
    PFUser *user = [query getFirstObject];

    return user.username;
}

#pragma private methods

-(void)resendRealEmailAfterCreatingFake:(NSString*)realEmail {
    [[PFUser currentUser] setEmail:realEmail];
    [[PFUser currentUser] save];
}

@end
