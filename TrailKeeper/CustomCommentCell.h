//
//  CustomCommentCell.h
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 12/18/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblTrailName;
@property (weak, nonatomic) IBOutlet UILabel *lblComment;
@property (weak, nonatomic) IBOutlet UILabel *lblCommentUser;
@property (weak, nonatomic) IBOutlet UILabel *lblCommentDate;

@end
