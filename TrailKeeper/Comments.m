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

-(id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        self.trailObjectId = [aDecoder decodeObjectForKey:@"trailObjectId"];
        self.trailName = [aDecoder decodeObjectForKey:@"trailName"];
        self.userObjectId = [aDecoder decodeObjectForKey:@"userObjectId"];
        self.userName = [aDecoder decodeObjectForKey:@"userName"];
        self.comment = [aDecoder decodeObjectForKey:@"comment"];

    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.trailObjectId forKey:@"trailObjectId"];
    [aCoder encodeObject:self.trailName forKey:@"trailName"];
    [aCoder encodeObject:self.userObjectId forKey:@"userObjectId"];
    [aCoder encodeObject:self.userName forKey:@"userName"];
    [aCoder encodeObject:self.comment forKey:@"comment"];
}

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
