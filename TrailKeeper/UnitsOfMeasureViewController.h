//
//  UnitsOfMeasureViewController.h
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 11/26/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UnitsOfMeasureViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentMeasurements;

- (IBAction)btn_indexChanged:(id)sender;
- (IBAction)btn_saveClick:(id)sender;

@end
