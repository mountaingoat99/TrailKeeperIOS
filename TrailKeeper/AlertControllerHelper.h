//
//  AlertControllerHelper.h
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/11/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertControllerHelper : UIViewController

+(void)ShowAlert:(NSString *)title message:(NSString *)message view:(UIViewController*)view;

@end
