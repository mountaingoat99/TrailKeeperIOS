//
//  CustomFindTrailCell.h
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 12/4/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Trails;

@interface CustomFindTrailCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *trailName;
@property (nonatomic, weak) IBOutlet UILabel *trailCity;
@property (nonatomic, weak) IBOutlet UILabel *distance;
@property (nonatomic, weak) IBOutlet UIImageView *statusImage;

@property (nonatomic) Trails *trails;

@end
