//
//  CustomCell.h
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 11/7/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomCellDelegate <NSObject>

-(void)btnClick_Map:(NSString*)trailObjectId;
-(void)btnClick_TrailHome:(NSString*)trailObjectId;

@end

@interface CustomCell : UITableViewCell

@property (nonatomic, assign) id <CustomCellDelegate> delegate;

@property (nonatomic, strong) NSString *sentTrailObjectId;

@property (weak, nonatomic) IBOutlet UILabel *lblTrailName;
@property (weak, nonatomic) IBOutlet UILabel *lblTrailMileageFrom;
@property (weak, nonatomic) IBOutlet UIImageView *imageTrailStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblTrailCityState;
@property (weak, nonatomic) IBOutlet UIButton *btnTrailHome;
@property (weak, nonatomic) IBOutlet UIButton *btnTrailMap;
@property (weak, nonatomic) IBOutlet UIView *cardView;

- (IBAction)btnTrailHome_Click:(id)sender;
- (IBAction)btnMap_Click:(id)sender;

@end
