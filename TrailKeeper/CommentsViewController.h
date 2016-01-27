//
//  CommentsViewController.h
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 11/1/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTAutocompleteTextField.h"

@interface CommentsViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (unsafe_unretained, nonatomic) IBOutlet HTAutocompleteTextField *txtAutoComplete;

@property (strong, nonatomic) NSString *sentTrailObjectId;
@property (nonatomic) BOOL isFromCommentViewController;
@property (weak, nonatomic) IBOutlet UITableView *tblFindComment;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnDrawer;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentSearch;

- (IBAction)btn_drawerClick:(id)sender;
- (IBAction)Filter_IndexChanged:(id)sender;

@end
