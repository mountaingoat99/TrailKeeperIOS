//
//  TrailHomeViewController.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 11/11/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "TrailHomeViewController.h"
#import "AppDelegate.h"

@interface TrailHomeViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSArray *commentList;

-(void)loadData;

@end

@implementation TrailHomeViewController

@synthesize commentList;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    self.tblComments.delegate = self;
    self.tblComments.dataSource = self;
    
    [self loadData];
    
    [self.tblComments setSeparatorColor:[UIColor clearColor]];
    self.tblComments.backgroundColor = [UIColor clearColor];
    
    self.vCommentBackground.layer.masksToBounds = NO;
    self.vCommentBackground.layer.cornerRadius = 3.0;
    self.vCommentBackground.layer.shadowOffset = CGSizeMake(1, 0);
    self.vCommentBackground.layer.shadowOpacity = 0.5;
    
    self.vTrailHomeBackground.backgroundColor = [UIColor whiteColor];
    self.vTrailHomeBackground.layer.masksToBounds = NO;
    self.vTrailHomeBackground.layer.cornerRadius = 3.0;
    self.vTrailHomeBackground.layer.shadowOffset = CGSizeMake(1, 0);
    self.vTrailHomeBackground.layer.shadowOpacity = 0.5;
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
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

#pragma tableview

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130.0;
}

-(void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    cell.contentView.backgroundColor = [UIColor clearColor];
//    UIView *whiteRoundedCornerView = [[UIView alloc] initWithFrame:CGRectMake(5,10,self.view.window.bounds.size.width - 10,110)];
//    whiteRoundedCornerView.backgroundColor = [UIColor whiteColor];
//    whiteRoundedCornerView.layer.masksToBounds = NO;
//    whiteRoundedCornerView.layer.cornerRadius = 3.0;
//    whiteRoundedCornerView.layer.shadowOffset = CGSizeMake(1, 0);
//    whiteRoundedCornerView.layer.shadowOpacity = 0.5;
//    [cell.contentView addSubview:whiteRoundedCornerView];
//    [cell.contentView sendSubviewToBack:whiteRoundedCornerView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"TrailList Count in Table %lu", (unsigned long)self.trailList.count);
    return 5;
    //return self.trailList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //deque the cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idCellRecord" forIndexPath:indexPath];
//    cell.delegate = self;
//    
//    cell.sentTrailObjectId = [NSString stringWithFormat:@"%@", [[self.trailList objectAtIndex:indexPath.row] objectId]];
//    cell.imageTrailStatus.image = [Trails GetStatusIcon:[[self.trailList objectAtIndex:indexPath.row] objectForKey:@"status"]];
//    cell.lblTrailName.text = [NSString stringWithFormat:@"%@", [[self.trailList objectAtIndex:indexPath.row] objectForKey:@"trailName"]];
//    NSString *cityState = [NSString stringWithFormat:@"%@", [[self.trailList objectAtIndex:indexPath.row] objectForKey:@"city"]];
//    cityState = [cityState stringByAppendingString:@", "];
//    cityState = [cityState stringByAppendingString:[NSString stringWithFormat:@"%@", [[self.trailList objectAtIndex:indexPath.row] objectForKey:@"state"]]] ;
//    cell.lblTrailCityState.text = [NSString stringWithFormat:@"%@", cityState];
//    PFGeoPoint *trailLocation  = [[self.trailList objectAtIndex:indexPath.row] objectForKey:@"geoLocation"];
//    NSString *milesFromCurrent = [NSString stringWithFormat:@"%.2f", [GeoLocationHelper GetDistanceFromCurrentLocation:self.userLocation traillocation:trailLocation]];
//    milesFromCurrent = [milesFromCurrent stringByAppendingString:@" Miles"];
//    cell.lblTrailMileageFrom.text =  milesFromCurrent;
    return cell;
}

#pragma Events

- (IBAction)btn_backClick:(id)sender {
    [self performSegueWithIdentifier:@"segueTrailHomeToHome" sender:self];
}

#pragma private methods
-(void)loadData {
    
}


@end
