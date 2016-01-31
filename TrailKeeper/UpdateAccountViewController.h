//
//  UpdateAccountViewController.h
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 11/26/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateAccountViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *viewBackground;
@property (weak, nonatomic) IBOutlet UIButton *btnUpdateEmail;
@property (weak, nonatomic) IBOutlet UIButton *btnVerify;
@property (weak, nonatomic) IBOutlet UIButton *btnUserName;
@property (weak, nonatomic) IBOutlet UIButton *btnPassword;

- (IBAction)btn_updateEmailClick:(id)sender;
- (IBAction)btn_VerifyPasswordClick:(id)sender;
- (IBAction)btn_UpdateUsernameClick:(id)sender;
- (IBAction)btn_UpdatePasswordClick:(id)sender;

@end
