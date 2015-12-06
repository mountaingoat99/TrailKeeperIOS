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
#import "States.h"
#import "Trails.h"
#import "AppDelegate.h"

static NSString *SectionHeaderViewIdentifier = @"SectionHeaderViewIdentifier";

@interface FindTrailViewController ()

@property (nonatomic, strong) NSMutableArray *states;
@property (nonatomic, strong) NSMutableArray *sectionInfoArray;
@property (nonatomic) NSInteger openSectionIndex;
@property (nonatomic) NSInteger uniformRowHeight;

@property (nonatomic) IBOutlet FindTrailSectionHeaderView *sectionHeaderView;
@property (nonatomic, strong) AppDelegate *appDelegate;

-(void)loadData;

@end

#pragma mark -

#define DEFAULT_ROW_HEIGHT 88
#define HEADER_HEIGHT 48

@implementation FindTrailViewController

-(BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    // make sure the back button text does not show
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if((self.sectionInfoArray == nil) ||
       [self.sectionInfoArray count] != [self numberOfSectionsInTableView:self.tblFindTrail]) {
        
        NSMutableArray *infoArray = [[NSMutableArray alloc] init];
        
        for (States *state in self.states) {
            FindTrailSectionInfo *sectionInfo = [[FindTrailSectionInfo alloc] init];
            sectionInfo.state = state;
            
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.states count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    FindTrailSectionInfo *sectionInfo = (self.sectionInfoArray)[section];
    NSInteger numStoriesInSection = [[sectionInfo.state trails] count];
    
    return sectionInfo ? numStoriesInSection : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *QuoteCellIdentifier = @"QuoteCellIdentifier";
    
    CustomFindTrailCell *cell = (CustomFindTrailCell*)[tableView dequeueReusableCellWithIdentifier:QuoteCellIdentifier];
    
//    if ([MFMailComposeViewController canSendMail]) {
//        
//        if (cell.longPressRecognizer == nil) {
//            UILongPressGestureRecognizer *longPressRecognizer =
//            [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
//            cell.longPressRecognizer = longPressRecognizer;
//        }
//    }
//    else {
//        cell.longPressRecognizer = nil;
//    }
    
    States *state = (States *)[(self.sectionInfoArray)[indexPath.section] trails];
    cell.trails = (state.trails)[indexPath.row];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    FindTrailSectionHeaderView *sectionHeaderView = [self.tblFindTrail dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
    
    FindTrailSectionInfo *sectionInfo = (self.sectionInfoArray)[section];
    sectionInfo.headerView = sectionHeaderView;
    
    sectionHeaderView.titleLabel.text = sectionInfo.state.name;
    sectionHeaderView.section = section;
    sectionHeaderView.delegate = self;
    
    return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FindTrailSectionInfo *sectionInfo = (self.sectionInfoArray)[indexPath.section];
    return [[sectionInfo objectInRowHeightsAtIndex:indexPath.row] floatValue];
    // Alternatively, return rowHeight.
}

#pragma events

- (IBAction)btn_drawerClick:(id)sender {
    [self.appDelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:true completion:nil];
}

#pragma mark - Handling long presses

- (void)handleLongPress:(UILongPressGestureRecognizer *)longPressRecognizer {
    
    /*
     For the long press, the only state of interest is Began.
     When the long press is detected, find the index path of the row (if there is one) at press location.
     If there is a row at the location, create a suitable menu controller and display it.
     */
    if (longPressRecognizer.state == UIGestureRecognizerStateBegan) {
        
        NSIndexPath *pressedIndexPath =
        [self.tblFindTrail indexPathForRowAtPoint:[longPressRecognizer locationInView:self.tblFindTrail]];
        
        if (pressedIndexPath && (pressedIndexPath.row != NSNotFound) && (pressedIndexPath.section != NSNotFound)) {
            
            [self becomeFirstResponder];
            //NSString *title = NSLocalizedString(@"Email", @"Email menu title");
            //APLEmailMenuItem *menuItem =
            //[[APLEmailMenuItem alloc] initWithTitle:title action:@selector(emailMenuButtonPressed:)];
            //menuItem.indexPath = pressedIndexPath;
            
            //UIMenuController *menuController = [UIMenuController sharedMenuController];
            //menuController.menuItems = @[menuItem];
            
            CGRect cellRect = [self.tblFindTrail rectForRowAtIndexPath:pressedIndexPath];
            // lower the target rect a bit (so not to show too far above the cell's bounds)
            cellRect.origin.y += 40.0;
            //[menuController setTargetRect:cellRect inView:self.tblFindTrail];
            //[menuController setMenuVisible:YES animated:YES];
        }
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

@end
