//
//  FindTrailViewController.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 11/1/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "FindTrailViewController.h"
#import "FindTrailSectionHeaderView.h"
#import "FindTrailSectionInfo.h"
#import "CustomFindTrailCell.h"
#import "GeoLocationHelper.h"
#import "TrailHomeViewController.h"
#import "States.h"
#import "Trails.h"
#import "AppDelegate.h"
#import "KCFloatingActionButton-Swift.h"

static NSString *SectionHeaderViewIdentifier = @"SectionHeaderViewIdentifier";

@interface FindTrailViewController ()

@property (nonatomic, strong) NSMutableArray *states;
@property (nonatomic, strong) NSMutableArray *sectionInfoArray;
//@property (nonatomic, strong) NSArray *trailName;
@property (nonatomic) NSInteger openSectionIndex;
@property (nonatomic) NSInteger uniformRowHeight;
@property (nonatomic, strong) PFGeoPoint *userLocation;
@property (nonatomic) UITableView *autocompleteTableView;
@property (nonatomic) UITextField *searchText;

@property (nonatomic) IBOutlet FindTrailSectionHeaderView *sectionHeaderView;
@property (nonatomic, strong) AppDelegate *appDelegate;

-(void)loadData;
-(void)ShowSearchFab;
-(void)goToSearchedTrail:(NSString*)trailName;
//-(void)getTrailName;

@end

#pragma mark -

#define DEFAULT_ROW_HEIGHT 78
#define HEADER_HEIGHT 48

@implementation FindTrailViewController

