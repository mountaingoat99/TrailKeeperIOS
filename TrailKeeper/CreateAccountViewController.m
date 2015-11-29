//
//  CreateAccountViewController.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 11/26/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "CreateAccountViewController.h"
#import "AlertControllerHelper.h"
#import "User.h"
#import "ConnectionDetector.h"
#import "AuthorizedCommentors.h"
#import "Installation.h"
#import "MainViewController.h"

@interface CreateAccountViewController ()

-(void)signUpForNewAccount;

@end

@implementation CreateAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewBackground.backgroundColor = [UIColor whiteColor];
    self.viewBackground.layer.masksToBounds = NO;
    self.viewBackground.layer.cornerRadius = 3.0;
    self.viewBackground.layer.shadowOffset = CGSizeMake(1, 0);
    self.viewBackground.layer.shadowOpacity = 0.5;
    
    self.txtEmail.delegate = self;
    self.txtUserName.delegate = self;
    self.txtPassword.delegate = self;
    
    self.txtEmail.leftViewMode = UITextFieldViewModeAlways;
    self.txtEmail.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"email_image.png"]];
    self.txtUserName.leftViewMode = UITextFieldViewModeAlways;
    self.txtUserName.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user_image.png"]];
    self.txtPassword.leftViewMode = UITextFieldViewModeAlways;
    self.txtPassword.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password_image"]];
    [self.txtEmail becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     if ([segue.identifier isEqualToString:@"segueCreateAccountToHome"]) {
         MainViewController *home = [segue destinationViewController];
         BOOL newUser = YES;
         home.newUser = newUser;
     }
 }


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.txtEmail) {
        [self.txtUserName becomeFirstResponder];
    }
    if (textField == self.txtUserName) {
        [self.txtPassword becomeFirstResponder];
    }
    if (textField == self.txtPassword) {
        [self signUpForNewAccount];
        //[textField resignFirstResponder];
    }
    return YES;
}


- (IBAction)btn_CreateAccountClick:(id)sender {
    [self signUpForNewAccount];
}

#pragma Private methods

-(void)signUpForNewAccount {
    NSLog(@"Pressed the Go BUtton");
    
    if ([ConnectionDetector hasConnectivity]) {
    
        if (![User isValidEmail:self.txtEmail.text]) {
            [AlertControllerHelper ShowAlert:@"Invalid Email" message:@"Please Enter a Valid Email" view:self];
            return;
        }
        if (![User isValidUserName:self.txtUserName.text]) {
            [AlertControllerHelper ShowAlert:@"Invalid User" message:@"Please Enter a Valid Username that is at least 6 characters long" view:self];
            return;
        }
        if (![User isValidPassword:self.txtPassword.text]) {
            [AlertControllerHelper ShowAlert:@"Invalid Email" message:@"Please Enter a Valid Password" view:self];
            return;
        }
        
        User *user = [[User alloc] init];
        user.email = [self.txtEmail.text  stringByTrimmingCharactersInSet:
                      [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        user.username = [self.txtUserName.text stringByTrimmingCharactersInSet:
                         [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        user.password = [self.txtPassword.text stringByTrimmingCharactersInSet:
                         [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                AuthorizedCommentors *auth = [[AuthorizedCommentors alloc] init];
                PFUser *newUser = [PFUser currentUser];
                NSLog(@"NewUser %@ ", newUser);
                auth.userObjectId = newUser.objectId;
                auth.userName = newUser.username;
                auth.canComment = YES;
                [auth AddAuthorizedCommentor:auth];
                // add user to the current installation
                Installation *installation = [[Installation alloc] init];
                [installation AddUserToCurrentInsallation];
                [self performSegueWithIdentifier:@"segueCreateAccountToHome" sender:self];
            } else {
                NSLog(@"Parse Sign-up error %@ ", [error localizedDescription]);
                [AlertControllerHelper ShowAlert:@"Hold On!" message:[error localizedDescription] view:self];
            }
        }];
    } else {
        [AlertControllerHelper ShowAlert:@"No Connection" message:@"You have no wifi or data connection" view:self];
    }
}

@end
