//
//  CreateAccountViewController.h
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 11/26/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateAccountViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIView *viewBackground;
@property (weak, nonatomic) IBOutlet UIButton *btnSignUp;

- (IBAction)btn_CreateAccountClick:(id)sender;

@end
