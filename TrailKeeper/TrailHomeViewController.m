//
//  TrailHomeViewController.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 11/11/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "TrailHomeViewController.h"
#import "CustomTrailHomeCell.h"
#import "AppDelegate.h"
#import "Installation.h"
static NSString * const CTCellIdentifier = @"idCellRecord";

@interface TrailHomeViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSArray *commentList;
@property (nonatomic, strong) NSString *trailName;

-(void)loadTableData;
-(void)loadTrailData;
-(NSString*)formateDate:(NSString*)date;
-(void)subscribeToTrail:(BOOL)isSubscribed;

@end

@implementation TrailHomeViewController

@synthesize commentList;
@synthesize trailName;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    self.tblComments.delegate = self;
    self.tblComments.dataSource = self;
    
    [self.tblComments setSeparatorColor:[UIColor clearColor]];
    self.tblComments.backgroundColor = [UIColor clearColor];
    
    self.tblComments.estimatedRowHeight = 68;
    self.tblComments.rowHeight = UITableViewAutomaticDimension;
    
    self.vCommentBackground.layer.masksToBounds = NO;
    self.vCommentBackground.layer.cornerRadius = 3.0;
    self.vCommentBackground.layer.shadowOffset = CGSizeMake(1, 0);
    self.vCommentBackground.layer.shadowOpacity = 0.5;
    
    self.vTrailHomeBackground.backgroundColor = [UIColor whiteColor];
    self.vTrailHomeBackground.layer.masksToBounds = NO;
    self.vTrailHomeBackground.layer.cornerRadius = 3.0;
    self.vTrailHomeBackground.layer.shadowOffset = CGSizeMake(1, 0);
    self.vTrailHomeBackground.layer.shadowOpacity = 0.5;
    
    [self loadTrailData];
    [self loadTableData];
    self.navigationItem.title = self.trailName;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.tblComments.rowHeight;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"TrailList Count in Table %lu", (unsigned long)self.commentList.count);
    return self.commentList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //deque the cell
    CustomTrailHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:CTCellIdentifier forIndexPath:indexPath];
    cell.lblComment.text = [NSString stringWithFormat:@"%@", [[self.commentList objectAtIndex:indexPath.row] objectForKey:@"comment"]];
    NSString *date = [self formateDate:[[self.commentList objectAtIndex:indexPath.row] objectForKey:@"workingCreatedDate"]];
    cell.lblCommentDate.text = date;
    cell.lblCommentUsername.text = [NSString stringWithFormat:@"%@", [[self.commentList objectAtIndex:indexPath.row] objectForKey:@"userName"]];
    return cell;
}

#pragma Events

- (IBAction)btn_backClick:(id)sender {
    [self performSegueWithIdentifier:@"segueTrailHomeToHome" sender:self];
}

- (IBAction)btn_subscribeClick:(id)sender {
    
    NSString *name = [NSString stringWithFormat:@"Receive Notifications for %@?", self.trailName];
    
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
                                    [self subscribeToTrail:YES];
                                }];
    
    UIAlertAction *noAction = [UIAlertAction
                                actionWithTitle:@"No"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction *action)
                                {
                                    NSLog(@"Subscribe No Action");
                                    [self subscribeToTrail:NO];
                                }];
    
    [alert addAction:cancelAction];
    [alert addAction:yesAction];
    [alert addAction:noAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)btn_statusClick:(id)sender {
}

- (IBAction)btn_AllCommentsClick:(id)sender {
}

- (IBAction)btn_LeaveCommentClick:(id)sender {
}

#pragma private methods
-(void)loadTableData {
    if (self.commentList != nil) {
        self.commentList = nil;
    }
    
    Comments *comments = [[Comments alloc] init];
    self.commentList = [comments GetCommentsByTrail:self.sentTrailObjectId];
    [self.tblComments reloadData];
}

-(void)loadTrailData {
    Trails *trails = [[Trails alloc] init];
    trails = [trails GetTrailObject:self.sentTrailObjectId];
    
    self.trailName = trails.trailName;
    self.lblTrailName.text = self.trailName;
    NSString *cityState = trails.city;
    cityState = [cityState stringByAppendingString:@", "];
    cityState = [cityState stringByAppendingString:trails.state];
    self.lblCityState.text = cityState;
    self.imageStatus.image = [Trails GetStatusIcon:trails.status];
    if (trails.skillEasy) {
        self.imageEasy.hidden = NO;
    } else {
        self.imageEasy.hidden = YES;
    }
    if (trails.skillMedium) {
        self.imageMedium.hidden = NO;
    } else {
        self.imageMedium.hidden = YES;
    }
    if (trails.skillHard) {
        self.imageHard.hidden = NO;
    } else {
        self.imageHard.hidden = YES;
    }
}

-(NSString*)formateDate:(NSDate*)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy h:mm a"];
    return [formatter stringFromDate:date];
}

-(void)subscribeToTrail:(BOOL)isSubscribed {
    Installation *install = [[Installation alloc] init];
    [install SubscribeToChannel:self.trailName Choice:isSubscribed];
}

@end
