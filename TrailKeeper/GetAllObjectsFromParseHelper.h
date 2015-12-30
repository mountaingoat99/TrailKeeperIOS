//
//  GetAllObjectsFromParseHelper.h
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/30/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import <Parse/Parse.h>
#import "Trails.h"
#import "TrailStatus.h"
#import "AuthorizedCommentors.h"
#import "Comments.h"

@interface GetAllObjectsFromParseHelper : PFObject

+(void)UnpinallAllTrailObjects;
+(void)RefreshTrails;
+(void)RefreshTrailStatus;
+(void)RefreshAuthorizedCommentors;
+(void)RefreshComments;

@end
