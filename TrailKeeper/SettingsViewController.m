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

@interface SettingsViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSArray *settingList;

-(void)loadData;
-(void)createAccount;
-(void)updateAccount;
-(void)signIn;
-(void)signOut;
-(void)deleteAccount;
-(void)unitsOfMeasure;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    self.tblSettings.delegate = self;
    self.tblSettings.dataSource = self;
    
    [self loadData];
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
            NSLog(@"Create Account");
            [self createAccount];
            break;
        case 1:
            NSLog(@"Update Account");
            [self updateAccount];
            break;
        case 2:
            NSLog(@"Sign-In");
            [self signIn];
            break;
        case 3:
            NSLog(@"Sign-Out");
            [self signOut];
            break;
        case 4:
            NSLog(@"Delete Account");
            [self deleteAccount];
            break;
        case 5:
            NSLog(@"Units of Measure");
            [self unitsOfMeasure];
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

-(void)createAccount {
    
}

-(void)updateAccount {
    
}

-(void)signIn {
    
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
                                        User *user = [[User alloc]init];
                                        [user DeleteUserAccount];
                                    }];
        
        [alert addAction:cancelAction];
        [alert addAction:yesAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [AlertControllerHelper ShowAlert:@"No Current User" message:@"There is no account to delete!" view:self];
    }
}

-(void)unitsOfMeasure {
    
}

@end
