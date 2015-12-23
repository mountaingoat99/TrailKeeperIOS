//
//  MapViewController.h
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 11/1/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) NSString *sentTrailObjectId;
@property (nonatomic) BOOL navigateBack;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnNavigation;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)btn_drawerClick:(id)sender;

@end
