//
//  CustomCommentCell.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 12/18/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "CustomCommentCell.h"

@implementation CustomCommentCell

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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
