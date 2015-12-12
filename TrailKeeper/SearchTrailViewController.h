//
//  SearchTrailViewController.h
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 12/7/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTAutocompleteTextField.h"
#import "WYPopoverController.h"

@interface SearchTrailViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, assign) WYPopoverController *controller;
@property (weak, nonatomic) IBOutlet UIImageView *viewBackground;
@property (unsafe_unretained, nonatomic) IBOutlet HTAutocompleteTextField *txtAutoCompleteTrailName;

- (IBAction)btn_SearchClick:(id)sender;

@end
