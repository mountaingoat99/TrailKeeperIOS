//
//  CommentsViewController.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 11/1/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "CommentsViewController.h"
#import "AppDelegate.h"
#import "TrailHomeViewController.h"
#import "HTAutocompleteManager.h"
#import "CustomCommentCell.h"
#import "Comments.h"
#import "AlertControllerHelper.h"
#import "AdMobView.h"

static NSString *const filterTrail = @"filterTrail";
static NSString *const filterUser = @"filterUser";
static NSString *const filterNone = @"filterAll";

@interface CommentsViewController () 

@property (nonatomic, strong) NSArray *commentList;
@property (nonatomic) UITableView *autocompleteTableView;
@property (nonatomic) UITextField *searchText;
@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSString *filerType;

-(void)loadData;
-(NSString*)formateDate:(NSString*)date;

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

@implementation CommentsViewController

#pragma mark loadEvents

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [AdMobView GetAdMobView:self];
    
    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (self.sentTrailObjectId != nil) {
        self.btnDrawer.image = [UIImage imageNamed:@"back.png"];
        self.filerType = filterTrail;
    } else {
        self.btnDrawer.image = [UIImage imageNamed:@"drawer_icon.png"];
        self.filerType = filterNone;
    }
    
    // sets the default datasouce for the autocomplete text field
    [HTAutocompleteTextField setDefaultAutocompleteDataSource:[HTAutocompleteManager sharedManager]];
    // set up the autocomplete text
    self.txtAutoComplete.autocorrectionType = UITextAutocorrectionTypeNo;
    self.txtAutoComplete.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.txtAutoComplete.returnKeyType = UIReturnKeySearch;
    self.txtAutoComplete.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    self.txtAutoComplete.delegate = self;
    
    self.txtAutoComplete.enabled = NO;
    
    self.tblFindComment.delegate = self;
    self.tblFindComment.dataSource = self;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        // color attributes for the segmented controls in iphone
        NSDictionary *segmentedControlTextAttributes = @{NSForegroundColorAttributeName:self.appDelegate.colorButtons, NSFontAttributeName:[UIFont systemFontOfSize:14.0f]};
        NSDictionary *segmentedControlTextAttributesPicked = @{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont systemFontOfSize:14.0f]};
        [[UISegmentedControl appearance] setTitleTextAttributes:segmentedControlTextAttributes forState:UIControlStateNormal];
        [[UISegmentedControl appearance] setTitleTextAttributes:segmentedControlTextAttributes forState:UIControlStateHighlighted];
        [[UISegmentedControl appearance] setTitleTextAttributes:segmentedControlTextAttributesPicked forState:UIControlStateSelected];
    } else {
        // color and size attributes for the SC in iPad
        NSDictionary *segmentedControlTextAttributesiPad = @{NSForegroundColorAttributeName:self.appDelegate.colorButtons, NSFontAttributeName:[UIFont systemFontOfSize:18.0f]};
        NSDictionary *segmentedControlTextAttributesiPadPicked = @{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont systemFontOfSize:18.0f]};
        [[UISegmentedControl appearance] setTitleTextAttributes:segmentedControlTextAttributesiPad forState:UIControlStateNormal];
        [[UISegmentedControl appearance] setTitleTextAttributes:segmentedControlTextAttributesiPad forState:UIControlStateHighlighted];
        [[UISegmentedControl appearance] setTitleTextAttributes:segmentedControlTextAttributesiPadPicked forState:UIControlStateSelected];
    }
    
    [self loadData];
    
    // add some view properties
    [self.tblFindComment setSeparatorColor:[UIColor clearColor]];
    [self.tblFindComment setBackgroundColor:[UIColor clearColor]];
    // ads padding after the last card for ad space
    if (IS_IPAD) {
        self.tblFindComment.contentInset = UIEdgeInsetsMake(0.0, 0.0, 60.0, 0.0);
    }
    else {
        self.tblFindComment.contentInset = UIEdgeInsetsMake(0.0, 0.0, 50.0, 0.0);
    }
    
    self.tblFindComment.estimatedRowHeight = 68;
    self.tblFindComment.rowHeight = UITableViewAutomaticDimension;
    
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

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    if(textField.returnKeyType==UIReturnKeySearch) {
        [textField resignFirstResponder];
        [self loadData];
    }
    return YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"segueCommentToTrailHome"]) {
        TrailHomeViewController *home = [segue destinationViewController];
        home.sentTrailObjectId = self.sentTrailObjectId;
        home.isFromCommentViewController = self.isFromCommentViewController;
    }
}

