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
#import "GetAllObjectsFromParseHelper.h"
#import "AdMobView.h"

@interface MainViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSArray *trailList;
@property (nonatomic, strong) PFGeoPoint *userLocation;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) CALayer *darkBackgroundLayer;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) NSString *measurementLabel;

-(void)loadData;
-(void)updateView:(NSNotification *)notification;
-(void)firstTimeLoad;
-(void)checkForNewUser;
-(void)refresh:(UIRefreshControl*)refreshControl;

@end

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

@implementation MainViewController

@synthesize trailList;
@synthesize userLocation;
@synthesize backgroundView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // make the google ad mob request
    [AdMobView GetAdMobView:self];
    
    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    //self.refreshControl.backgroundColor = [UIColor blackColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(refresh:)
                  forControlEvents:UIControlEventValueChanged];
    [self.tbltrailCards addSubview:self.refreshControl];
    
    // darken the background
    self.darkBackgroundLayer = [CALayer layer];
    self.darkBackgroundLayer.frame = CGRectMake(0, 0, self.view.bounds.size.width * 2, self.view.bounds.size.height);
    self.darkBackgroundLayer.backgroundColor = [[UIColor blackColor] CGColor];
    self.darkBackgroundLayer.opacity = .1;
    [self.backgroundView.layer addSublayer: self.darkBackgroundLayer];
    
    //init the background message
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    // see if we need to load all the data and show the welcome message
    [self firstTimeLoad];
    
    // set the measurement preferences
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    if ([[preferences objectForKey:userMeasurementKey] isEqualToString:imperialDefault]) {
        self.measurementLabel = @" Miles";
    } else {
        self.measurementLabel = @" Kilometers";
    }
    
    //Register a notification to reload the table if the user give location permissions on the app
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateView:) name:@"updateRoot" object:nil];
    
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
    // ads padding after the last card for ad space
    if (IS_IPAD) {
        self.tbltrailCards.contentInset = UIEdgeInsetsMake(0.0, 0.0, 60.0, 0.0);
    }
    else {
        self.tbltrailCards.contentInset = UIEdgeInsetsMake(0.0, 0.0, 50.0, 0.0);
    }
    
    //self.btnHome.tintColor = [UIColor colorWithRed:29.0/255.0 green:173.0/255.0 blue:234.0/255.0 alpha:1.0];
    
    // make sure the back button text does not show
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
    
    // check if they just signed up for an account
    [self checkForNewUser];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    // set the current ViewController
    
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
        map.sentTrailObjectId = self.sentTrailObjectId;
        map.navigateBack = YES;
        self.appDelegate.whichController = self;
    }
}


#pragma mark - tableview

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110.0;
}

-(void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    UIView *whiteRoundedCornerView = [[UIView alloc] initWithFrame:CGRectMake(5,10,self.view.window.bounds.size.width - 10,100)];
    whiteRoundedCornerView.backgroundColor = [UIColor whiteColor];
    whiteRoundedCornerView.layer.masksToBounds = NO;
    whiteRoundedCornerView.layer.cornerRadius = 3.0;
    whiteRoundedCornerView.layer.shadowOffset = CGSizeMake(1, 0);
    whiteRoundedCornerView.layer.shadowOpacity = 0.5;
    [cell.contentView addSubview:whiteRoundedCornerView];
    [cell.contentView sendSubviewToBack:whiteRoundedCornerView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.trailList.count > 0) {
        self.messageLabel.text = @"";
        return 1;
    } else {
        // Display a message when the table is empty
        self.messageLabel.text = @"No data is currently available. Please pull down to refresh.";
        self.messageLabel.textColor = [UIColor whiteColor];
        self.messageLabel.numberOfLines = 0;
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        self.messageLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:30];
        [self.messageLabel sizeToFit];
        
        self.tbltrailCards.backgroundView = self.messageLabel;
        self.tbltrailCards.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"TrailList Count in Table %lu", (unsigned long)self.trailList.count);
    return self.trailList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //deque the cell
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idCellRecord" forIndexPath:indexPath];
    cell.delegate = self;
    
    // need to set this for iPad background view on UITableViews
    cell.backgroundColor = cell.contentView.backgroundColor;
    
    cell.sentTrailObjectId = [NSString stringWithFormat:@"%@", [[self.trailList objectAtIndex:indexPath.row] objectId]];
    cell.imageTrailStatus.image = [Trails GetStatusIcon:[[self.trailList objectAtIndex:indexPath.row] objectForKey:@"status"]];
    cell.lblTrailName.text = [NSString stringWithFormat:@"%@", [[self.trailList objectAtIndex:indexPath.row] objectForKey:@"trailName"]];
    NSString *cityState = [NSString stringWithFormat:@"%@", [[self.trailList objectAtIndex:indexPath.row] objectForKey:@"city"]];
    cityState = [cityState stringByAppendingString:@", "];
    cityState = [cityState stringByAppendingString:[NSString stringWithFormat:@"%@", [[self.trailList objectAtIndex:indexPath.row] objectForKey:@"state"]]] ;
    cell.lblTrailCityState.text = [NSString stringWithFormat:@"%@", cityState];
    PFGeoPoint *trailLocation  = [[self.trailList objectAtIndex:indexPath.row] objectForKey:@"geoLocation"];
    NSString *milesFromCurrent = [NSString stringWithFormat:@"%.2f", [GeoLocationHelper GetDistanceFromCurrentLocation:self.userLocation traillocation:trailLocation]];
    milesFromCurrent = [milesFromCurrent stringByAppendingString:self.measurementLabel];
    cell.lblTrailMileageFrom.text =  milesFromCurrent;
    [cell.btnTrailHome  setTitleColor:self.appDelegate.colorButtons forState:UIControlStateNormal];
    [cell.btnTrailMap setTitleColor:self.appDelegate.colorButtons forState:UIControlStateNormal];
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
    int count = 0;
    if (self.trailList != nil) {
        self.trailList = nil;
    }
    
    Trails *trails = [[Trails alloc] init];
    self.trailList = [trails GetClosestTrailsForHomeScreen];
    while (self.trailList.count == 0) {
        count++;
        if (count > 50) {
            [AlertControllerHelper ShowAlert:@"No Connections!" message:@"It seems like the internet is broken. \nClose the app and try later when you have a stable connection." view:self];
            return;
        }
        self.trailList = [trails GetClosestTrailsForHomeScreen];
        NSLog(@"TrailList Count %lu, ", (unsigned long)self.trailList.count);
        NSLog(@"TrailList: %@", self.trailList);
    }
    [self.tbltrailCards reloadData];
}

- (void)updateView:(NSNotification *)notification {
    [self loadData];
}

-(void)refresh:(UIRefreshControl*)refreshControl {
    // refresh all the objects
    [GetAllObjectsFromParseHelper UnpinallAllTrailObjects];
    [GetAllObjectsFromParseHelper RefreshTrails];
    [GetAllObjectsFromParseHelper RefreshTrailStatus];
    [GetAllObjectsFromParseHelper RefreshAuthorizedCommentors];
    [GetAllObjectsFromParseHelper RefreshComments];
    
    [self loadData];
    
    if (self.refreshControl) {
        [self.refreshControl endRefreshing];
    }
}

-(void)firstTimeLoad {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    if ([preferences objectForKey:firstTimeLoadKey] == nil) {
        // first set the measurement type
        // TODO when going global check location and set metric for most places
        [preferences setObject:imperialDefault forKey:userMeasurementKey];
        
        [self refresh:self.refreshControl];
        [preferences setObject:@"NO" forKey:firstTimeLoadKey];
        
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
