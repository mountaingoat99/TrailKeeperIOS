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
#import "CommentsViewController.h"
#import "User.h"
#import "AlertControllerHelper.h"
#import "GetAllObjectsFromParseHelper.h"
#import "Converters.h"

static NSString * const CTCellIdentifier = @"idCellRecord";

@interface TrailHomeViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSArray *commentList;
@property (nonatomic, strong) NSString *trailName;
@property (nonatomic) BOOL isAnonUser;
@property (nonatomic) BOOL isParseUser;
//@property (nonatomic, strong) UIRefreshControl *refreshControl;

-(void)checkForParseUser;
-(void)checkForAnonUser;
-(void)loadTableData:(NSArray*)comments;
-(void)loadTrailData:(Trails*)trail;
-(NSString*)formateDate:(NSString*)date;
-(void)subscribeToTrail:(BOOL)isSubscribed;
-(void)SetTrailStatus:(NSNumber*)trailStatus;
-(void)leaveNewComment:(NSString*)comment;
-(void)btn_drawerClick;
-(void)refresh;
-(NSArray*)RefreshComments;
-(Trails*)RefreshTrails;

@end

@implementation TrailHomeViewController

@synthesize commentList;
@synthesize trailName;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self checkForParseUser];
    [self checkForAnonUser];
    
    // Initialize the refresh control.
//    self.refreshControl = [[UIRefreshControl alloc] init];
//    //self.refreshControl.backgroundColor = [UIColor blackColor];
//    self.refreshControl.tintColor = [UIColor whiteColor];
//    [self.refreshControl addTarget:self
//                            action:@selector(refresh:)
//                  forControlEvents:UIControlEventValueChanged];
//    [self.tblComments addSubview:self.refreshControl];
    
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
    
    // find out if we are getting the sentTrailObjectId from another ViewController
    // or from the AppDelegate notification
    if (self.sentTrailObjectId == nil) {
        //[self.refreshControl beginRefreshing];
        self.sentTrailObjectId = self.appDelegate.notificationTrailId;
        // create the button
        UIBarButtonItem *drawerButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"drawer_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(btn_drawerClick)];
        self.navigationItem.leftBarButtonItem = drawerButton;
        [self refresh];
    } else {
        [self loadTrailData:nil];
        [self loadTableData:nil];
    }
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


 #pragma mark - Navigation
 
  //In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([segue.identifier isEqualToString:@"segueTrailHomeToComments"]) {
         CommentsViewController *comments = [segue destinationViewController];
         comments.sentTrailObjectId = self.sentTrailObjectId;
     }
 }

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

- (IBAction)btn_subscribeClick:(id)sender {
    
    // lets make sure they are a user and they are verified
    if (self.isParseUser) {
        if (!self.isAnonUser) {
            
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
            
        } else {
            [AlertControllerHelper ShowAlert:@"Verify Email" message:@"Please verify your email first!" view:self];
        }
    } else {
        [AlertControllerHelper ShowAlert:@"No Account" message:@"Please sign up for an account in Settings and verify your email first!" view:self];
    }
}

- (IBAction)btn_statusClick:(id)sender {
    
    // lets make sure they are a user and they are verified
    if (self.isParseUser) {
        if (!self.isAnonUser) {
    
            NSString *name = [NSString stringWithFormat:@"How is the trail?"];
            
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
            
            UIAlertAction *openAction = [UIAlertAction
                       
                                         actionWithTitle:@"Open"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction *action)
                                        {
                                            NSLog(@"Open Trail Action");
                                            [self SetTrailStatus:@2];
                                        }];
            
            UIAlertAction *closedAction = [UIAlertAction
                                       actionWithTitle:@"Closed"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"Close Trail Action");
                                           [self SetTrailStatus:@1];
                                       }];
            
            UIAlertAction *unKnownAction = [UIAlertAction
                                           actionWithTitle:@"Unknown"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action)
                                           {
                                               NSLog(@"Unknown Trail Action");
                                               [self SetTrailStatus:@3];
                                           }];
            
            [alert addAction:cancelAction];
            [alert addAction:openAction];
            [alert addAction:closedAction];
            [alert addAction:unKnownAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        } else {
            [AlertControllerHelper ShowAlert:@"Verify Email" message:@"Please verify your email first!" view:self];
        }
    } else {
        [AlertControllerHelper ShowAlert:@"No Account" message:@"Please sign up for an account in Settings and verify your email first!" view:self];
    }
}

- (IBAction)btn_AllCommentsClick:(id)sender {
    [self performSegueWithIdentifier:@"segueTrailHomeToComments" sender:self];
}

