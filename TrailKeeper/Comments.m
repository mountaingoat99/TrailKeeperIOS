//
//  Comments.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/13/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "Comments.h"
#import <Parse/PFObject+Subclass.h>

@interface Comments ()

-(void)addOfflineComment:(Comments*)comment;
-(void)deleteOneOfflineComment:(int)tableId;

@end

@implementation Comments

#pragma Properties

@dynamic trailObjectId;
@dynamic trailName;
@dynamic userObjectId;
@dynamic userName;
@dynamic comment;

#pragma init methods

+(void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return @"Comments";
}

#pragma public methods

-(NSArray*)GetCommentsByUser:(NSString*)userObjectId {
    NSArray *userComments;
    
    
    return userComments;
}

-(NSArray*)GetCommentsByTrail:(NSString*)trailObjectId {
    NSArray *trailComments;
    
    
    return trailComments;
}

-(NSArray*)GetAllComments {
    NSArray *allComments;
    
    
    return allComments;
}

-(void)CreateNewComment:(Comments*)comment {
    
}

//TODO use a generic db class?

-(Comments*)GetOfflineComments {
    Comments *allComments;
    
    
    return allComments;
}

-(int)GetDbCommentRowCount {
    int rows = 0;
    
    
    return rows;
}


#pragma private methods

-(void)addOfflineComment:(Comments*)comment {
    
}

-(void)deleteOneOfflineComment:(int)tableId {
    
}

@end
