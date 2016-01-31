//
//  GetTrailPinViewController.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 11/1/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "GetTrailPinViewController.h"
#import "AppDelegate.h"
#import "AlertControllerHelper.h"

@interface GetTrailPinViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSString *emailErrorMessage;

-(void)sendEmail;

@end

#pragma mark -

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

@implementation GetTrailPinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    // sets the default datasouce for the autocomplete text field
    [HTAutocompleteTextField setDefaultAutocompleteDataSource:[HTAutocompleteManager sharedManager]];
    // set up the autocomplete text
    self.txtTrailname.autocorrectionType = UITextAutocorrectionTypeNo;
    self.txtTrailname.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.txtTrailname.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    self.txtTrailname.autocompleteType = HTAutoCompleteTrailNames;
    self.txtTrailname.delegate = self;
    
    self.txtUsername.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.txtUsername.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    self.txtUsername.delegate = self;
    
    self.txtEmail.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.txtEmail.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    self.txtEmail.delegate = self;
    
    self.txtReason.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    self.txtReason.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    self.txtReason.delegate = self;
    
    PFUser *user = [PFUser currentUser];
    self.txtUsername.text = user.username;
    self.txtEmail.text = user.email;
    
    if (IS_IPHONE_6 || IS_IPHONE_6P) {
        [self.txtTrailname becomeFirstResponder];
    }
    
    [self.btnSignUp setTitleColor:self.appDelegate.colorButtons forState:UIControlStateNormal];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.txtUsername) {
        [self.txtTrailname becomeFirstResponder];
    }
    if (textField == self.txtEmail) {
        [self.txtTrailname becomeFirstResponder];
    }
    if (textField == self.txtTrailname) {
        [self.txtReason becomeFirstResponder];
    }
    if (textField == self.txtReason) {
        [self sendEmail];
        [textField resignFirstResponder];
    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (IS_IPHONE_4_OR_LESS || IS_IPHONE_5) {
        [self.lblMessageText setHidden:YES];
        [self.contraintTxtUsername setConstant:-130.0];
    }
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btn_drawerClick:(id)sender {
    if ([self.txtUsername isFirstResponder]) {
        [self.txtUsername resignFirstResponder];
    }
    if ([self.txtTrailname isFirstResponder]) {
        [self.txtTrailname resignFirstResponder];
    }
    if ([self.txtEmail isFirstResponder]) {
        [self.txtEmail resignFirstResponder];
    }
    if ([self.txtReason isFirstResponder]) {
        [self.txtReason resignFirstResponder];
    }
    
    [self.appDelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:true completion:nil];
}

- (IBAction)btn_signUpClick:(id)sender {
    [self sendEmail];
}

#pragma mark - private methods

-(void)sendEmail {
    
    NSLog(@"Trying to send contact email");
    if (self.txtUsername.text.length == 0) {
        [AlertControllerHelper ShowAlert:@"No Name" message:@"Please add your Username" view:self];
        return;
    }
    if (self.txtTrailname.text.length == 0) {
        [AlertControllerHelper ShowAlert:@"No Trail Name" message:@"Please add Trail Name first" view:self];
        return;
    }
    if (self.txtEmail.text.length == 0) {
        [AlertControllerHelper ShowAlert:@"No Email" message:@"Please add Email first" view:self];
        return;
    }
    if (self.txtReason.text.length == 0) {
        [AlertControllerHelper ShowAlert:@"No Reason" message:@"Please add reason first" view:self];
        return;
    }
    
    NSString *EmailTo = @"singlecogsoftware@outlook.com";
    NSString *subject = [NSString stringWithFormat:@"TrailKeeper Pin Request from %@", self.txtUsername.text];
    NSString *body = [NSString stringWithFormat:@"User: %@ ", self.txtUsername.text];
    body = [body stringByAppendingString:[NSString stringWithFormat:@"\nEmail: %@ ", self.txtEmail.text]];
    body = [body stringByAppendingString:[NSString stringWithFormat:@"\nTrail Pin requested for %@.", self.txtTrailname.text]];
    body = [body stringByAppendingString:[NSString stringWithFormat:@"\nReason: %@.", self.txtReason.text]];
    
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
    self.txtUsername.text = @"";
    self.txtTrailname.text = @"";
    self.txtEmail.text = @"";
    self.txtReason.text = @"";
    [self.lblMessageText setHidden:NO];
    [self.contraintTxtUsername setConstant:16.0];
}

-(void)FailedEmail {
    self.emailErrorMessage = @"Email Failed";
}
@end
