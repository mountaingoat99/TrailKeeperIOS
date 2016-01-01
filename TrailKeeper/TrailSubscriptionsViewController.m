//
//  TrailSubscriptionsViewController.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 11/1/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "TrailSubscriptionsViewController.h"
#import "AppDelegate.h"
#import "Trails.h"
#import "Installation.h"
#import "TrailHomeViewController.h"
#import "AlertControllerHelper.h"

@interface TrailSubscriptionsViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSMutableArray *notificationList;

-(void)loadData;
-(void)unsubscribeFromTrail:(NSString*)trailObjectId;
-(void)convertChannelName:(NSArray*)channelList;
-(NSString*)fetchTrailObjectId:(NSString*)trailName;

@end

@implementation TrailSubscriptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    self.tblNotifications.delegate = self;
    self.tblNotifications.dataSource = self;
    
    [self loadData];
    
    // add some view properties
    [self.tblNotifications setSeparatorColor:[UIColor clearColor]];
    [self.tblNotifications setBackgroundColor:[UIColor clearColor]];
    
    self.tblNotifications.estimatedRowHeight = 80;
    self.tblNotifications.rowHeight = UITableViewAutomaticDimension;
    
    // make sure the back button text does not show
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
    if ([segue.identifier isEqualToString:@"segueSubscriptionsToTrailHome"]) {
        TrailHomeViewController *home = [segue destinationViewController];
        home.sentTrailObjectId = self.sentTrailObjectId;
    }
}

#pragma mark TableView

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.tblNotifications.rowHeight;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.notificationList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idCellRecord" forIndexPath:indexPath];
    cell.delegate = self;
    cell.channelName = [NSString stringWithFormat:@"%@", [self.notificationList objectAtIndex:indexPath.row]];
    cell.sentTrailObjectId = [self fetchTrailObjectId:[NSString stringWithFormat:@"%@", [self.notificationList objectAtIndex:indexPath.row]]];
    NSLog(@"TrailName %@ and ObjectId %@", cell.channelName, cell.sentTrailObjectId);
    
    cell.lblTrailName.text = [NSString stringWithFormat:@"%@", [self.notificationList objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark Events

-(void)btnClick_Home:(NSString *)trailId {
    self.sentTrailObjectId = trailId;
    NSLog(@"Sent TrailObjectId to Trail Home: %@", trailId);
    [self performSegueWithIdentifier:@"segueSubscriptionsToTrailHome" sender:self];
}

-(void)btnClick_Unsubscribe:(NSString *)trailChannel {
    NSLog(@"Unsbuscribing from Trail: %@", trailChannel);
    [self unsubscribeFromTrail:trailChannel];
}

- (IBAction)btn_drawerClick:(id)sender {
    [self.appDelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:true completion:nil];
}

#pragma mark private methods

-(void)loadData {
    
    NSArray *channels = [[NSArray alloc] init];
    
    if (self.notificationList != nil) {
        self.notificationList = nil;
    }
    
    // call the trail class to get the notifications
    Installation *install = [[Installation alloc] init];
    channels = [install GetUserChannels];
    
    [self convertChannelName:channels];
}

-(void)unsubscribeFromTrail:(NSString*)trailName {
    Installation *install = [[Installation alloc] init];
    [install SubscribeToChannel:trailName Choice:NO];
    
    [self loadData];
    [AlertControllerHelper ShowAlert:@"" message:[NSString stringWithFormat:@"You will no longer recieve notifications for %@", trailName] view:self];
}

-(void)convertChannelName:(NSArray*)channelList {
    
    self.notificationList = [[NSMutableArray alloc] init];
    for (NSString* n in channelList) {
        // remove Channel
        NSString *name = [n stringByReplacingOccurrencesOfString:@"Channel" withString:@""];
        // create regular expression
        NSRegularExpression *regexp = [NSRegularExpression
                                       regularExpressionWithPattern:@"([a-z])([A-Z])"
                                       options:0
                                       error:NULL];
        // get the new string
        NSString *newString = [regexp
                               stringByReplacingMatchesInString:name
                               options:0 
                               range:NSMakeRange(0, name.length)
                               withTemplate:@"$1 $2"];
        NSLog(@"Changed '%@' -> '%@'", name, newString);
        // add it to the array
        [self.notificationList addObject:newString];
    }
    [self.tblNotifications reloadData];
}

-(NSString*)fetchTrailObjectId:(NSString*)trailName {
    Trails *trails = [[Trails alloc] init];
    return [trails GetIdByTrailName:trailName];
}

@end
