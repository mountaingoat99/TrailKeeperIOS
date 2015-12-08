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

@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) UIAlertController *alertSpinner;

-(void)signInToAccount;
-(void)showWait;

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
    if ([ConnectionDetector hasConnectivity]) {
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:@"Reset Password"
                                    message:nil
                                    preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Email";
            textField.keyboardAppearance = UIKeyboardAppearanceDefault;
            textField.keyboardType = UIKeyboardTypeEmailAddress;
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"Cancel"
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"Cancel Action");
                                       }];
        
        UIAlertAction *okAction = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction *action)
                                    {
                                        [self showWait];
                                        NSLog(@"Send Email for Password Reset Ok Action");
                                        UITextField *email = alert.textFields.firstObject;
                                        [PFUser requestPasswordResetForEmailInBackground:
                                            [email.text stringByTrimmingCharactersInSet:
                                             [NSCharacterSet whitespaceAndNewlineCharacterSet]]];
                                        [self.alertSpinner dismissViewControllerAnimated:YES completion:nil];
                                        [AlertControllerHelper ShowAlert:@"Password Reset" message:@"Please check your email to reset your password" view:self];
                                        
                                    }];
        
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [AlertControllerHelper ShowAlert:@"No Connection" message:@"You have no wifi or data connection" view:self];
    }
}

- (IBAction)btn_FindUserNameClick:(id)sender {
    if ([ConnectionDetector hasConnectivity]) {
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:@"Find Username"
                                    message:nil
                                    preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Email";
            textField.keyboardAppearance = UIKeyboardAppearanceDefault;
            textField.keyboardType = UIKeyboardTypeEmailAddress;
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"Cancel"
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"Cancel Action");
                                       }];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self showWait];
                                       NSLog(@"Find Username Ok Action");
                                       UITextField *email = alert.textFields.firstObject;
                                       User *user = [[User alloc] init];
                                       NSString *userName = [user FindUserName:[email.text stringByTrimmingCharactersInSet:
                                                                                [NSCharacterSet whitespaceAndNewlineCharacterSet]]];
                                       
                                       if (userName.length > 0) {
                                           NSString *userNameString = [NSString stringWithFormat:@"Username is %@ ", userName];
                                           [self.alertSpinner dismissViewControllerAnimated:YES completion:nil];
                                           [AlertControllerHelper ShowAlert:@"Username" message:userNameString view:self];
                                           self.txtUserName.text = userName;
                                       } else {
                                           [self.alertSpinner dismissViewControllerAnimated:YES completion:nil];
                                            [AlertControllerHelper ShowAlert:@"Username" message:@"We could not find a username attached to that email address" view:self];
                                       }
                                   }];
        
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [AlertControllerHelper ShowAlert:@"No Connection" message:@"You have no wifi or data connection" view:self];
    }
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
        
        [self showWait];
        
        [PFUser logInWithUsernameInBackground:
         [self.txtUserName.text stringByTrimmingCharactersInSet:
          [NSCharacterSet whitespaceAndNewlineCharacterSet]] password:[self.txtPassword.text stringByTrimmingCharactersInSet:
                [NSCharacterSet whitespaceAndNewlineCharacterSet]]
                                        block:^(PFUser *user, NSError *error) {
            if (error == nil) {
                Installation *installation = [[Installation alloc] init];
                [installation AddUserToCurrentInsallation];
                [self.alertSpinner dismissViewControllerAnimated:YES completion:nil];
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else {
                [self.alertSpinner dismissViewControllerAnimated:YES completion:nil];
                NSLog(@"Parse Sign-in error %@ ", [error localizedDescription]);
                [AlertControllerHelper ShowAlert:@"Hold On!" message:[error localizedDescription] view:self];
            }
        }];
        
    } else {
        [AlertControllerHelper ShowAlert:@"No Connection" message:@"You have no wifi or data connection" view:self];
    }
}

-(void)showWait {
    self.alertSpinner = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"Please wait\n\n\n"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinner.center = CGPointMake(130.5, 65.5);
    self.spinner.color = [UIColor blackColor];
    [self.spinner startAnimating];
    [self.alertSpinner.view addSubview:self.spinner];
    [self presentViewController:self.alertSpinner animated:NO completion:nil];
}

@end
