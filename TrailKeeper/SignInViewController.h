//
//  SignInViewController.h
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 11/26/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIView *viewBackground;

- (IBAction)btn_SignInClick:(id)sender;
- (IBAction)btn_ResetPasswordClick:(id)sender;
- (IBAction)btn_FindUserNameClick:(id)sender;

@end
