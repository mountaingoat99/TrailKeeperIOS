//
//  AddTrailViewController.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 11/1/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "AddTrailViewController.h"
#import "AppDelegate.h"
#import "GeoLocationHelper.h"
#import "AlertControllerHelper.h"
#import "HTAutocompleteManager.h"
#import "StateListHelper.h"
#import "ConnectionDetector.h"

@interface AddTrailViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) PFGeoPoint *userLocation;
@property (nonatomic, strong) MKPointAnnotation *point;

-(void)handleMapPress:(UIGestureRecognizer *)gestureRecognizer;
-(void)clearMapAnnotations;
-(BOOL)validateFields;
-(BOOL)saveNewTrail;
-(void)resetAll;

@end

#define METERS_PER_MILE 1609.344

@implementation AddTrailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    self.mapView.delegate = self;
    
    // get users current location and zoom in
    self.userLocation = [GeoLocationHelper GetUsersCurrentPostion];
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = self.userLocation.latitude;
    zoomLocation.longitude = self.userLocation.longitude;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation,
                                                                       20.0 * METERS_PER_MILE, 20.0 * METERS_PER_MILE);
    [self.mapView setRegion:viewRegion animated:YES];
    self.point = nil;
    
    // add the tap gesture to the map
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleMapPress:)];
    lpgr.minimumPressDuration = 0.5;
    [self.mapView addGestureRecognizer:lpgr];
    
    // set up the delegates on the text boxes
    //self.txtTrailName.keyboardAppearance = UIKeyboardAppearanceDark;
    self.txtTrailName.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.txtTrailName.keyboardType = UIKeyboardTypeDefault;
    self.txtTrailName.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    self.txtTrailName.delegate = self;
    
    self.txtCity.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.txtCity.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    self.txtCity.keyboardType = UIKeyboardTypeDefault;
    self.txtCity.delegate = self;
    
    self.txtLength.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.txtLength.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    self.txtLength.keyboardType = UIKeyboardTypeNumberPad;
    self.txtLength.returnKeyType = UIReturnKeyDone;
    self.txtLength.delegate = self;
    
    // sets the default datasouce for the autocomplete text field
    [HTAutocompleteTextField setDefaultAutocompleteDataSource:[HTAutocompleteManager sharedManager]];
    // set up the autocomplete text
    self.txtState.autocompleteType = HTAutoCompleteStates;
    self.txtState.autocorrectionType = UITextAutocorrectionTypeNo;
    self.txtState.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.txtState.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    self.txtState.keyboardType = UIKeyboardTypeDefault;
    self.txtState.delegate = self;
    
    self.txtCountry.autocompleteType = HTAutoCompleteCountries;
    self.txtCountry.autocorrectionType = UITextAutocorrectionTypeNo;
    self.txtCountry.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.txtCountry.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    self.txtCountry.keyboardType = UIKeyboardTypeDefault;
    self.txtCountry.delegate = self;
    // right now lets just make USA the default country
    self.txtCountry.text = @"United States";
    self.txtCountry.enabled = NO;
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    if ([[preferences objectForKey:@"userMeasurements"] isEqualToString:@"imperial"]) {
        self.txtLength.placeholder  = @"Length - Miles";
    } else {
        self.txtLength.placeholder  = @"Length - Kilometers";
    }
    
    [self.switchCurrentLocation setOnTintColor:[UIColor grayColor]];
    
    self.segmentedControlSkills.delegate = self;
    
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
    
    // show the user how to log press the map
    [AlertControllerHelper ShowAlert:@"" message:@"Long press the map to drop a trail location pin" view:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma segment methods

-(void)multiSelect:(MultiSelectSegmentedControl *)multiSelectSegmentedControl didChangeValue:(BOOL)selected atIndex:(NSUInteger)index {
    
    if (selected) {
        NSLog(@"multiSelect with tag %li selected button at index: %lu", self.segmentedControlSkills.tag, (unsigned long)index);
    } else {
        NSLog(@"multiSelect with tag %li deselected button at index: %lu", self.segmentedControlSkills.tag, (unsigned long)index);
    }
    NSLog(@"selected: '%@'", [multiSelectSegmentedControl.selectedSegmentTitles componentsJoinedByString:@","]);
}

#pragma events

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.txtTrailName) {
        [self.txtCity becomeFirstResponder];
    }
    if (textField == self.txtCity) {
        [self.txtState becomeFirstResponder];
    }
    if (textField == self.txtState) {
        [self.txtLength becomeFirstResponder];
    }
    // commented out until we dd more countries - USA default right now
