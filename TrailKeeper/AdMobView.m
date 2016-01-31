//
//  AdMobView.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 1/30/16.
//  Copyright © 2016 Jeremey Rodriguez. All rights reserved.
//

@import GoogleMobileAds;

#import "AdMobView.h"

@interface AdMobView ()

@end

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

@implementation AdMobView

+(void)GetAdMobView:(UIViewController*)uiView {
    
    GADBannerView *adView;
    
    // Create adMob ad View (note the use of various macros to detect device)
    if (IS_IPAD) {
        adView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeFullBanner];
    }
    else if (IS_IPHONE_6) {
        adView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    }
    else if (IS_IPHONE_6P) {
        adView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    }
    else {
        // boring old iPhones and iPod touches
        adView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    }
    
    adView.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin);
    
    // get ad sizes
    CGSize adSize = adView.frame.size;
    float adHeight = adSize.height;
    float adWidth = adSize.width;
    // get screen sizes
    float height = uiView.view.frame.size.height;
    float width = uiView.view.frame.size.width;
    // subtract the add width, by the view width and divide by two to get the x coordiante
    float xPlacement = (width - adWidth) / 2;
    
    // ad the ad as a subview
    [uiView.view addSubview:adView];
    // set the placement
    adView.frame = CGRectMake(xPlacement, height - adHeight, adWidth, adHeight);
    // logging
    NSLog(@"Google Mobile Ads SDK version: %@", [GADRequest sdkVersion]);
    // test ad id
    //adView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
    // production ad id
    adView.adUnitID = @"ca-app-pub-9150360740164586/1259440557";
    adView.rootViewController = uiView;
    // set the delegate
    adView.delegate=(id<GADBannerViewDelegate>)self;
    // make the ad request
    GADRequest *request = [GADRequest request];
    [adView loadRequest:request];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
