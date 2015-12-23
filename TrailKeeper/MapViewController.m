//
//  MapViewController.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 11/1/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "MapViewController.h"
#import "AppDelegate.h"
#import "GeoLocationHelper.h"
#import "TrailHomeViewController.h"
#import "Trails.h"

@interface MapViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) PFGeoPoint *userLocation;
@property (nonatomic, strong) NSString *sentTrailName;

-(void)getTrailName;
-(void)plotAllTrailPositions;
-(void)openDialog:(NSString*)trailName;
-(void)openAppleMaps:(NSString*)trailName;
-(void)openTrailHome:(NSString*)trailName;

@end

#define METERS_PER_MILE 1609.344

@implementation MapViewController

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
    //[self.mapView addAnnotation:@"Home"];
    
    [self getTrailName];
    [self plotAllTrailPositions];
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
    if ([segue.identifier isEqualToString:@"segueMapToTrailHome"]) {
        TrailHomeViewController *home = [segue destinationViewController];
        home.sentTrailObjectId = self.sentTrailObjectId;
    }
}

#pragma MapView Methods

// this breaks the pins
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    NSLog(@"View: %@", view);
    [self openDialog:view.annotation.title];
}

#pragma Events

- (IBAction)btn_drawerClick:(id)sender {
    [self.appDelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:true completion:nil];
}

#pragma private methods

-(void)getTrailName {
    if (self.sentTrailObjectId != nil) {
        Trails *trails = [[Trails alloc] init];
        trails = [trails GetTrailObject:self.sentTrailObjectId];
        self.sentTrailName = trails.trailName;
    }
}

-(void)plotAllTrailPositions {
    
    // get all trails
    Trails *trails = [[Trails alloc] init];
    NSMutableArray *locations = [trails GetAllTrailLocationsByDistance];
    
    // remove any old annotations
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        [self.mapView removeAnnotation:annotation];
    }
    
    int count = 0;
    // add new annotations to the map
    for (Trails *t in locations) {
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = t.geoLocation.latitude;
        coordinate.longitude = t.geoLocation.longitude;
        double distance = [GeoLocationHelper GetDistanceFromCurrentLocation:self.userLocation traillocation:t.geoLocation];
        point.coordinate = coordinate;
        point.title = t.trailName;
        point.subtitle = [NSString stringWithFormat:@"%.2f Miles Away", distance];
        
        [self.mapView addAnnotation:point];
        
        // show the closet trail annotation if this was opened from side menu
        if (count == 0 && self.sentTrailName == nil) {
            [self.mapView selectAnnotation:point animated:YES];
            count++;
        }
        
        // check to see if we have a trail name
        // if we do it was sent from a trail card on the home screen
        // so we want to show that one first
        if (self.sentTrailName != nil && [self.sentTrailName isEqualToString:t.trailName]) {
            [self.mapView selectAnnotation:point animated:YES];
        }
    }
}

-(void)openDialog:(NSString*)trailName {
    NSLog(@"Annotation Trail Name %@", trailName);
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:trailName
                                message:nil
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel Action");
                                   }];
    
    UIAlertAction *trailScreenAction = [UIAlertAction
                                actionWithTitle:@"Trail Home"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction *action)
                                {
                                    NSLog(@"Trail Home Action");
                                    [self openTrailHome:trailName];
                                }];
    
    UIAlertAction *mapAction = [UIAlertAction
                               actionWithTitle:@"Open Maps"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"Subscribe No Action");
                                   [self openAppleMaps:trailName];
                               }];
    
    [alert addAction:cancelAction];
    [alert addAction:trailScreenAction];
    [alert addAction:mapAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)openAppleMaps:(NSString*)trailName {
    // get the name of the trail we just opened
    Trails *trails = [[Trails alloc] init];
    self.sentTrailObjectId = [trails GetIdByTrailName:trailName];
    trails = [trails GetTrailObject:self.sentTrailObjectId];
    
    
    NSString* url = [NSString stringWithFormat:@"http://maps.apple.com/maps?saddr=%f,%f&daddr=%f,%f",self.mapView.userLocation.coordinate.latitude, self.mapView.userLocation.coordinate.longitude, trails.geoLocation.latitude, trails.geoLocation.longitude];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
}

-(void)openTrailHome:(NSString*)trailName {
    // get the trailObjectId from the annotation
    Trails *trails = [[Trails alloc] init];
    self.sentTrailObjectId = [trails GetIdByTrailName:trailName];
    [self performSegueWithIdentifier:@"segueMapToTrailHome" sender:self];
}

@end
