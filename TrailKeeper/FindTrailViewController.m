//
//  FindTrailViewController.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 11/1/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "FindTrailViewController.h"
#import "AppDelegate.h"

@interface FindTrailViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;

@end

@implementation FindTrailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.appDelegate.whichController = self;
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

- (IBAction)btn_back:(id)sender {
    NSLog(@"Button click to return from Find Trails");
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NSString *name = NSStringFromClass([self.appDelegate.whichController class]);
    id lastWindow = [mainStoryBoard instantiateViewControllerWithIdentifier:name];
    UINavigationController *centerNav = [[UINavigationController alloc] initWithRootViewController:lastWindow];
    self.appDelegate.drawerController.centerViewController = centerNav;
}
@end
