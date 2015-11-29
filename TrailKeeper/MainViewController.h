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

@property (weak, nonatomic) IBOutlet UITableView *tbltrailCards;
@property (strong, nonatomic) NSString *sentTrailObjectId;
@property (nonatomic) BOOL newUser;

- (IBAction)btn_drawerClick:(id)sender;

@end
