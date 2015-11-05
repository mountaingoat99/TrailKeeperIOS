    //
//  TrailCell.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 11/1/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "TrailCell.h"

@interface TrailCell ()

-(void)cardSetup;

@end

@implementation TrailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)layoutSubviews {
    //[self cardSetup];
    
//    self.cardView.frame = CGRectOffset(self.cardView.frame, 10, 10);
//    [self.cardView setAlpha:1];
//    self.cardView.layer.masksToBounds = NO;
//    self.cardView.layer.cornerRadius = 1;
//    self.cardView.layer.shadowOffset = CGSizeMake(-.2f, .2f);
//    self.cardView.layer.shadowRadius = 1;
//    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.cardView.bounds];
//    self.cardView.layer.shadowPath = path.CGPath;
//    self.cardView.layer.shadowOpacity = 0;
}

-(void)cardSetup{
    
    [self.cardView setAlpha:1];
    self.cardView.layer.masksToBounds = NO;
    self.cardView.layer.cornerRadius = 1;
    self.cardView.layer.shadowOffset = CGSizeMake(-.2f, .2f);
    self.cardView.layer.shadowRadius = 1;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.cardView.bounds];
    self.cardView.layer.shadowPath = path.CGPath;
    self.cardView.layer.shadowOpacity = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
