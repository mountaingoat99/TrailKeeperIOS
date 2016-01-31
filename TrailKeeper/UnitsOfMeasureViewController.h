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
@property (weak, nonatomic) IBOutlet UIButton *btnSave;

- (IBAction)btn_indexChanged:(id)sender;
- (IBAction)btn_saveClick:(id)sender;

@end
