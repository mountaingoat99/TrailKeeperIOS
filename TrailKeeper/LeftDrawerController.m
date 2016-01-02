//
//  LeftDrawerController.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 11/1/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "LeftDrawerController.h"
#import "SettingsViewController.h"
#import "SettingsHelper.h"
#import "AppDelegate.h"
#import "User.h"
#import "AlertControllerHelper.h"

@interface LeftDrawerController ()

@property (nonatomic, strong) NSArray *settingList;
@property (nonatomic) BOOL isAnonUser;
@property (nonatomic) BOOL isParseUser;

-(void)loadData;
-(void)checkForParseUser;
-(void)checkForAnonUser;

@end

@implementation LeftDrawerController

#pragma mark - setup

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tblSettings.delegate = self;
    self.tblSettings.dataSource = self;
    
    [self loadData];
    [self checkForParseUser];
    [self checkForAnonUser];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    PFUser *user = [PFUser currentUser];
    if (user != nil) {
        self.lblUserName.text = user.username;
    } else {
        self.lblUserName.text = @"No Account";
    }
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


#pragma mark - tableView

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"Choose Row %ld", (long)indexPath.row);
    // get the storyboard
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    // here we want to know the current view close the drawer if we are currently on it
    switch (indexPath.row) {
        case 0: {
            NSLog(@"Home");
            id mainView = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MainViewController"];
            UINavigationController *centerNav = [[UINavigationController alloc] initWithRootViewController:mainView];
            appDelegate.drawerController.centerViewController = centerNav;
            [appDelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
            break;
        }
        case 1: {
            NSLog(@"Find Trail");
            id mainView = [mainStoryBoard instantiateViewControllerWithIdentifier:@"FindTrailViewController"];
            UINavigationController *centerNav = [[UINavigationController alloc] initWithRootViewController:mainView];
            appDelegate.drawerController.centerViewController = centerNav;
            [appDelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
            break;
        }
        case 2: {
            NSLog(@"Comments");
            id mainView = [mainStoryBoard instantiateViewControllerWithIdentifier:@"CommentsViewController"];
            UINavigationController *centerNav = [[UINavigationController alloc] initWithRootViewController:mainView];
            appDelegate.drawerController.centerViewController = centerNav;
            [appDelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
            break;
        }
        case 3: {
            NSLog(@"Map");
            id mainView = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MapViewController"];
            UINavigationController *centerNav = [[UINavigationController alloc] initWithRootViewController:mainView];
            appDelegate.drawerController.centerViewController = centerNav;
            [appDelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
            break;
        }
        case 4: {
            if (self.isParseUser) {
                if (!self.isAnonUser) {
                    NSLog(@"Add Trail");
                    id mainView = [mainStoryBoard instantiateViewControllerWithIdentifier:@"AddTrailViewController"];
                    UINavigationController *centerNav = [[UINavigationController alloc] initWithRootViewController:mainView];
                    appDelegate.drawerController.centerViewController = centerNav;
                    [appDelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
                } else {
                    [AlertControllerHelper ShowAlert:@"Verify Email" message:@"Please verify your email first!" view:self];
                }
            } else {
                [AlertControllerHelper ShowAlert:@"No Account" message:@"Please sign up for an account in Settings and verify your email first!" view:self];
            }
            break;
        }
        case 5: {
            NSLog(@"Trail Subscriptions");
            id mainView = [mainStoryBoard instantiateViewControllerWithIdentifier:@"TrailSubscriptionsViewController"];
            UINavigationController *centerNav = [[UINavigationController alloc] initWithRootViewController:mainView];
            appDelegate.drawerController.centerViewController = centerNav;
            [appDelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
            break;
        }
        case 6: {
            NSLog(@"Account Settings");
            id accountSettings = [mainStoryBoard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
            UINavigationController *centerNav = [[UINavigationController alloc] initWithRootViewController:accountSettings];
            appDelegate.drawerController.centerViewController = centerNav;
            [appDelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
            break;
        }
        case 7: {
            if (self.isParseUser) {
                if (!self.isAnonUser) {
                    NSLog(@"Get Trail Pin");
                    id mainView = [mainStoryBoard instantiateViewControllerWithIdentifier:@"GetTrailPinViewController"];
                    UINavigationController *centerNav = [[UINavigationController alloc] initWithRootViewController:mainView];
                    appDelegate.drawerController.centerViewController = centerNav;
                    [appDelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
                } else {
                    [AlertControllerHelper ShowAlert:@"Verify Email" message:@"Please verify your email first!" view:self];
                }
            } else {
                [AlertControllerHelper ShowAlert:@"No Account" message:@"Please sign up for an account in Settings and verify your email first!" view:self];
            }
            break;
        }
        case 8: {
            NSLog(@"Contact Us");
            id mainView = [mainStoryBoard instantiateViewControllerWithIdentifier:@"ContactViewController"];
            UINavigationController *centerNav = [[UINavigationController alloc] initWithRootViewController:mainView];
            appDelegate.drawerController.centerViewController = centerNav;
            [appDelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
            break;
        }
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

#pragma mark - private methods

-(void)loadData {
    if (self.settingList != nil) {
        self.settingList = nil;
    }
    
    self.settingList = [SettingsHelper getSettingsList];
    
    [self.tblSettings reloadData];
}

-(void)checkForParseUser {
    self.isParseUser = [User isParseUser];
    NSLog(@"IsParseUser is %d ", self.isParseUser);
}

-(void)checkForAnonUser {
    self.isAnonUser = [User isAnonUser];
    NSLog(@"IsAnonUser is %d ", self.isAnonUser);
}

@end
