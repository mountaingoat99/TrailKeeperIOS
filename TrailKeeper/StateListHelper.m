//
//  StateListHelper.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/11/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "StateListHelper.h"

@implementation StateListHelper

+(NSDictionary*)GetStates {
    
    NSDictionary *states = @{@"AL":@"Alabama",
                             @"AK":@"Alaska",
                             @"AZ":@"Arizona",
                             @"AR":@"Arkansas",
                             @"CA":@"California",
                             @"CO":@"Colorado",
                             @"CT":@"Connecticut",
                             @"DE":@"Delaware",
                             @"FL":@"Florida",
                             @"GA":@"Georgia",
                             @"HI":@"Hawaii",
                             @"ID":@"Idaho",
                             @"IL":@"Illinois",
                             @"IN":@"Indiana",
                             @"IA":@"Iowa",
                             @"KS":@"Kansas",
                             @"KY":@"Kentucky",
                             @"LA":@"Louisiana",
                             @"ME":@"Maine",
                             @"MD":@"Maryland",
                             @"MA":@"Massachusetts",
                             @"MI":@"Michigan",
                             @"MN":@"Minnesota",
                             @"MS":@"Mississippi",
                             @"MO":@"Missouri",
                             @"MT":@"Montana",
                             @"NE":@"Nebraska",
                             @"NV":@"Nevada",
                             @"NH":@"New Hampshire",
                             @"NJ":@"New Jersey",
                             @"NM":@"New Mexico",
                             @"NY":@"New York",
                             @"NC":@"North Carolina",
                             @"ND":@"North Dakota",
                             @"OH":@"Ohio",
                             @"OK":@"Oklahoma",
                             @"OR":@"Oregon",
                             @"PA":@"Pennsylvania",
                             @"RI":@"Rhode Island",
                             @"SC":@"South Carolina",
                             @"SD":@"South Dakota",
                             @"TN":@"Tennessee",
                             @"TX":@"Texas",
                             @"UT":@"Utah",
                             @"VT":@"Vermont",
                             @"VA":@"Virginia",
                             @"WA":@"Washington",
                             @"WV":@"West Virginia",
                             @"WI":@"Wisconsin",
                             @"WY":@"Wyoming"};
    return states;
}

+(NSMutableArray*)GetAllStateName {
    NSMutableArray *states = [[NSMutableArray alloc] init];
    
    for (NSString *name in [[self GetStates]allValues]) {
        [states addObject:name];
    }
    
    return states;
}

+(NSString*)GetStateName:(NSString*)abbreviation {
    NSString *correctStateName = @"Unknown";
    
    for (NSString *name in [[self GetStates]allKeys]) {
        if ([name isEqualToString:abbreviation]) {
            correctStateName = [[self GetStates] objectForKey:name];
            break;
        }
    }
    
    return correctStateName;
}

+(NSMutableArray*)GetCountries {
    NSLocale *locale = [NSLocale currentLocale];
    NSArray *countryArray = [NSLocale ISOCountryCodes];
    NSMutableArray *sortedCountryArray = [[NSMutableArray alloc] init];
    
    for (NSString *countryCode in countryArray) {
        NSString *displayNameString = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
        [sortedCountryArray addObject:displayNameString];
    }
    
    [sortedCountryArray sortUsingSelector:@selector(localizedCompare:)];
    
    return sortedCountryArray;
}

@end
