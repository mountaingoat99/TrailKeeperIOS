//
//  CommentsViewController.h
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 11/1/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsViewController : UIViewController

@property (strong, nonatomic) NSString *sentTrailObjectId;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnDrawer;

- (IBAction)btn_drawerClick:(id)sender;

@end
