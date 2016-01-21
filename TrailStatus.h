//
//  TrailStatus.h
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/13/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import <Parse/Parse.h>
#import "Trails.h"

@interface TrailStatus : PFObject<PFSubclassing, NSCoding>

+ (NSString *)parseClassName;

@property (nonatomic, strong) NSString *trailName;
@property (nonatomic, strong) NSNumber *updateStatusPin;
@property (nonatomic, strong) NSArray *authorizedUserNames;

-(NSNumber*)GetTrailPin:(NSString*)trailName;
-(void)SaveNewTrailStatus:(Trails*)trailName;
-(void)UpdateTrailStatusUser:(NSString*)trailName;
-(TrailStatus*)GetOffTrailStatus;
-(void)SaveStatus:(TrailStatus*)trailStatus;
-(int)GetDbCommentRowCount;
-(void)deleteOneOfflineTrailStatus:(NSString*)trailName;

@end
