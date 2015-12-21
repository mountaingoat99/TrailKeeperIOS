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
#import "TrailMapLocations.h"

@interface MapViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) PFGeoPoint *userLocation;

-(void)getCloseTrailLocations;
-(void)plotTrailPositions;

@end

#define METERS_PER_MILE 1609.344

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    // get users current location and zoom in
    self.userLocation = [GeoLocationHelper GetUsersCurrentPostion];
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = self.userLocation.latitude;
    zoomLocation.longitude = self.userLocation.longitude;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation,
        10.0 * METERS_PER_MILE, 10.0 * METERS_PER_MILE);
    [self.mapView setRegion:viewRegion animated:YES];
    //[self.mapView addAnnotation:@"Home"];
    
    [self plotTrailPositions];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
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
    [self.appDelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:true completion:nil];
}

-(void)plotTrailPositions {
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        [self.mapView removeAnnotation:annotation];
    }
    
    Trails *trails = [[Trails alloc] init];
    NSArray *locations = [trails GetClosestTrailsForHomeScreen];
    
    for (Trails *t in locations) {
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = t.geoLocation.latitude;
        coordinate.longitude = t.geoLocation.longitude;
        
        TrailMapLocations *annotation = [[TrailMapLocations alloc] initWithName:t.trailName coordinate:coordinate       ];
        [self.mapView addAnnotation:annotation];
    }
}
@end
