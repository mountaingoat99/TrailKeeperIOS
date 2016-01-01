//
//  CustomNotificationCell.h
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 12/29/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomNotificationDelegate <NSObject>

-(void)btnClick_Home:(NSString*)trailobjectId;  //TODO send the trailObjectId
-(void)btnClick_Unsubscribe:(NSString*)trailChannel;

@end

@interface CustomNotificationCell : UITableViewCell

@property (nonatomic, assign) id <CustomNotificationDelegate> delegate;

@property (nonatomic, strong) NSString *sentTrailObjectId;
@property (nonatomic, strong) NSString *channelName;
@property (weak, nonatomic) IBOutlet UIButton *btnHome;
@property (weak, nonatomic) IBOutlet UIButton *btnUnsubscribe;
@property (weak, nonatomic) IBOutlet UILabel *lblTrailName;

- (IBAction)btn_HomeClick:(id)sender;
- (IBAction)btn_UnsubscribeClick:(id)sender;

@end
