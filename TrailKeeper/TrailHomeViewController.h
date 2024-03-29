//
//  TrailHomeViewController.h
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 11/11/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrailHomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSString *sentTrailObjectId;
@property (nonatomic) BOOL isFromCommentViewController;

@property (weak, nonatomic) IBOutlet UIView *vTrailHomeBackground;
@property (weak, nonatomic) IBOutlet UITableView *tblComments;
@property (weak, nonatomic) IBOutlet UIView *vCommentBackground;
@property (weak, nonatomic) IBOutlet UILabel *lblTrailName;
@property (weak, nonatomic) IBOutlet UILabel *lblCityState;
@property (weak, nonatomic) IBOutlet UIImageView *imageStatus;
@property (weak, nonatomic) IBOutlet UIImageView *imageEasy;
@property (weak, nonatomic) IBOutlet UIImageView *imageMedium;
@property (weak, nonatomic) IBOutlet UIImageView *imageHard;
@property (weak, nonatomic) IBOutlet UIButton *btnCloseOpen;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnMapButton;
@property (weak, nonatomic) IBOutlet UIButton *btnSubscribe;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;
@property (weak, nonatomic) IBOutlet UIButton *btnAllComments;
@property (weak, nonatomic) IBOutlet UIButton *btnAddComment;

- (IBAction)btn_subscribeClick:(id)sender;
- (IBAction)btn_statusClick:(id)sender;
- (IBAction)btn_AllCommentsClick:(id)sender;
- (IBAction)btn_LeaveCommentClick:(id)sender;
- (IBAction)btn_MapClick:(id)sender;

@end
