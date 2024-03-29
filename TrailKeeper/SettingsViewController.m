//
//  SettingsViewController.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 11/1/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "SettingsViewController.h"
#import "AppDelegate.h"
#import "SettingsHelper.h"
#import "User.h"
#import "AlertControllerHelper.h"
#import "AuthorizedCommentors.h"
#import "ConnectionDetector.h"
#import "AdMobView.h"

@interface SettingsViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSArray *settingList;

-(void)loadData;
-(void)goHome;
-(void)createAccount;
-(void)updateAccount;
-(void)signIn;
-(void)signOut;
-(void)deleteAccount;
-(void)resendEmailVerification;
-(void)unitsOfMeasure;
-(void)removeUserInstallations;
-(void)privacyPolicyLink;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [AdMobView GetAdMobView:self];
    
    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    self.tblSettings.delegate = self;
    self.tblSettings.dataSource = self;
    
    [self loadData];
    
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction)btn_drawerClick:(id)sender {
    [self.appDelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:true completion:nil];
}

#pragma TableView Stuff

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Choose Row %ld", (long)indexPath.row);
    
    switch (indexPath.row) {
        case 0:
            NSLog(@"Home");
            [self goHome];
            break;
        case 1:
            NSLog(@"Create Account");
            [self createAccount];
            break;
        case 2:
            NSLog(@"Update Account");
            [self updateAccount];
            break;
        case 3:
            NSLog(@"Sign-In");
            [self signIn];
            break;
        case 4:
            NSLog(@"Sign-Out");
            [self signOut];
            break;
        case 5:
            NSLog(@"Delete Account");
            [self deleteAccount];
            break;
        case 6:
            NSLog(@"Resend Email Verification");
            [self resendEmailVerification];
        case 7:
            NSLog(@"Units of Measure");
            [self unitsOfMeasure];
            break;
        case 8:
            NSLog(@"Privacy Policy");
            [self privacyPolicyLink];
            break;
        default:
            break;
    }
    
    [self.tblSettings deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = cell.contentView.backgroundColor;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.settingList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //deque the cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idCellRecord" forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.settingList objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma private Methods

-(void)loadData {
    if (self.settingList != nil) {
        self.settingList = nil;
    }
    self.settingList = [SettingsHelper getAccountSettingsList];
    
    [self.tblSettings reloadData];
}

-(void)goHome {
    [self performSegueWithIdentifier:@"segueAccountSettingsToHome" sender:self];
}

-(void)createAccount {
    PFUser *pfUser = [PFUser currentUser];
    if (pfUser == nil) {
        [self performSegueWithIdentifier:@"segueAccountSettingsToCreateAccount" sender:self];
    } else {
        [AlertControllerHelper ShowAlert:@"Hold On!" message:@"You are already signed in" view:self];
    }
}

-(void)updateAccount {
    PFUser *pfUser = [PFUser currentUser];
    if (pfUser != nil) {
        [self performSegueWithIdentifier:@"segueAccountSettingsToUpdateAccount" sender:self];
    } else {
        [AlertControllerHelper ShowAlert:@"No Current User" message:@"Please sign in first" view:self];
    }
    
}

-(void)signIn {
    PFUser *user = [PFUser currentUser];
    if (user == nil) {
        [self performSegueWithIdentifier:@"segueAccountSettingsToSignIn" sender:self];
    } else {
        [AlertControllerHelper ShowAlert:@"Hold On" message:@"You are already signed in" view:self];
    }
}

-(void)signOut {
    PFUser *pfUser = [PFUser currentUser];
    if (pfUser != nil) {
        
        NSString *name = [NSString stringWithFormat:@"Are you sure you want to sign-out?"];
        
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:name
                                    message:nil
                                    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"Cancel"
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"Cancel Action");
                                       }];
        
        UIAlertAction *yesAction = [UIAlertAction
                                    actionWithTitle:@"Yes"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction *action)
                                    {
                                        NSLog(@"Subscribe Yes Action");
                                        User *user = [[User alloc]init];
                                        [user UserLogOut];
                                        [self removeUserInstallations];
                                        [AlertControllerHelper ShowAlert:@"Goodbye" message:@"You have been signed out" view:self];
                                        
                                    }];
        
        [alert addAction:cancelAction];
        [alert addAction:yesAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [AlertControllerHelper ShowAlert:@"No Current User" message:@"There is no one to sign-out!" view:self];
    }
}

-(void)deleteAccount {
    PFUser *pfUser = [PFUser currentUser];

    if (pfUser != nil) {
        
        NSString *name = [NSString stringWithFormat:@"Are you sure you want to delete your account?"];
        
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:name
                                    message:nil
                                    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"Cancel"
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"Cancel Action");
                                       }];
        
        UIAlertAction *yesAction = [UIAlertAction
                                    actionWithTitle:@"Yes"
                                    style:UIAlertActionStyleDefault
                                    
                                    handler:^(UIAlertAction *action)
                                    {
                                        NSLog(@"Subscribe Yes Action");
                                        PFUser *user = [[PFUser currentUser] fetch];
                                        NSString  *deletedUserName = user.username;
                                        NSLog(@"IsAuthenticated %@ ", user.isAuthenticated ? @"YES" : @"NO");
                                        [user deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                            if (error == nil) {
                                                [AlertControllerHelper ShowAlert:@"Goodbye" message:@"Your account has been deleted" view:self];
                                                AuthorizedCommentors *commentors = [[AuthorizedCommentors alloc] init];
                                                [commentors DeleteAuthorizedCommentor:deletedUserName];
                                                [PFUser logOut];
                                                [self removeUserInstallations];
                                            } else {
                                                NSLog(@"Delete Account Error %@ ", [error localizedDescription]);
                                                [AlertControllerHelper ShowAlert:@"Error!" message:[error localizedDescription] view:self];
                                            }
                                        }];
                                    }];
        
        [alert addAction:cancelAction];
        [alert addAction:yesAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [AlertControllerHelper ShowAlert:@"No Current User" message:@"There is no account to delete!" view:self];
    }
}

-(void)resendEmailVerification {
    PFUser *pfUser = [PFUser currentUser];
    if (pfUser != nil) {
        if ([ConnectionDetector hasConnectivity]) {
            User *user = [[User alloc] init];
            [user ResendVerifyUserEmail];
            [AlertControllerHelper ShowAlert:@"Email Sent" message:@"Please check your email and click on the link to verify your email" view:self];
        } else {
            [AlertControllerHelper ShowAlert:@"No Connection!" message:@"You will need a WIFI or Data Connection first" view:self];
        }
        
    } else {
        [AlertControllerHelper ShowAlert:@"No Current User" message:@"You need to be signed in to resend the verification email" view:self];
    }
}

-(void)unitsOfMeasure {
    [self performSegueWithIdentifier:@"segueAccountSettingsToUnitsOfMeasure" sender:self];
}

-(void)removeUserInstallations {
    Installation *install = [[Installation alloc] init];
    NSArray *channels = [install GetUserChannels];
    for (NSString *channel in channels) {
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        [currentInstallation removeObjectsInArray:@[channel] forKey:@"channels"];
        [currentInstallation saveInBackground];
    }
}

-(void)privacyPolicyLink {
    NSLog(@"Map Link: %@", @"https://www.iubenda.com/privacy-policy/7787521");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.iubenda.com/privacy-policy/7787521"]];
}

@end
