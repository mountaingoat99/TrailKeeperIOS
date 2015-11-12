//
//  CustomCell.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 11/7/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "CustomCell.h"
#import "AppDelegate.h"

@implementation CustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)layoutSubviews {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)btnTrailHome_Click:(id)sender {
    [self.delegate btnClick_TrailHome:self.sentTrailObjectId];
}

- (IBAction)btnMap_Click:(id)sender {
    [self.delegate btnClick_Map:self.sentTrailObjectId];
}

@end
