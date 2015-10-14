//
//  Trails.h
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/13/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import <Parse/Parse.h>

@interface Trails : PFObject<PFSubclassing, NSCoding>

+ (NSString *)parseClassName;

//@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *trailName;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSString *mapLink;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) PFGeoPoint * geoLocation;
@property (nonatomic) BOOL privateTrail;
@property (nonatomic) BOOL skillEasy;
@property (nonatomic) BOOL skillMedium;
@property (nonatomic) BOOL skillHard;

@end
