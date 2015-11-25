//
//  CustomTrailHomeCell.h
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 11/20/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTrailHomeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblComment;
@property (weak, nonatomic) IBOutlet UILabel *lblCommentDate;
@property (weak, nonatomic) IBOutlet UILabel *lblCommentUsername;

@end
