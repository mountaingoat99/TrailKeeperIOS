//
//  States.h
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 12/5/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface States : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *trails;

-(NSArray*)getStatesWithTrails;

@end