- (IBAction)btn_LeaveCommentClick:(id)sender {
    
    // lets make sure they are a user and they are verified
    if (self.isParseUser) {
        if (!self.isAnonUser) {
    
            NSString *name = [NSString stringWithFormat:@"Add Comment for %@?", self.trailName];
            
            UIAlertController *alert = [UIAlertController
                                        alertControllerWithTitle:name
                                        message:nil
                                        preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"New Comment";
                textField.keyboardAppearance = UIKeyboardAppearanceDefault;
                textField.keyboardType = UIKeyboardTypeDefault;
                textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction
                                           actionWithTitle:@"Cancel"
                                           style:UIAlertActionStyleCancel
                                           handler:^(UIAlertAction *action)
                                           {
                                               NSLog(@"Cancel Action");
                                           }];
            
            UIAlertAction *okAction = [UIAlertAction
                                        actionWithTitle:@"OK"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction *action)
                                        {
                                            NSLog(@"Leave Comment OK Action");
                                            UITextField *comment = alert.textFields.firstObject;
                                            [self leaveNewComment:comment.text];
                                        }];
            
            [alert addAction:cancelAction];
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        } else {
            [AlertControllerHelper ShowAlert:@"Verify Email" message:@"Please verify your email first!" view:self];
        }
    } else {
        [AlertControllerHelper ShowAlert:@"No Account" message:@"Please sign up for an account in Settings and verify your email first!" view:self];
    }
}

-(void)btn_drawerClick {
    if (self.appDelegate.notificationTrailId != nil) {
        [self.appDelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:true completion:nil];
    }
}

#pragma private methods
-(void)loadTableData:(NSArray*)comments {
    
    if (self.commentList != nil) {
        self.commentList = nil;
    }
    
    if (comments == nil) {
        Comments *commentModel = [[Comments alloc] init];
        self.commentList = [commentModel GetCommentsByTrail:self.sentTrailObjectId];
    } else {
        self.commentList = comments;
    }
    
    [self.tblComments reloadData];
}

-(void)loadTrailData:(Trails*)trails {
    if (trails == nil) {
        trails = [[Trails alloc] init];
        trails = [trails GetTrailObject:self.sentTrailObjectId];
    }
    
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

-(void)SetTrailStatus:(NSNumber*)trailStatus {
    Trails *trails = [[Trails alloc] init];
    [trails UpdateTrailStatus:self.sentTrailObjectId Choice:trailStatus TrailName:self.trailName];
}

-(void)leaveNewComment:(NSString*)comment {
    NSLog(@"New Comment is %@ ", comment);
    Comments *comments = [[Comments alloc] init];
    PFUser *user = [PFUser currentUser];          // user needs to be signed in first
    
    comments.trailObjectId = self.sentTrailObjectId;
    comments.trailName = self.trailName;
    comments.userName = user.username;
    comments.userObjectId = user.objectId;
    comments.comment = comment;
    
    [comments SaveNewComment:comments];
    [GetAllObjectsFromParseHelper RefreshComments]; // This is not working
    [self loadTableData:(NSMutableArray*)nil];
}

-(void)checkForParseUser {
    self.isParseUser = [User isParseUser];
    NSLog(@"IsParseUser is %d ", self.isParseUser);
}

-(void)checkForAnonUser {
    self.isAnonUser = [User isAnonUser];
    NSLog(@"IsAnonUser is %d ", self.isAnonUser);
}

-(void)refresh {
    NSLog(@"Refresh Trail Home Screen From Notification");
    Trails *trail = [self RefreshTrails];
    NSArray* comments = [self RefreshComments];
    
    [self loadTrailData:trail];
    [self loadTableData:comments];
    
//    if (self.refreshControl) {
//        [self.refreshControl endRefreshing];
//    }
}

-(Trails*)RefreshTrails {
    Trails *trail = [[Trails alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"Trails"];
    [query whereKey:@"objectId" equalTo:self.sentTrailObjectId];
    NSArray * _Nullable objects = [query findObjects];
    
    for (PFObject *object in objects ){
        trail.trailName = [object objectForKey:@"trailName"];
        trail.status = [object objectForKey:@"status"];
        trail.mapLink = [object objectForKey:@"mapLink"];
        trail.city = [object objectForKey:@"city"];
        trail.state = [object objectForKey:@"state"];
        trail.country = [object objectForKey:@"country"];
        trail.length = [object objectForKey:@"distance"];
        trail.geoLocation = [object objectForKey:@"geoLocation"];
        trail.privateTrail = [Converters getBoolValueFromNSNumber:[object objectForKey:@"private"]];
        trail.skillEasy = [Converters getBoolValueFromNSNumber:[object objectForKey:@"skillEasy"]];
        trail.skillMedium = [Converters getBoolValueFromNSNumber:[object objectForKey:@"skillMedium"]];
        trail.skillHard = [Converters getBoolValueFromNSNumber:[object objectForKey:@"skillHard"]];
    }
    return trail;
}

-(NSArray*)RefreshComments {
    PFQuery *query = [PFQuery queryWithClassName:@"Comments"];
    [query whereKey:@"trailObjectId" equalTo:self.sentTrailObjectId];
    [query orderByDescending:@"workingCreatedDate"];
    NSArray * _Nullable objects = [query findObjects];
    return objects;
}

@end
