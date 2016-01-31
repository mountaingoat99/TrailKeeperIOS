//
//  ContactViewController.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 11/1/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "ContactViewController.h"
#import "AppDelegate.h"
#import "AlertControllerHelper.h"

@interface ContactViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSString *emailErrorMessage;

-(void)sendEmail;

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    self.txtName.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.txtName.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    //self.txtName.keyboardType = UIKeyboardTypeDefault;
    self.txtName.delegate = self;
    
    self.txtFeedback.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    self.txtFeedback.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    //self.txtFeedback.keyboardType = UIKeyboardTypeDefault;
    self.txtFeedback.delegate = self;
    
    PFUser *user = [PFUser currentUser];
    self.txtName.text = user.username;
    
    [self.txtFeedback becomeFirstResponder];
    
    [self.btnSend setTitleColor:self.appDelegate.colorButtons forState:UIControlStateNormal];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.txtName) {
        [self.txtFeedback becomeFirstResponder];
    }
    if (textField == self.txtFeedback) {
        [self sendEmail];
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - button events

- (IBAction)btn_drawerClick:(id)sender {
    if ([self.txtName isFirstResponder]) {
        [self.txtName resignFirstResponder];
    }
    if ([self.txtFeedback isFirstResponder]) {
        [self.txtFeedback resignFirstResponder];
    }
    [self.appDelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:true completion:nil];
}

- (IBAction)btn_sendClick:(id)sender {
    [self sendEmail];
}

#pragma mark - private methods

-(void)sendEmail {
    
    NSLog(@"Trying to send contact email");
    if (self.txtName.text.length == 0) {
        [AlertControllerHelper ShowAlert:@"No Name" message:@"Please add your Username" view:self];
        return;
    }
    if (self.txtFeedback.text.length == 0) {
        [AlertControllerHelper ShowAlert:@"No Feedback" message:@"Please add Feedback first" view:self];
        return;
    }
    
    NSString *EmailTo = @"singlecogsoftware@outlook.com";
    NSString *subject = [NSString stringWithFormat:@"TrailKeeper feedback from %@", self.txtName.text];
    NSString *body = self.txtFeedback.text;
    
    MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
    composer.mailComposeDelegate = self;
    [composer setToRecipients:@[EmailTo]];
    [composer setSubject:subject];
    [composer setMessageBody:body isHTML:NO];
    
    [[composer navigationBar] setTintColor: [UIColor whiteColor]];
    [self presentViewController:composer animated:YES completion:nil];
}

// delegate method
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            [self canceledEmail];
            break;
        case MFMailComposeResultSent:
            [self SentEmail];
            break;
        case MFMailComposeResultFailed:
            [self FailedEmail];
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    [AlertControllerHelper ShowAlert:@"" message:self.emailErrorMessage view:self];
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    // filling up
}

-(void)canceledEmail {
    self.emailErrorMessage = @"Email Cancelled";
}

-(void)SentEmail {
    self.emailErrorMessage = @"Email Sent";
    self.txtName.text = @"";
    self.txtFeedback.text = @"";
}

-(void)FailedEmail {
    self.emailErrorMessage = @"Email Failed";
}

@end
