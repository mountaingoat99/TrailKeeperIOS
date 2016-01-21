//
//  StateListHelper.h
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/11/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StateListHelper : NSObject

@property (nonatomic, strong) NSDictionary *stateList;

+(NSDictionary*)GetStates;
+(NSString*)GetStateName:(NSString*)abbreviation;
+(NSString*)GetStateAbbreviation:(NSString*)state;
+(NSMutableArray*)GetAllStateName;
+(NSMutableArray*)GetCountries;

@end
