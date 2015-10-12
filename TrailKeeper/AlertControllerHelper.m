//
//  AlertControllerHelper.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/11/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "AlertControllerHelper.h"

@interface AlertControllerHelper()

@end

@implementation AlertControllerHelper

+(void)ShowAlert:(NSString *)title message:(NSString *)message view:(UIViewController*)view {
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"OK action");
                               }];
    
    [alertController addAction:okAction];
    
    [view presentViewController:alertController animated:YES completion:nil];
    [alertController reloadInputViews];
    
}
@end
