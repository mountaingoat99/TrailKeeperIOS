//
//  MainViewController.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/31/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "MainViewController.h"
//#import "UIViewController+MMDrawerController.h"
#import "AppDelegate.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btn_drawerClick:(id)sender {
    NSLog(@"Left Drawer button tapped");
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.centerController toggleDrawerSide:MMDrawerSideLeft animated:true completion:nil];
    //[self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
@end