-(BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // get users current location
    self.userLocation = [GeoLocationHelper GetUsersCurrentPostion];
    
    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.tblFindTrail.delegate = self;
    self.tblFindTrail.dataSource = self;
    
    //default values on table
    self.tblFindTrail.sectionHeaderHeight = HEADER_HEIGHT;
    self.uniformRowHeight = DEFAULT_ROW_HEIGHT;
    self.openSectionIndex = NSNotFound;
    
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"SectionHeaderView" bundle:nil];
    [self.tblFindTrail registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
    
    [self loadData];
    //[self getTrailName];
    
    // add some view properties
    [self.tblFindTrail setSeparatorColor:[UIColor clearColor]];
    [self.tblFindTrail setBackgroundColor:[UIColor clearColor]];
    
    // make sure the back button text does not show
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
    [self ShowSearchFab];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if((self.sectionInfoArray == nil) ||
       [self.sectionInfoArray count] != [self numberOfSectionsInTableView:self.tblFindTrail]) {
        
        NSMutableArray *infoArray = [[NSMutableArray alloc] init];
        
        for (States *state in self.states) {
            FindTrailSectionInfo *sectionInfo = [[FindTrailSectionInfo alloc] init];
            sectionInfo.state = state;
            sectionInfo.open = NO;
            
            NSNumber *defaultRowHeight = @(DEFAULT_ROW_HEIGHT);
            NSInteger countOfTrails = [[sectionInfo.state trails] count];
            for (NSInteger i = 0; i < countOfTrails; i++) {
                [sectionInfo insertObject:defaultRowHeight inRowHeightsAtIndex:i];
            }
            [infoArray addObject:sectionInfo];
        }
        self.sectionInfoArray = infoArray;
    }
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
    if ([segue.identifier isEqualToString:@"segueFindTrailToTrailHome"]) {
        TrailHomeViewController *home = [segue destinationViewController];
        home.sentTrailObjectId = self.sentTrailObjectId;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"Section In Table View %lu", (unsigned long)[self.states count]);
    
    return [self.states count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    FindTrailSectionInfo *sectionInfo = (self.sectionInfoArray)[section];
    NSInteger numTrailsInSection = [[sectionInfo.state trails] count];
    NSLog(@"Trails in section %lu", (unsigned long)[[sectionInfo.state trails] count]);
    
    return sectionInfo.open ? numTrailsInSection : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomFindTrailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idCellRecord" forIndexPath:indexPath];
    FindTrailSectionInfo *sectionInfo = (self.sectionInfoArray)[indexPath.section];
   
    Trails *trail = (sectionInfo.state.trails)[indexPath.row];
    cell.trailName.text = trail.trailName;
    cell.trailCity.text = trail.city;
    PFGeoPoint *trailLocation = trail.geoLocation;
    NSString *milesFromCurrent = [NSString stringWithFormat:@"%.2f", [GeoLocationHelper GetDistanceFromCurrentLocation:self.userLocation traillocation:trailLocation]];
    milesFromCurrent = [milesFromCurrent stringByAppendingString:@" Miles"];
    cell.distance.text = milesFromCurrent;
    cell.statusImage.image = [Trails GetStatusIcon:trail.status];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    FindTrailSectionHeaderView *sectionHeaderView = [self.tblFindTrail dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
    
    FindTrailSectionInfo *sectionInfo = (self.sectionInfoArray)[section];
    sectionInfo.headerView = sectionHeaderView;
    
    NSLog(@"State Name for Header %@", sectionInfo.state.name);
    sectionHeaderView.titleLabel.text = sectionInfo.state.name;
    sectionHeaderView.section = section;
    sectionHeaderView.delegate = self;
    
    return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.tblFindTrail.rowHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Choose Row %ld", (long)indexPath.row);
    
    FindTrailSectionInfo *sectionInfo = (self.sectionInfoArray)[indexPath.section];
    Trails *trail = (sectionInfo.state.trails)[indexPath.row];
    self.sentTrailObjectId = trail.trailObjectId;

    [self performSegueWithIdentifier:@"segueFindTrailToTrailHome" sender:self];
    
   [self.tblFindTrail deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - SectionHeaderViewDelegate

- (void)sectionHeaderView:(FindTrailSectionHeaderView *)sectionHeaderView sectionOpened:(NSInteger)sectionOpened {
    
    FindTrailSectionInfo *sectionInfo = (self.sectionInfoArray)[sectionOpened];
    
    sectionInfo.open = YES;
    
    /*
     Create an array containing the index paths of the rows to insert: These correspond to the rows for each quotation in the current section.
     */
    NSInteger countOfRowsToInsert = [sectionInfo.state.trails count];
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
    }
    
    /*
     Create an array containing the index paths of the rows to delete: These correspond to the rows for each quotation in the previously-open section, if there was one.
     */
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    
    NSInteger previousOpenSectionIndex = self.openSectionIndex;
    if (previousOpenSectionIndex != NSNotFound) {
        
        FindTrailSectionInfo *previousOpenSection = (self.sectionInfoArray)[previousOpenSectionIndex];
        previousOpenSection.open = NO;
        [previousOpenSection.headerView toggleOpenWithUserAction:NO];
        NSInteger countOfRowsToDelete = [previousOpenSection.state.trails count];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
        }
    }
    
    // style the animation so that there's a smooth flow in either direction
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (previousOpenSectionIndex == NSNotFound || sectionOpened < previousOpenSectionIndex) {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }
    else {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
    
    // apply the updates
    [self.tblFindTrail beginUpdates];
    [self.tblFindTrail insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [self.tblFindTrail deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [self.tblFindTrail endUpdates];
    
    self.openSectionIndex = sectionOpened;
}

- (void)sectionHeaderView:(FindTrailSectionHeaderView *)sectionHeaderView sectionClosed:(NSInteger)sectionClosed {
    
    /*
     Create an array of the index paths of the rows in the section that was closed, then delete those rows from the table view.
     */
    FindTrailSectionInfo *sectionInfo = (self.sectionInfoArray)[sectionClosed];
    
    sectionInfo.open = NO;
    NSInteger countOfRowsToDelete = [self.tblFindTrail numberOfRowsInSection:sectionClosed];
    
    if (countOfRowsToDelete > 0) {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
        }
        [self.tblFindTrail deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
    }
    self.openSectionIndex = NSNotFound;
}


#pragma events

- (IBAction)btn_drawerClick:(id)sender {
    [self.appDelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:true completion:nil];
}

#pragma Private Methods

-(void)loadData {
    if (self.states != nil) {
        self.states = nil;
    }
    
    States *state = [[States alloc] init];
    self.states = [state getStatesWithTrails];
    
    [self.tblFindTrail reloadData];
}

-(void)ShowSearchFab {
    KCFloatingActionButton *fab = [[KCFloatingActionButton alloc] init];
    fab.buttonColor = [UIColor grayColor];
    __weak KCFloatingActionButton *_fab = fab;
    [fab addItem:@"Search" icon:[UIImage imageNamed:@"search.png"] handler:^(KCFloatingActionButtonItem *item) {
        [self performSegueWithIdentifier:@"segueFindTrailToSearchTrail" sender:self];
        [_fab close];
    }];
    [self.view addSubview:fab];
}

-(void)alertTextFieldAutoComplete:(UITextField*)textField {
    
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController)
    {
        self.searchText = textField;
//        UITextField *login = alertController.textFields.firstObject;
//        UIAlertAction *okAction = alertController.actions.lastObject;
//        okAction.enabled = login.text.length > 2;
    }
    
}

-(void)goToSearchedTrail:(NSString*)trailName {
    
}

//-(void)getTrailName {
//    Trails *trails = [[Trails alloc]init];
//    self.trailName = [trails GetTrailNames];
//    
//    self.searchText = [[UITextField alloc] init];
//    
//    self.autocompleteTableView = [[UITableView alloc] initWithFrame:
//                             CGRectMake(0, 80, 320, 120) style:UITableViewStylePlain];
//    self.autocompleteTableView.delegate = self;
//    self.autocompleteTableView.dataSource = self;
//    self.autocompleteTableView.scrollEnabled = YES;
//    self.autocompleteTableView.hidden = YES;
//    [self.view addSubview:self.autocompleteTableView];
//}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    self.autocompleteTableView.hidden = NO;
//    
//    NSString *substring = [NSString stringWithString:textField.text];
//    substring = [substring
//                 stringByReplacingCharactersInRange:range withString:string];
//    return YES;
//}
@end
