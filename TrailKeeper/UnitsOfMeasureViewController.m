//
//  UnitsOfMeasureViewController.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 11/26/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "UnitsOfMeasureViewController.h"
#import "AlertControllerHelper.h"

@interface UnitsOfMeasureViewController ()

@property (nonatomic, strong) NSUserDefaults *preferences;
@property (nonatomic, strong) NSString *userMeasurements;

@end

@implementation UnitsOfMeasureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.preferences = [NSUserDefaults standardUserDefaults];
    [self.preferences objectForKey:@"userMeasurements"];
    NSLog(@"User default for measurement is %@", [self.preferences objectForKey:@"userMeasurements"]);
    self.userMeasurements = @"userMeasurements";

    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        // color attributes for the segmented controls in iphone
        NSDictionary *segmentedControlTextAttributes = @{NSForegroundColorAttributeName:[UIColor grayColor], NSFontAttributeName:[UIFont systemFontOfSize:14.0f]};
        NSDictionary *segmentedControlTextAttributesPicked = @{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont systemFontOfSize:14.0f]};
        [[UISegmentedControl appearance] setTitleTextAttributes:segmentedControlTextAttributes forState:UIControlStateNormal];
        [[UISegmentedControl appearance] setTitleTextAttributes:segmentedControlTextAttributes forState:UIControlStateHighlighted];
        [[UISegmentedControl appearance] setTitleTextAttributes:segmentedControlTextAttributesPicked forState:UIControlStateSelected];
    } else {
        // color and size attributes for the SC in iPad
        NSDictionary *segmentedControlTextAttributesiPad = @{NSForegroundColorAttributeName:[UIColor grayColor], NSFontAttributeName:[UIFont systemFontOfSize:18.0f]};
        NSDictionary *segmentedControlTextAttributesiPadPicked = @{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont systemFontOfSize:18.0f]};
        [[UISegmentedControl appearance] setTitleTextAttributes:segmentedControlTextAttributesiPad forState:UIControlStateNormal];
        [[UISegmentedControl appearance] setTitleTextAttributes:segmentedControlTextAttributesiPad forState:UIControlStateHighlighted];
        [[UISegmentedControl appearance] setTitleTextAttributes:segmentedControlTextAttributesiPadPicked forState:UIControlStateSelected];
    }
    
    if ([[self.preferences objectForKey:@"userMeasurements"] isEqualToString:@"imperial"] ) {
        [self.segmentMeasurements setSelectedSegmentIndex:0];
    } else {
        [self.segmentMeasurements setSelectedSegmentIndex:1];
    }
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

#pragma mark - events

- (IBAction)btn_indexChanged:(id)sender {
    
    switch (self.segmentMeasurements.selectedSegmentIndex) {
        case 0:
            NSLog(@"Changed Measurements to Imperial");
            break;
        case 1:
            NSLog(@"Changed Measurements to Metric");
            break;
    }
}

- (IBAction)btn_saveClick:(id)sender {
        if (self.segmentMeasurements.selectedSegmentIndex == 0) {
        [self.preferences setObject:@"imperial" forKey:@"userMeasurements"];
    } else {
        [self.preferences setObject:@"metric" forKey:@"userMeasurements"];
    }
    
    [AlertControllerHelper ShowAlert:@"Default Measurement" message:[NSString stringWithFormat:@"Measurements have been updated to %@.", [self.preferences objectForKey:@"userMeasurements"]] view:self];
}

@end
