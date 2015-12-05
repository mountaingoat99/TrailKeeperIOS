//
//  FindTrailSectionInfo.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 12/5/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "FindTrailSectionInfo.h"
#import "FindTrailSectionHeaderView.h"
#import "States.h"

@implementation FindTrailSectionInfo

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _rowHeights = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSUInteger)countOfRowHeights {
    return [self.rowHeights count];
}

- (id)objectInRowHeightsAtIndex:(NSUInteger)idx {
    return self.rowHeights[idx];
}

- (void)insertObject:(id)anObject inRowHeightsAtIndex:(NSUInteger)idx {
    [self.rowHeights insertObject:anObject atIndex:idx];
}

- (void)insertRowHeights:(NSArray *)rowHeightArray atIndexes:(NSIndexSet *)indexes {
    [self.rowHeights insertObjects:rowHeightArray atIndexes:indexes];
}

- (void)removeObjectFromRowHeightsAtIndex:(NSUInteger)idx {
    [self.rowHeights removeObjectAtIndex:idx];
}

- (void)removeRowHeightsAtIndexes:(NSIndexSet *)indexes {
    [self.rowHeights removeObjectsAtIndexes:indexes];
}

- (void)replaceObjectInRowHeightsAtIndex:(NSUInteger)idx withObject:(id)anObject {
    self.rowHeights[idx] = anObject;
}

- (void)replaceRowHeightsAtIndexes:(NSIndexSet *)indexes withRowHeights:(NSArray *)rowHeightArray {
    [self.rowHeights replaceObjectsAtIndexes:indexes withObjects:rowHeightArray];
}

@end
