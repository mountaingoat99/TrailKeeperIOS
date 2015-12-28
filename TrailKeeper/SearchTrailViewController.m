//
//  SearchTrailViewController.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 12/7/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "SearchTrailViewController.h"
#import "WYPopoverController.h"
#import "Trails.h"
#import "HTAutocompleteManager.h"
#import "AlertControllerHelper.h"
#import "TrailHomeViewController.h"
#import "AppDelegate.h"

@interface SearchTrailViewController ()

@property (nonatomic, strong) NSArray *trailListMain;
@property (nonatomic, strong) NSString *sentTrailObjectId;

-(void)goToTrail;

@end

@implementation SearchTrailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // sets the default datasouce for the autocomplete text field
    [HTAutocompleteTextField setDefaultAutocompleteDataSource:[HTAutocompleteManager sharedManager]];
    
    self.viewBackground.backgroundColor = [UIColor whiteColor];
    self.viewBackground.layer.masksToBounds = NO;
    self.viewBackground.layer.cornerRadius = 3.0;
    self.viewBackground.layer.shadowOffset = CGSizeMake(1, 0);
    self.viewBackground.layer.shadowOpacity = 0.5;
    
    
    self.txtAutoCompleteTrailName.autocompleteType = HTAutoCompleteTrailNames;
    self.txtAutoCompleteTrailName.autocorrectionType = UITextAutocorrectionTypeNo;
    self.txtAutoCompleteTrailName.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.txtAutoCompleteTrailName.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    self.txtAutoCompleteTrailName.delegate = self;
    
    [self.txtAutoCompleteTrailName becomeFirstResponder];
    
    //[self loadData];
    self.navigationItem.title = @"Search For Trail";
    
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        // this doesn't seem to work
        [WYPopoverController setDefaultTheme:[WYPopoverTheme theme]];
        WYPopoverBackgroundView *appearance = [WYPopoverBackgroundView appearance];
        appearance.backgroundColor = [UIColor colorWithRed:.16 green:.45 blue:.81 alpha:1];
        
    } else {
        self.popoverPresentationController.backgroundColor = [UIColor colorWithRed:.16 green:.45 blue:.81 alpha:1];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

- (IBAction)btn_SearchClick:(id)sender {
    [self goToTrail];
}

#pragma private methods

-(void)goToTrail {
    
    id<FindTrailDelegate> strongDelegate = self.delegate;
    

        Trails *trails = [[Trails alloc] init];
        self.sentTrailObjectId = [trails GetIdByTrailName:self.txtAutoCompleteTrailName.text];
        if (self.sentTrailObjectId != nil) {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                [self.controller dismissPopoverAnimated:YES];
            } else {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
            [strongDelegate GoToTrailHome:self.sentTrailObjectId];
            
//            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//            TrailHomeViewController *mainView = [mainStoryBoard instantiateViewControllerWithIdentifier:@"TrailHomeViewController"];
//            mainView.sentTrailObjectId = self.sentTrailObjectId;
//            UINavigationController *centerNav = [[UINavigationController alloc] initWithRootViewController:mainView];
//            appDelegate.drawerController.centerViewController = centerNav;
//            [appDelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:NO completion:nil];
            //[self performSegueWithIdentifier:@"segueSearchTrailToTrailHome" sender:self];
//        } else {
//            [AlertControllerHelper ShowAlert:@"No Results" message:@"We cannot find that trail! Go ahead and add it yourself so other users know about it" view:self];
//        }
//        
//    } else {
//        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
//            [self.controller dismissPopoverAnimated:YES];
//        } else {
//            [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}

@end
