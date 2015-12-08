//
//  SearchTrailViewController.h
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 12/7/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTrailViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *viewBackground;
@property (weak, nonatomic) IBOutlet UITextField *txtAutoCompleteTrailName;

- (IBAction)btn_SearchClick:(id)sender;

@end