//    if (textField == self.txtCountry) {
//        [self.txtLength becomeFirstResponder];
//    }
    if (textField == self.txtLength) {
        [textField resignFirstResponder];
    }
    
    //[textField resignFirstResponder];
    return YES;
}

// hide the keyboard on outside touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
- (IBAction)btn_drawerClick:(id)sender {
    [self.appDelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:true completion:nil];
}

- (IBAction)switch_indexChanged:(id)sender {
    if ([self.switchCurrentLocation isOn]) {
        [self clearMapAnnotations];
    }
}

- (IBAction)segment_indexChanged:(id)sender {
}

- (IBAction)btn_saveClick:(id)sender {
    BOOL validSave;
    if (![self validateFields]) {
        return;
    } else {
        validSave = [self saveNewTrail];
    }
    if (validSave) {
        [AlertControllerHelper ShowAlert:@"Trail Saved" message:[NSString stringWithFormat:@"%@ has been saved. Please request a Trail Pin in the side menu to update the trail conditions. \nIf you have a shady internet connection the new trail may not show up right away.", self.txtTrailName.text] view:self];
        [self resetAll];
    } else {
        [AlertControllerHelper ShowAlert:@"Trail Not Saved" message:@"The new trail has not been saved. Please try again" view:self];
    }
}

#pragma private methods

- (void)handleMapPress:(UIGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
        // turn the switch off if they use the map
        if ([self.switchCurrentLocation isOn]) {
            self.switchCurrentLocation.on = NO;
        }
        
        // remove any old annotations
        [self clearMapAnnotations];
        
        CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
        CLLocationCoordinate2D touchMapCoordinate =
        [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        
        self.point = [[MKPointAnnotation alloc] init];
        self.point.coordinate = touchMapCoordinate;
        self.point.title = @"New Trail Location";
        [self.mapView addAnnotation:self.point];
        
        [self.mapView selectAnnotation:self.point animated:YES];
    }
//    else if (gestureRecognizer.state == UIGestureRecognizerStateBegan){
//        NSLog(@"UIGestureRecognizerStateBegan.");
//        //Do Whatever You want on Began of Gesture
//    }
}

-(void)clearMapAnnotations {
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        [self.mapView removeAnnotation:annotation];
    }
    self.point = nil;
}

-(BOOL)validateFields {
    BOOL validState = YES;
    
    if (self.txtTrailName.text.length < 3) {
        [AlertControllerHelper ShowAlert:@"Trail Name?" message:@"Please add a valid trail name at least longer than 4 digits" view:self];
        return NO;
    }
    if (self.txtCity.text.length == 0) {
        [AlertControllerHelper ShowAlert:@"City" message:@"Please add a city" view:self];
        return NO;
    }
    if (self.txtState.text.length == 0) {
        [AlertControllerHelper ShowAlert:@"State?" message:@"Please add a state" view:self];
        return NO;
    }
    
    // make sure the state is in the list of states
    for (NSString *name in [[StateListHelper GetStates]allValues]) {
        if ([self.txtState.text isEqualToString:name]) {
            validState = YES;
            break;
        } else {
            validState = NO;
        }
    }
    if (!validState) {
        [AlertControllerHelper ShowAlert:@"State?" message:@"That state does not seem to exist, can you try again?" view:self];
        return NO;
    }
    
    if (self.txtCountry.text.length == 0) {
        // make sure the country is legit
        [AlertControllerHelper ShowAlert:@"Country?" message:@"Please add a country" view:self];
        return NO;
    }
    // TODO when we add more countries we will want to make sure they are valid
    // use last saved current location if no connection
    if (self.point == nil && self.switchCurrentLocation.on == false) {
        [AlertControllerHelper ShowAlert:@"Location?" message:@"Please add a location to the map or flip the Use Current Location switch" view:self];
        return NO;
    }
    
        return YES;
}

