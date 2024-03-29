//
//  FindTrailViewController.h
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 11/1/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindTrailSectionHeaderView.h"
#import "SearchTrailViewController.h"

@interface FindTrailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, SectionHeaderViewDelegate, FindTrailDelegate>

@property (strong, nonatomic) NSString *sentTrailObjectId;
@property (nonatomic, retain) UIPopoverController *popoverContr;

@property (weak, nonatomic) IBOutlet UITableView *tblFindTrail;

- (IBAction)btn_drawerClick:(id)sender;
- (IBAction)btn_searchClick:(id)sender;

@end
