//
//  MainViewController.h
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/31/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tbltrailCards;

- (IBAction)btn_drawerClick:(id)sender;

-(void)getTrails:(NSMutableArray*)trails;

@end