-(BOOL)saveNewTrail {
    BOOL isValid = YES;
    
    @try {
        Trails *trail = [[Trails alloc] init];
        trail.trailName = self.txtTrailName.text;
        trail.status = @2;
        trail.city = self.txtCity.text;
        trail.state = self.txtState.text;
        trail.country = self.txtCountry.text;
        // convert the length
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *myNumber = [f numberFromString:self.txtLength.text];
        NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
        if ([[preferences objectForKey:@"userMeasurements"] isEqualToString:@"imperial"]) {
            //convert the length here is preferences are miles;
            double miles = [myNumber doubleValue];
            miles = miles * 1.6;
            trail.length = [NSNumber numberWithDouble:miles];
        } else {
            trail.length = myNumber;
        }
        
        if ([ConnectionDetector hasConnectivity]) {
            // see if they are using a point or user location
            if (self.point != nil) {
                trail.geoLocation = [PFGeoPoint geoPointWithLatitude:self.point.coordinate.latitude longitude:self.point.coordinate.longitude];
            } else {
                trail.geoLocation = self.userLocation;
            }
        } else {
            if (self.point != nil) {
                trail.geoLocation = [PFGeoPoint geoPointWithLatitude:self.point.coordinate.latitude longitude:self.point.coordinate.longitude];
            } else {
                // let us see if the location is filled and not the default value
                if ((self.userLocation.latitude > 0 || self.userLocation.longitude > 0)
                    || (self.userLocation.latitude != 42.566763 || self.userLocation.longitude != -87.887405)) {
                    trail.geoLocation = self.userLocation;
                } else {
                    // see if we have a previous saved location
                    if (self.appDelegate.currentLocation.coordinate.latitude <= 0 || self.appDelegate.currentLocation.coordinate.longitude <= 0) {
                        [AlertControllerHelper ShowAlert:@"No Connection" message:@"We can't get a location right now. Please try again when you have a connection" view:self];
                        return NO;
                    } else {
                        
                        trail.geoLocation = [PFGeoPoint geoPointWithLatitude:self.appDelegate.currentLocation.coordinate.longitude longitude:self.appDelegate.currentLocation.coordinate.longitude];
                    }
                }
            }            
        }
        
        // see what skill segements are on
        NSIndexSet *selectedIndices = self.segmentedControlSkills.selectedSegmentIndexes;
        if ([selectedIndices containsIndex:0]) {
            trail.skillEasy = YES;
        } else {
            trail.skillEasy = NO;
        }
        if ([selectedIndices containsIndex:1]) {
            trail.skillMedium = YES;
        } else {
            trail.skillMedium = NO;
        }
        if ([selectedIndices containsIndex:2]) {
            trail.skillHard = YES;
        } else {
            trail.skillHard = NO;
        }
        
        // now save the trail
        [trail CreateNewTrail:trail];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
        isValid = NO;
    }
    return isValid;
}

-(void)resetAll {
    self.txtTrailName.text = @"";
    self.txtCity.text = @"";
    self.txtState.text = @"";
    self.txtCountry.text = @"";
    self.txtLength.text = @"";
    [self.segmentedControlSkills setSelectedSegmentIndex:UISegmentedControlNoSegment];
    self.switchCurrentLocation.on = NO;
    // clear all text fields and hide keyboard
    if ([self.txtTrailName isFirstResponder]) {
        [self.txtTrailName resignFirstResponder];
    }
    if ([self.txtCity isFirstResponder]) {
        [self.txtCity resignFirstResponder];
    }
    if ([self.txtState isFirstResponder]) {
        [self.txtState resignFirstResponder];
    }
    if ([self.txtCountry isFirstResponder]) {
        [self.txtCountry resignFirstResponder];
    }
    if ([self.txtLength isFirstResponder]) {
        [self.txtLength resignFirstResponder];
    }
}


@end
