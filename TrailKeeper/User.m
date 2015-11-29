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
//
//-(void)SignUpNewUser:(User*)newUser {
//    
//    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (!error) {
//            // call the view controller method to okay the sign up
//            // with a string success message
//            // update the authorizedUser class
//            AuthorizedCommentors *auth = [[AuthorizedCommentors alloc] init];
//            PFUser *user = [PFUser currentUser];
//            auth.userObjectId = user.objectId;
//            auth.userObjectId = user.username;
//            auth.canComment = YES;
//            [auth AddAuthorizedCommentor:auth];
//            // add user to the current installation
//            Installation *installation = [[Installation alloc] init];
//            [installation AddUserToCurrentInsallation];
//        } else {
//            // call the view controller method to okay the sign up
//            // with a string fail message
//        }
//    }];
//}

-(void)UserLogIn:(User*)user {
    [PFUser logInWithUsernameInBackground:user.username password:user.password
                                    block:^(PFUser *user, NSError *error) {
        if (!error) {
            // call the View Controller method to stop the wait spinner and
            // successfully enable the user - send back string success message
        } else {
            // call the View Controller method to stop the wait spinner and
            // let user know the reason - send back the string fail message
        }
    }];
}

-(void)UserLogOut {
    [User logOut];
}

//-(void)DeleteUserAccount {
//    PFUser *user = [PFUser currentUser];
//    [user deleteInBackground];
//    [PFUser logOut];
//}

-(void)UpdateUserName:(NSString*)newName {
    [[PFUser currentUser] setUsername:newName];
    [[PFUser currentUser] saveEventually];
}

-(void)UpdateUserEmail:(NSString*)newEmail {
    [[PFUser currentUser] setEmail:newEmail];
    [[PFUser currentUser] saveEventually];
}

-(void)ResendVerifyUserEmail:(User*)user {
    // get the real email first
    NSString *realEmail = user.email;
    // send a fake email
    [[PFUser currentUser] setEmail:@"fakeemail@gmail.com"];
    [[PFUser currentUser] saveInBackground];
    // call method to update the real email so it sends the verification again
    [self resendRealEmailAfterCreatingFake:realEmail];
}

-(void)ResetUserPassword:(User*)user {
    [PFUser requestPasswordResetForEmailInBackground:user.email];
}

-(NSString*)FindUserName:(NSString*)email {
    NSString *foundName = @"no result";
    PFQuery *query = [PFUser query];
    [query whereKey:@"email" equalTo:email]; // find all the women
    NSArray *userNames = [query findObjects];
    
    if (userNames.count > 0) {
        for (NSString *name in userNames) {
            foundName = name;
        }
    }
    return foundName;
}

#pragma private methods

-(void)resendRealEmailAfterCreatingFake:(NSString*)realEmail {
    [[PFUser currentUser] setEmail:realEmail];
    [[PFUser currentUser] saveInBackground];
}

@end
