//
//  UpdateAccountViewController.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 11/26/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "UpdateAccountViewController.h"
#import "User.h"
#import "ConnectionDetector.h"
#import "AlertControllerHelper.h"

@interface UpdateAccountViewController ()

@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) UIAlertController *alertSpinner;

-(void)showWait;
-(void)updateEmail;
-(void)verifyEmail;
-(void)updateUserName;
-(void)updatePassword;


@end

@implementation UpdateAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewBackground.backgroundColor = [UIColor whiteColor];
    self.viewBackground.layer.masksToBounds = NO;
    self.viewBackground.layer.cornerRadius = 3.0;
    self.viewBackground.layer.shadowOffset = CGSizeMake(1, 0);
    self.viewBackground.layer.shadowOpacity = 0.5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btn_updateEmailClick:(id)sender {
    [self updateEmail];
}

- (IBAction)btn_VerifyPasswordClick:(id)sender {
    [self verifyEmail];
}

- (IBAction)btn_UpdateUsernameClick:(id)sender {
    [self updateUserName];
}

- (IBAction)btn_UpdatePasswordClick:(id)sender {
    [self updatePassword];
}

#pragma private methods

-(void)updateEmail {
    if ([ConnectionDetector hasConnectivity]) {
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:@"Update Email"
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
                                       NSLog(@"Update Email Ok Action");
                                       UITextField *email = alert.textFields.firstObject;
                                       if ([User isValidEmail:[email.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]) {
                                        
                                           User *user = [[User alloc] init];
                                           [user UpdateUserEmail:[email.text stringByTrimmingCharactersInSet:
                                                                  [NSCharacterSet whitespaceAndNewlineCharacterSet]]];
                                           [self.alertSpinner dismissViewControllerAnimated:YES completion:nil];
                                           NSString *newEmail = [NSString stringWithFormat:@"Email has been changed to %@ ", email.text];
                                           [AlertControllerHelper ShowAlert:@"New Email" message:newEmail view:self];
                                       } else {
                                           [self.alertSpinner dismissViewControllerAnimated:YES completion:nil];
                                           [AlertControllerHelper ShowAlert:@"Not Valid" message:@"Please enter a valid email address" view:self];
                                       }
                                    }];
        
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [AlertControllerHelper ShowAlert:@"No Connection!" message:@"You will need a WIFI or Data Connection first" view:self];
    }
}

-(void)verifyEmail {
    if ([ConnectionDetector hasConnectivity]) {
        User *user = [[User alloc] init];
        [user ResendVerifyUserEmail];
        [AlertControllerHelper ShowAlert:@"Email Sent" message:@"Please check your email and click on the link to verify your email" view:self];
    } else {
        [AlertControllerHelper ShowAlert:@"No Connection!" message:@"You will need a WIFI or Data Connection first" view:self];
    }
}

-(void)updateUserName {
    if ([ConnectionDetector hasConnectivity]) {
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:@"Update Username"
                                    message:nil
                                    preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Username";
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
                                       NSLog(@"Update userName Ok Action");
                                       UITextField *userName = alert.textFields.firstObject;
                                       if ([User isValidUserName:[userName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]) {
                                           
                                           User *user = [[User alloc] init];
                                           [user UpdateUserEmail:[userName.text stringByTrimmingCharactersInSet:
                                                                  [NSCharacterSet whitespaceAndNewlineCharacterSet]]];
                                           [self.alertSpinner dismissViewControllerAnimated:YES completion:nil];
                                           NSString *newUsername = [NSString stringWithFormat:@"Username has been changed to %@ ", userName.text];
                                           [AlertControllerHelper ShowAlert:@"New Username" message:newUsername view:self];
                                       } else {
                                           [self.alertSpinner dismissViewControllerAnimated:YES completion:nil];
                                           [AlertControllerHelper ShowAlert:@"Not Valid" message:@"Please enter a valid Username at least 6 digits long" view:self];
                                       }
                                   }];
        
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [AlertControllerHelper ShowAlert:@"No Connection!" message:@"You will need a WIFI or Data Connection first" view:self];
    }
}

-(void)updatePassword {
    if ([ConnectionDetector hasConnectivity]) {
        [self showWait];
        PFUser *pfUser = [[PFUser currentUser] fetch];
        PFQuery *query = [PFUser query];
        [query whereKey:@"username" equalTo:pfUser.username];
        PFUser *user = [query getFirstObject];
        NSString *realEmail = user.email;
        
        [PFUser requestPasswordResetForEmailInBackground:realEmail];
        [self.alertSpinner dismissViewControllerAnimated:YES completion:nil];
        [AlertControllerHelper ShowAlert:@"Password Reset" message:@"Please check your email to reset your password" view:self];
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
