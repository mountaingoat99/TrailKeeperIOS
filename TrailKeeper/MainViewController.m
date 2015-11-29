//
//  MainViewController.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/31/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import "Trails.h"
#import "GeoLocationHelper.h"
#import "TrailHomeViewController.h"
#import "MapViewController.h"
#import "AlertControllerHelper.h"
#import "CreateAccountViewController.h"

@interface MainViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSArray *trailList;
@property (nonatomic, strong) PFGeoPoint *userLocation;

-(void)loadData;
-(void)firstTimeLoad;
-(void)checkForNewUser;

@end

@implementation MainViewController

@synthesize trailList;
@synthesize userLocation;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // get users current location
    self.userLocation = [GeoLocationHelper GetUsersCurrentPostion];
    
    // set the Table delegate and datasource
    self.tbltrailCards.delegate = self;
    self.tbltrailCards.dataSource = self;
    
    // load the data
    [self loadData];
    
    // add some view properties
    [self.tbltrailCards setSeparatorColor:[UIColor clearColor]];
    [self.tbltrailCards setBackgroundColor:[UIColor clearColor]];
    
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
    
    [self checkForNewUser];
    [self firstTimeLoad];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    // set the current ViewController
    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
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
    if ([segue.identifier isEqualToString:@"segueHomeToTrailHome"]) {
        TrailHomeViewController *home = [segue destinationViewController];
        home.sentTrailObjectId = self.sentTrailObjectId;
    }
    if ([segue.identifier isEqualToString:@"segueHomeToMap"]) {
        MapViewController *map = [segue destinationViewController];
        //TODO send the sentTrailObjectID
    }
}


#pragma mark - tableview

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130.0;
}

-(void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    UIView *whiteRoundedCornerView = [[UIView alloc] initWithFrame:CGRectMake(5,10,self.view.window.bounds.size.width - 10,110)];
    whiteRoundedCornerView.backgroundColor = [UIColor whiteColor];
    whiteRoundedCornerView.layer.masksToBounds = NO;
    whiteRoundedCornerView.layer.cornerRadius = 3.0;
    whiteRoundedCornerView.layer.shadowOffset = CGSizeMake(1, 0);
    whiteRoundedCornerView.layer.shadowOpacity = 0.5;
    [cell.contentView addSubview:whiteRoundedCornerView];
    [cell.contentView sendSubviewToBack:whiteRoundedCornerView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"TrailList Count in Table %lu", (unsigned long)self.trailList.count);
    return self.trailList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //deque the cell
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idCellRecord" forIndexPath:indexPath];
    cell.delegate = self;
    
    cell.sentTrailObjectId = [NSString stringWithFormat:@"%@", [[self.trailList objectAtIndex:indexPath.row] objectId]];
    cell.imageTrailStatus.image = [Trails GetStatusIcon:[[self.trailList objectAtIndex:indexPath.row] objectForKey:@"status"]];
    cell.lblTrailName.text = [NSString stringWithFormat:@"%@", [[self.trailList objectAtIndex:indexPath.row] objectForKey:@"trailName"]];
    NSString *cityState = [NSString stringWithFormat:@"%@", [[self.trailList objectAtIndex:indexPath.row] objectForKey:@"city"]];
    cityState = [cityState stringByAppendingString:@", "];
    cityState = [cityState stringByAppendingString:[NSString stringWithFormat:@"%@", [[self.trailList objectAtIndex:indexPath.row] objectForKey:@"state"]]] ;
    cell.lblTrailCityState.text = [NSString stringWithFormat:@"%@", cityState];
    PFGeoPoint *trailLocation  = [[self.trailList objectAtIndex:indexPath.row] objectForKey:@"geoLocation"];
    NSString *milesFromCurrent = [NSString stringWithFormat:@"%.2f", [GeoLocationHelper GetDistanceFromCurrentLocation:self.userLocation traillocation:trailLocation]];
    milesFromCurrent = [milesFromCurrent stringByAppendingString:@" Miles"];
    cell.lblTrailMileageFrom.text =  milesFromCurrent;
    return cell;
}

-(void)btnClick_Map:(NSString*)trailObjectId {
    NSLog(@"Sent TrailObjectID to Maps is: %@", trailObjectId);
    self.sentTrailObjectId = trailObjectId;
    [self performSegueWithIdentifier:@"segueHomeToMap" sender:self];
}

-(void)btnClick_TrailHome:(NSString*)trailObjectId {
    NSLog(@"Sent TrailObjectId to Trail Home Screen is %@", trailObjectId);
    self.sentTrailObjectId = trailObjectId;
    [self performSegueWithIdentifier:@"segueHomeToTrailHome" sender:self];
}

- (IBAction)btn_drawerClick:(id)sender {
    NSLog(@"Left Drawer button tapped");
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:true completion:nil];
    //[self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

#pragma mark - private methods
-(void)loadData {
    if (self.trailList != nil) {
        self.trailList = nil;
    }
    
    Trails *trails = [[Trails alloc] init];
    self.trailList = [trails GetClosestTrailsForHomeScreen];
    [self.tbltrailCards reloadData];
}

-(void)firstTimeLoad {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *firstLoad = @"firstLoad";
    
    if ([preferences objectForKey:firstLoad] == nil) {
        [preferences setObject:@"NO" forKey:@"firstLoad"];
        
        NSString *name = [NSString stringWithFormat:@"Welcome! \nWould you like to take full advantage of the TrailKeeper App and sign up for an Account? \nDon't worry, you can always go into the Settings and sign-up later"];
        
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
                                        NSLog(@"New Account Yes Action");
                                        [self performSegueWithIdentifier:@"segueHomeToCreateAccount" sender:self];
                                        
                                    }];
        
        [alert addAction:cancelAction];
        [alert addAction:yesAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)checkForNewUser {
    if(self.newUser) {
        PFUser *user = [PFUser currentUser];
        NSString *message = [NSString stringWithFormat:@"Hey %@! \nThanks for signing up! You have one more step. Please check your email for a verification link.", user.username];
        [AlertControllerHelper ShowAlert:@"Welcome" message:message view:self];
    }
}

@end
