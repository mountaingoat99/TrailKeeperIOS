//
//  GetTrailPinViewController.h
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 11/1/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "HTAutocompleteManager.h"

@interface GetTrailPinViewController : UIViewController <UITextFieldDelegate,MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contraintTxtUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblMessageText;
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (unsafe_unretained, nonatomic) IBOutlet HTAutocompleteTextField *txtTrailname;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtReason;
@property (weak, nonatomic) IBOutlet UIButton *btnSignUp;

- (IBAction)btn_drawerClick:(id)sender;
- (IBAction)btn_signUpClick:(id)sender;

@end
