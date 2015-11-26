//
//  CommentsViewController.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 11/1/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "CommentsViewController.h"
#import "AppDelegate.h"
#import "TrailHomeViewController.h"

@interface CommentsViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;

@end

@implementation CommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (self.sentTrailObjectId != nil) {
        self.btnDrawer.image = [UIImage imageNamed:@"back.png"];
    } else {
        self.btnDrawer.image = [UIImage imageNamed:@"drawer_icon.png"];
    }
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"segueCommentToTrailHome"]) {
        TrailHomeViewController *home = [segue destinationViewController];
        home.sentTrailObjectId = self.sentTrailObjectId;
    }
}


- (IBAction)btn_drawerClick:(id)sender {
    if (self.sentTrailObjectId != nil) {
        [self performSegueWithIdentifier:@"segueCommentToTrailHome" sender:self];
    } else {
        [self.appDelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:true completion:nil];
    }
}
@end
