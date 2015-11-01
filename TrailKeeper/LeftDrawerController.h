//
//  LeftDrawerController.h
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 11/1/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftDrawerController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tblSettings;
@property (weak, nonatomic) IBOutlet UIImageView *appIconImage;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;

@end
