//
//  SearchTrailViewController.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 12/7/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "SearchTrailViewController.h"

@interface SearchTrailViewController ()

-(void)goToTrail;

@end

@implementation SearchTrailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewBackground.backgroundColor = [UIColor whiteColor];
    self.viewBackground.layer.masksToBounds = NO;
    self.viewBackground.layer.cornerRadius = 3.0;
    self.viewBackground.layer.shadowOffset = CGSizeMake(1, 0);
    self.viewBackground.layer.shadowOpacity = 0.5;
    
    self.txtAutoCompleteTrailName.delegate = self;
    
    [self.txtAutoCompleteTrailName becomeFirstResponder];
    
    self.navigationItem.title = @"Search For Trail";
    
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.txtAutoCompleteTrailName) {
        [self goToTrail];
    }
    return YES;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)btn_SearchClick:(id)sender {
    [self goToTrail];
}

#pragma private methods

-(void)goToTrail {
    
}

@end
