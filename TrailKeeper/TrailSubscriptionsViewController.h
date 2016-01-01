//
//  TrailSubscriptionsViewController.h
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 11/1/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomNotificationCell.h"

@interface TrailSubscriptionsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CustomNotificationDelegate>

@property (strong, nonatomic) NSString *sentTrailObjectId;

@property (weak, nonatomic) IBOutlet UITableView *tblNotifications;

- (IBAction)btn_drawerClick:(id)sender;

@end
