    //
//  TrailCell.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 11/1/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "TrailCell.h"
#import "AppDelegate.h"

@interface TrailCell ()

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

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)btnTrailHome_Click:(id)sender {
}

- (IBAction)btnMap_Click:(id)sender {
    // get the storyboard
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    id mainView = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MapViewController"];
    UINavigationController *centerNav = [[UINavigationController alloc] initWithRootViewController:mainView];
    appDelegate.drawerController.centerViewController = centerNav;
    //[appDelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    
}
@end
