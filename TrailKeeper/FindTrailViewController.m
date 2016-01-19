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
#import "WYPopoverController.h"
#import "SearchTrailViewController.h"
#import "AlertControllerHelper.h"
#import "MapViewController.h"

static NSString *SectionHeaderViewIdentifier = @"SectionHeaderViewIdentifier";

@interface FindTrailViewController () <WYPopoverControllerDelegate>
{
    WYPopoverController* popoverController;
}

@property (nonatomic, strong) NSMutableArray *states;
@property (nonatomic, strong) NSMutableArray *sectionInfoArray;
@property (nonatomic) NSInteger openSectionIndex;
@property (nonatomic) NSInteger uniformRowHeight;
@property (nonatomic, strong) PFGeoPoint *userLocation;
@property (nonatomic) UITableView *autocompleteTableView;
@property (nonatomic) UITextField *searchText;
@property (nonatomic, strong) NSString *measurementLabel;

@property (nonatomic) IBOutlet FindTrailSectionHeaderView *sectionHeaderView;
@property (nonatomic, strong) AppDelegate *appDelegate;

-(void)loadData;
-(void)openDialog:(NSString*)trailName;
-(void)openAppleMaps;
-(void)openTrailHome;

@end

#pragma mark -

#define DEFAULT_ROW_HEIGHT 78
#define HEADER_HEIGHT 48

@implementation FindTrailViewController

@synthesize popoverContr;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    if ([[preferences objectForKey:userMeasurementKey] isEqualToString:imperialDefault]) {
        self.measurementLabel = @" Miles";
    } else {
        self.measurementLabel = @" Kilometers";
    }
    
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
    
    // add some view properties
    [self.tblFindTrail setSeparatorColor:[UIColor clearColor]];
    [self.tblFindTrail setBackgroundColor:[UIColor clearColor]];
    
    // make sure the back button text does not show
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
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

-(BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueFindTrailToTrailHome"]) {
        TrailHomeViewController *home = [segue destinationViewController];
        home.sentTrailObjectId = self.sentTrailObjectId;
    }
    if ([segue.identifier isEqualToString:@"segueFindTrailToMap"]) {
        MapViewController *map = [segue destinationViewController];
        map.sentTrailObjectId = self.sentTrailObjectId;
        map.navigateBack = YES;
        self.appDelegate.whichController = self;
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
    milesFromCurrent = [milesFromCurrent stringByAppendingString:self.measurementLabel];
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

    [self openDialog:trail.trailName];
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

- (IBAction)btn_searchClick:(id)sender {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        
        UIStoryboard *sboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SearchTrailViewController *search = [sboard instantiateViewControllerWithIdentifier:@"SearchTrailViewController"];
        search.delegate = self;
        popoverController = [[WYPopoverController alloc] initWithContentViewController:search];
        popoverController.delegate = self;
        popoverController.popoverContentSize = CGSizeMake(280, 110);
        search.controller = popoverController;
        [popoverController presentPopoverFromBarButtonItem:(UIBarButtonItem *)sender permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
        
    } else {
        
        UIStoryboard *sboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SearchTrailViewController *search = [sboard instantiateViewControllerWithIdentifier:@"SearchTrailViewController"];
        popoverContr = [[UIPopoverController alloc] initWithContentViewController:search];
        popoverContr.popoverContentSize = CGSizeMake(400, 400);
        [popoverContr presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
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

-(void)openDialog:(NSString*)trailName {
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:trailName
                                message:nil
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel Action");
                                   }];
    
    UIAlertAction *trailScreenAction = [UIAlertAction
                                        actionWithTitle:@"Trail Home"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction *action)
                                        {
                                            NSLog(@"Trail Home Action");
                                            [self openTrailHome];
                                        }];
    
    UIAlertAction *mapAction = [UIAlertAction
                                actionWithTitle:@"Map"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction *action)
                                {
                                    NSLog(@"Subscribe No Action");
                                    [self openAppleMaps];
                                }];
    
    [alert addAction:cancelAction];
    [alert addAction:trailScreenAction];
    [alert addAction:mapAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)openAppleMaps {
    [self performSegueWithIdentifier:@"segueFindTrailToMap" sender:self];
}

-(void)openTrailHome {
    [self performSegueWithIdentifier:@"segueFindTrailToTrailHome" sender:self];
}

#pragma delegate methods

-(void)GoToTrailHome:(NSString*)sentTrailObjectId {
    
    if (sentTrailObjectId != nil) {
        self.sentTrailObjectId = sentTrailObjectId;
        [self performSegueWithIdentifier:@"segueFindTrailToTrailHome" sender:self];
    } else {
        [AlertControllerHelper ShowAlert:@"No Results" message:@"We cannot find that trail! Go ahead and add it yourself so other users know about it" view:self];
    }
}

@end
