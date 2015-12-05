//
//  FindTrailHighlightTextView.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 12/4/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "FindTrailHighlightTextView.h"

@implementation FindTrailHighlightTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setHighlighted:(BOOL)highlight {
    
    // adjust the text color based on highlighted state
    if (highlight != _highlighted) {
        self.textColor = highlight ? [UIColor whiteColor] : [UIColor blackColor];
        _highlighted = highlight;
    }
}

@end
