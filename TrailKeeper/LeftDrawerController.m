//
//  LeftDrawerController.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 11/1/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "LeftDrawerController.h"
#import "SettingsHelper.h"

@interface LeftDrawerController ()

@property (nonatomic) int recordIdSetting;
@property (nonatomic, strong) NSArray *settingList;

-(void)loadData;

@end

@implementation LeftDrawerController

@synthesize recordIdSetting;

#pragma mark - setup

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tblSettings.delegate = self;
    self.tblSettings.dataSource = self;
    
    [self loadData];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - tableView

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"Choose Row %@", indexPath);
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = cell.contentView.backgroundColor;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.settingList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //deque the cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idCellRecord" forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.settingList objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - private methods
-(void)loadData {
    if (self.settingList != nil) {
        self.settingList = nil;
    }
    
    self.settingList = [SettingsHelper getSettingsList];
    
    [self.tblSettings reloadData];
}

@end
