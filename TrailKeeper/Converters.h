//
//  Converters.h
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/23/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Converters : NSObject

+(NSNumber*)ConvertBoolToNSNumber:(BOOL)boolValue;
+(BOOL)getBoolValueFromNSNumber:(NSNumber *)number;

@end
