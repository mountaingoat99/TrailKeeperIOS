//
//  HTAutocompleteManager.m
//  HotelTonight
//
//  Created by Jonathan Sibley on 12/6/12.
//  Copyright (c) 2012 Hotel Tonight. All rights reserved.
//

#import "HTAutocompleteManager.h"
#import "Trails.h"
#import "AuthorizedCommentors.h"
#import "StateListHelper.h"

static HTAutocompleteManager *sharedManager;

@implementation HTAutocompleteManager

+ (HTAutocompleteManager *)sharedManager
{
	static dispatch_once_t done;
	dispatch_once(&done, ^{ sharedManager = [[HTAutocompleteManager alloc] init]; });
	return sharedManager;
}

#pragma mark - HTAutocompleteTextFieldDelegate

- (NSString *)textField:(HTAutocompleteTextField *)textField
    completionForPrefix:(NSString *)prefix
             ignoreCase:(BOOL)ignoreCase {
    
    if (textField.autocompleteType == HTAutoCompleteTrailNames) {
        
        static dispatch_once_t numberOnceToken;
        static NSArray *trailName;
        
        Trails *trails = [[Trails alloc] init];
        
        dispatch_once(&numberOnceToken, ^ {
                          trailName = [trails GetTrailNames];
                      });
        
        NSString *stringToLookFor;
        NSArray *componentsString = [prefix componentsSeparatedByString:@","];
        NSString *prefixLastComponent = [componentsString.lastObject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (ignoreCase) {
            stringToLookFor = [prefixLastComponent lowercaseString];
        } else {
            stringToLookFor = prefixLastComponent;
        }
        
        for (int i = 0; i < trailName.count; i++) {
            NSString *stringFromReference = [trailName objectAtIndex:i];
        
            NSString *stringToCompare;
            if (ignoreCase) {
                stringToCompare = [stringFromReference lowercaseString];
            } else {
                stringToCompare = stringFromReference;
            }
            
            if ([stringToCompare hasPrefix:stringToLookFor]) {
                return [stringFromReference stringByReplacingCharactersInRange:[stringToCompare rangeOfString:stringToLookFor] withString:@""];
            }
        }
    } else if (textField.autocompleteType == HTAutoCompleteUserNames) {
        
        static dispatch_once_t numberOnceToken;
        static NSArray *userName;
        
         AuthorizedCommentors *users = [[AuthorizedCommentors alloc] init];
        
        dispatch_once(&numberOnceToken, ^ {
            userName = [users GetUserNames];
        });
        
        NSString *stringToLookFor;
        NSArray *componentsString = [prefix componentsSeparatedByString:@","];
        NSString *prefixLastComponent = [componentsString.lastObject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (ignoreCase) {
            stringToLookFor = [prefixLastComponent lowercaseString];
        } else {
            stringToLookFor = prefixLastComponent;
        }
        
        for (int i = 0; i < userName.count; i++) {
            NSString *stringFromReference = [userName objectAtIndex:i];
            
            NSString *stringToCompare;
            if (ignoreCase) {
                stringToCompare = [stringFromReference lowercaseString];
            } else {
                stringToCompare = stringFromReference;
            }
            
            if ([stringToCompare hasPrefix:stringToLookFor]) {
                return [stringFromReference stringByReplacingCharactersInRange:[stringToCompare rangeOfString:stringToLookFor] withString:@""];
            }
        }
    } else if (textField.autocompleteType == HTAutoCompleteStates) {
        static dispatch_once_t numberOnceToken;
        static NSArray *states;
        
        dispatch_once(&numberOnceToken, ^ {
            states = [StateListHelper GetAllStateName];
        });
        
        NSString *stringToLookFor;
        NSArray *componentsString = [prefix componentsSeparatedByString:@","];
        NSString *prefixLastComponent = [componentsString.lastObject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (ignoreCase) {
            stringToLookFor = [prefixLastComponent lowercaseString];
        } else {
            stringToLookFor = prefixLastComponent;
        }
        
        for (int i = 0; i < states.count; i++) {
            NSString *stringFromReference = [states objectAtIndex:i];
            
            NSString *stringToCompare;
            if (ignoreCase) {
                stringToCompare = [stringFromReference lowercaseString];
            } else {
                stringToCompare = stringFromReference;
            }
            
            if ([stringToCompare hasPrefix:stringToLookFor]) {
                return [stringFromReference stringByReplacingCharactersInRange:[stringToCompare rangeOfString:stringToLookFor] withString:@""];
            }
        }
    } else if (textField.autocompleteType == HTAutoCompleteCountries) {
        static dispatch_once_t numberOnceToken;
        static NSArray *countries;
        
        
        
        dispatch_once(&numberOnceToken, ^ {
            countries = [StateListHelper GetCountries];
        });
        
        NSString *stringToLookFor;
        NSArray *componentsString = [prefix componentsSeparatedByString:@","];
        NSString *prefixLastComponent = [componentsString.lastObject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (ignoreCase) {
            stringToLookFor = [prefixLastComponent lowercaseString];
        } else {
            stringToLookFor = prefixLastComponent;
        }
        
        for (int i = 0; i < countries.count; i++) {
            NSString *stringFromReference = [countries objectAtIndex:i];
            
            NSString *stringToCompare;
            if (ignoreCase) {
                stringToCompare = [stringFromReference lowercaseString];
            } else {
                stringToCompare = stringFromReference;
            }
            
            if ([stringToCompare hasPrefix:stringToLookFor]) {
                return [stringFromReference stringByReplacingCharactersInRange:[stringToCompare rangeOfString:stringToLookFor] withString:@""];
            }
        }
    }
    return @"";
}

@end
