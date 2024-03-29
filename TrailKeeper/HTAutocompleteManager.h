//
//  HTAutocompleteManager.h
//  HotelTonight
//
//  Created by Jonathan Sibley on 12/6/12.
//  Copyright (c) 2012 Hotel Tonight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTAutocompleteTextField.h"

typedef enum {
    HTAutoCompleteTrailNames,
    HTAutoCompleteUserNames,
    HTAutoCompleteStates,
    HTAutoCompleteCountries
//    HTAutocompleteTypeEmail, // Default
//    HTAutocompleteTypeColor,
//    HTAutoCompleteTypeNumbers,
//    HTAutocompletePlatform,
//    HTAutocompleteSpringboard,
//    HTAutocompletePositions
} HTAutocompleteType;

@interface HTAutocompleteManager : NSObject <HTAutocompleteDataSource>

+ (HTAutocompleteManager *)sharedManager;

@end
