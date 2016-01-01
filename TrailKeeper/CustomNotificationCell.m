//
//  CustomNotificationCell.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 12/29/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "CustomNotificationCell.h"

@implementation CustomNotificationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //self.contentView.userInteractionEnabled = NO;
    }
    return self;
}

-(void)layoutSubviews {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btn_HomeClick:(id)sender {
    [self.delegate btnClick_Home:self.sentTrailObjectId];  //TODO send the trailObjectId
}

- (IBAction)btn_UnsubscribeClick:(id)sender {
    [self.delegate btnClick_Unsubscribe:self.channelName];
}
@end
