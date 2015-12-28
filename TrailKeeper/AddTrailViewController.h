//
//  AddTrailViewController.h
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 11/1/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultiSelectSegmentedControl.h"
#import "HTAutocompleteManager.h"
#import <MapKit/MapKit.h>

@interface AddTrailViewController : UIViewController <MultiSelectSegmentedControlDelegate, MKMapViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet MultiSelectSegmentedControl *segmentedControlSkills;
@property (weak, nonatomic) IBOutlet UITextField *txtTrailName;
@property (weak, nonatomic) IBOutlet UITextField *txtCity;
@property (unsafe_unretained, nonatomic) IBOutlet HTAutocompleteTextField *txtState;
@property (unsafe_unretained, nonatomic) IBOutlet HTAutocompleteTextField *txtCountry;
@property (weak, nonatomic) IBOutlet UITextField *txtLength;
@property (weak, nonatomic) IBOutlet UISwitch *switchCurrentLocation;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)btn_drawerClick:(id)sender;
- (IBAction)switch_indexChanged:(id)sender;
- (IBAction)segment_indexChanged:(id)sender;
- (IBAction)btn_saveClick:(id)sender;

@end
