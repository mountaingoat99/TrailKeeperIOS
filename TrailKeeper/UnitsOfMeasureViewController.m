//
//  UnitsOfMeasureViewController.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 11/26/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "UnitsOfMeasureViewController.h"
#import "AlertControllerHelper.h"
#import "AppDelegate.h"
#import "AdMobView.h"

@interface UnitsOfMeasureViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSUserDefaults *preferences;

@end

@implementation UnitsOfMeasureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [AdMobView GetAdMobView:self];
    
    self.preferences = [NSUserDefaults standardUserDefaults];
    [self.preferences objectForKey:userMeasurementKey];
    NSLog(@"User default for measurement is %@", [self.preferences objectForKey:userMeasurementKey]);

    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        // color attributes for the segmented controls in iphone
        NSDictionary *segmentedControlTextAttributes = @{NSForegroundColorAttributeName:self.appDelegate.colorButtons, NSFontAttributeName:[UIFont systemFontOfSize:14.0f]};
        NSDictionary *segmentedControlTextAttributesPicked = @{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont systemFontOfSize:14.0f]};
        [[UISegmentedControl appearance] setTitleTextAttributes:segmentedControlTextAttributes forState:UIControlStateNormal];
        [[UISegmentedControl appearance] setTitleTextAttributes:segmentedControlTextAttributes forState:UIControlStateHighlighted];
        [[UISegmentedControl appearance] setTitleTextAttributes:segmentedControlTextAttributesPicked forState:UIControlStateSelected];
    } else {
        // color and size attributes for the SC in iPad
        NSDictionary *segmentedControlTextAttributesiPad = @{NSForegroundColorAttributeName:self.appDelegate.colorButtons, NSFontAttributeName:[UIFont systemFontOfSize:18.0f]};
        NSDictionary *segmentedControlTextAttributesiPadPicked = @{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont systemFontOfSize:18.0f]};
        [[UISegmentedControl appearance] setTitleTextAttributes:segmentedControlTextAttributesiPad forState:UIControlStateNormal];
        [[UISegmentedControl appearance] setTitleTextAttributes:segmentedControlTextAttributesiPad forState:UIControlStateHighlighted];
        [[UISegmentedControl appearance] setTitleTextAttributes:segmentedControlTextAttributesiPadPicked forState:UIControlStateSelected];
    }
    
    if ([[self.preferences objectForKey:userMeasurementKey] isEqualToString:imperialDefault] ) {
        [self.segmentMeasurements setSelectedSegmentIndex:0];
    } else {
        [self.segmentMeasurements setSelectedSegmentIndex:1];
    }
    
    [self.btnSave setTitleColor:self.appDelegate.colorButtons forState:UIControlStateNormal];
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
        [self.preferences setObject:imperialDefault forKey:userMeasurementKey];
    } else {
        [self.preferences setObject:metricDefault forKey:userMeasurementKey];
    }
    
    [AlertControllerHelper ShowAlert:@"Default Measurement" message:[NSString stringWithFormat:@"Measurements have been updated to %@.", [self.preferences objectForKey:userMeasurementKey]] view:self];
}

@end