#pragma mark TableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.tblFindComment.rowHeight;
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
    CustomCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idCellRecord" forIndexPath:indexPath];
    cell.lblTrailName.text = [NSString stringWithFormat:@"%@", [[self.commentList objectAtIndex:indexPath.row] objectForKey:@"trailName"]];
    cell.lblComment.text = [NSString stringWithFormat:@"%@", [[self.commentList objectAtIndex:indexPath.row] objectForKey:@"comment"]];
    NSString *date = [self formateDate:[[self.commentList objectAtIndex:indexPath.row] objectForKey:@"workingCreatedDate"]];
    cell.lblCommentDate.text = date;
    cell.lblCommentUser.text = [NSString stringWithFormat:@"%@", [[self.commentList objectAtIndex:indexPath.row] objectForKey:@"userName"]];
    return cell;
}

#pragma mark Events

- (IBAction)btn_drawerClick:(id)sender {
    if (self.sentTrailObjectId != nil) {
        [self performSegueWithIdentifier:@"segueCommentToTrailHome" sender:self];
    } else {
        [self.appDelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:true completion:nil];
    }
}

- (IBAction)Filter_IndexChanged:(id)sender {
    
    switch (self.segmentSearch.selectedSegmentIndex) {
        case 0:
            NSLog(@"Filtering for All");
            self.filerType = filterNone;
            self.txtAutoComplete.text = @"";
            self.txtAutoComplete.enabled = NO;
            [self loadData];
            break;
        case 1:
            NSLog(@"Filtering for Trail");
            self.filerType = filterTrail;
            self.txtAutoComplete.autocompleteType = HTAutoCompleteTrailNames;
            self.txtAutoComplete.text = @"";
            self.txtAutoComplete.enabled = YES;
            [self.txtAutoComplete becomeFirstResponder];
            break;
        case 2:
            NSLog(@"Filtering for User");
            self.filerType = filterUser;
            self.txtAutoComplete.autocompleteType = HTAutoCompleteUserNames;
            self.txtAutoComplete.text = @"";
            self.txtAutoComplete.enabled = YES;
            [self.txtAutoComplete becomeFirstResponder];
            break;
        default:
            break;
    }
}

#pragma Private Methods

-(void)loadData {
    if (self.commentList != nil) {
        self.commentList = nil;
    }
    
    // call to get the comment List
    Comments *comments = [[Comments alloc] init];
    if ([self.filerType isEqualToString:filterNone]) {
        self.commentList = [comments GetAllComments];
    } else if ([self.filerType isEqualToString:filterTrail]) {
        Trails *trail = [[Trails alloc] init];
        if (self.sentTrailObjectId != nil) {
            self.commentList = [comments GetCommentsByTrail:self.sentTrailObjectId];
        } else {
            NSString *trailid = [trail GetIdByTrailName:self.txtAutoComplete.text];
            if (trailid != nil) {
                self.commentList = [comments GetCommentsByTrail:trailid];
            } else {
                self.commentList = [comments GetAllComments];
                [self.txtAutoComplete becomeFirstResponder];
                [AlertControllerHelper ShowAlert:@"No Comments" message:@"There are no comments for that trail" view:self];
            }
        }
        
    } else {
        AuthorizedCommentors *commentor = [[AuthorizedCommentors alloc] init];
        NSString *userid = [commentor GetUserObjectIdByName:self.txtAutoComplete.text];
        if (userid != nil) {
            self.commentList = [comments GetCommentsByUser:userid];
        } else {
            self.commentList = [comments GetAllComments];
            [self.txtAutoComplete becomeFirstResponder];
            [AlertControllerHelper ShowAlert:@"No Comments" message:@"There are no comments for that user" view:self];
        }
    }
    
    [self.tblFindComment reloadData];
}

-(NSString*)formateDate:(NSDate*)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy h:mm a"];
    return [formatter stringFromDate:date];
}

@end
