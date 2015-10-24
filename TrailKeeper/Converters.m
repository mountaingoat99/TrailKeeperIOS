//
//  Converters.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/23/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "Converters.h"

@implementation Converters

+(NSNumber*)ConvertBoolToNSNumber:(BOOL)boolValue {
    return [NSNumber  numberWithBool:boolValue];
}

+(BOOL)getBoolValueFromNSNumber:(NSNumber *)number {
    return [number boolValue];
}

@end
