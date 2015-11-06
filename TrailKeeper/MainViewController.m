//
//  MainViewController.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/31/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import "TrailCell.h"
#import "Trails.h"
#import "GeoLocationHelper.h"

@interface MainViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSArray *trailList;
@property (nonatomic, strong) PFGeoPoint *userLocation;

-(void)loadData;


@end

@implementation MainViewController

@synthesize trailList;
@synthesize userLocation;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userLocation = [GeoLocationHelper GetUsersCurrentPostion];
    
    self.tbltrailCards.delegate = self;
    self.tbltrailCards.dataSource = self;
    
    [self loadData];
    
    // drop shadow for the table
    //self.tbltrailCards.layer.shadowColor = [UIColor blackColor].CGColor;
    //self.tbltrailCards.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    //self.tbltrailCards.layer.masksToBounds = NO;
    //self.tbltrailCards.layer.shadowOpacity = 1.0;
    [self.tbltrailCards setSeparatorColor:[UIColor clearColor]];
    // if overscroll keep the background color
    //self.view.backgroundColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.appDelegate.whichController = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    TrailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idCellRecord" forIndexPath:indexPath];
    
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

@end
