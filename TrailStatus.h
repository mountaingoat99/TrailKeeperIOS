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
@property (nonatomic, strong) NSString *updateStatusPin;
@property (nonatomic, strong) NSArray *authorizedUserNames;

-(NSString*)GetTrailPin:(NSString*)trailName;
-(void)CreateNewTrailStatus:(Trails*)trailName;
-(void)UpdateTrailStatus:(NSString*)objectId Choice:(NSNumber*)choice TrailName:(NSString*)trailName;
-(void)UpdateTrailStatusUser:(NSString*)trailName;
-(TrailStatus*)GetOffTrailStatus;
-(int)GetDbCommentRowCount;

@end
