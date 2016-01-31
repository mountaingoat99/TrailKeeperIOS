//
//  ContactViewController.h
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 11/1/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ContactViewController : UIViewController <UITextFieldDelegate,MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtFeedback;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;

- (IBAction)btn_drawerClick:(id)sender;
- (IBAction)btn_sendClick:(id)sender;

@end
