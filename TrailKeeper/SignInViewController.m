//
//  SignInViewController.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 11/26/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "SignInViewController.h"
#import "ConnectionDetector.h"
#import "AlertControllerHelper.h"
#import "User.h"
#import "MainViewController.h"
#import "Installation.h"

@interface SignInViewController ()

-(void)signInToAccount;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewBackground.backgroundColor = [UIColor whiteColor];
    self.viewBackground.layer.masksToBounds = NO;
    self.viewBackground.layer.cornerRadius = 3.0;
    self.viewBackground.layer.shadowOffset = CGSizeMake(1, 0);
    self.viewBackground.layer.shadowOpacity = 0.5;
    
    self.txtUserName.delegate = self;
    self.txtPassword.delegate = self;
    
    self.txtUserName.leftViewMode = UITextFieldViewModeAlways;
    self.txtUserName.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user_image.png"]];
    self.txtPassword.leftViewMode = UITextFieldViewModeAlways;
    self.txtPassword.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password_image"]];
    [self.txtUserName becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.txtUserName) {
        [self.txtPassword becomeFirstResponder];
    }
    if (textField == self.txtPassword) {
        [self signInToAccount];
    }
    return YES;
}

- (IBAction)btn_SignInClick:(id)sender {
    [self signInToAccount];
}

- (IBAction)btn_ResetPasswordClick:(id)sender {
}

- (IBAction)btn_FindUserNameClick:(id)sender {
}

#pragma private methods

-(void)signInToAccount {
    if ([ConnectionDetector hasConnectivity]) {
        if (![User isValidUserName:self.txtUserName.text]) {
            [AlertControllerHelper ShowAlert:@"Invalid User" message:@"Please Enter a Valid Username that is at least 6 characters long" view:self];
            return;
        }
        if (![User isValidPassword:self.txtPassword.text]) {
            [AlertControllerHelper ShowAlert:@"Invalid Email" message:@"Please Enter a Valid Password" view:self];
            return;
        }
        
        [PFUser logInWithUsernameInBackground:
         [self.txtUserName.text stringByTrimmingCharactersInSet:
          [NSCharacterSet whitespaceAndNewlineCharacterSet]] password:[self.txtPassword.text stringByTrimmingCharactersInSet:
                [NSCharacterSet whitespaceAndNewlineCharacterSet]]
                                        block:^(PFUser *user, NSError *error) {
            if (error == nil) {
                Installation *installation = [[Installation alloc] init];
                [installation AddUserToCurrentInsallation];

                //[self.navigationController popViewControllerAnimated:YES];
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else {
                NSLog(@"Parse Sign-in error %@ ", [error localizedDescription]);
                [AlertControllerHelper ShowAlert:@"Hold On!" message:[error localizedDescription] view:self];
            }
        }];
        
    } else {
        [AlertControllerHelper ShowAlert:@"No Connection" message:@"You have no wifi or data connection" view:self];
    }
}

@end
