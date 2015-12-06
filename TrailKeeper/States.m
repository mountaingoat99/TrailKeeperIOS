//
//  States.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 12/5/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "States.h"
#import "Trails.h"
#import "StateListHelper.h"

@interface States ()

@property (nonatomic, weak) NSMutableArray *trailList;

@end

@implementation States

-(NSMutableArray*)getStatesWithTrails {
    NSMutableArray *states = [[NSMutableArray alloc] init];
    
    // get the list of trails
    Trails *trails = [[Trails alloc] init];
    NSMutableArray *trailList = [trails GetAllTrailInfo];
    
    // get the list of states
    NSDictionary *stateNames = [StateListHelper GetStates];
    
    // check each state and add the trails to a seperate state array
    for (id key in stateNames) {
        States *stateObject = [[States alloc] init];
        stateObject.name = [stateNames objectForKey:key];
        NSMutableArray *trailsInState = [[NSMutableArray alloc] init];
        for (Trails *trails in trailList) {
            if ([key isEqualToString:trails.state]) {
                [trailsInState addObject:trails];
            }
        }
        if (trailsInState.count > 0) {
            stateObject.trails = trailsInState;
            [states addObject:stateObject];
        }
    }
    // return the array back to the view controller
    return states;
}

@end
