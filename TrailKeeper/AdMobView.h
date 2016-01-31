//
//  AdMobView.h
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 1/30/16.
//  Copyright © 2016 Jeremey Rodriguez. All rights reserved.
//

@import GoogleMobileAds;

#import <UIKit/UIKit.h>

@interface AdMobView : UIView <GADBannerViewDelegate>

+(void)GetAdMobView:(UIViewController*)uiView;

@end
