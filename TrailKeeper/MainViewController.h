//
//  MainViewController.h
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/31/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCell.h"

@interface MainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CustomCellDelegate>

@property (strong, nonatomic) NSString *sentTrailObjectId;
@property (nonatomic) BOOL newUser;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
@property (weak, nonatomic) IBOutlet UITableView *tbltrailCards;

- (IBAction)btn_drawerClick:(id)sender;

@end
