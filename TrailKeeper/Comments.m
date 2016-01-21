//
//  Comments.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/13/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "Comments.h"
#import <Parse/PFObject+Subclass.h>
#import "ConnectionDetector.h"
#import "DBManager.h"
#import "AppDelegate.h"

@interface Comments ()

@property (nonatomic, strong) DBManager *dbManager;

-(void)addOfflineComment:(Comments*)comment;

@end

@implementation Comments

#pragma Properties

@synthesize dbManager;

@dynamic trailObjectId;
@dynamic trailName;
@dynamic userObjectId;
@dynamic userName;
@dynamic comment;
@dynamic workingCreatedDate;

#pragma init methods

-(id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        self.trailObjectId = [aDecoder decodeObjectForKey:@"trailObjectId"];
        self.trailName = [aDecoder decodeObjectForKey:@"trailName"];
        self.userObjectId = [aDecoder decodeObjectForKey:@"userObjectId"];
        self.userName = [aDecoder decodeObjectForKey:@"userName"];
        self.comment = [aDecoder decodeObjectForKey:@"comment"];
        self.workingCreatedDate = [aDecoder decodeObjectForKey:@"workingCreatedDate"];

    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.trailObjectId forKey:@"trailObjectId"];
    [aCoder encodeObject:self.trailName forKey:@"trailName"];
    [aCoder encodeObject:self.userObjectId forKey:@"userObjectId"];
    [aCoder encodeObject:self.userName forKey:@"userName"];
    [aCoder encodeObject:self.comment forKey:@"comment"];
    [aCoder encodeObject:self.workingCreatedDate forKey:@"workingCreatedDate"];
}

+(void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return @"Comments";
}

#pragma public methods

-(NSArray*)GetCommentsByUser:(NSString*)userObjectId {
    PFQuery *query = [PFQuery queryWithClassName:@"Comments"];
    [query whereKey:@"userObjectId" equalTo:userObjectId];
    [query orderByDescending:@"workingCreatedDate"];
    [query fromLocalDatastore];
    NSArray * _Nullable objects = [query findObjects];
    return objects;
}

-(NSMutableArray*)GetCommentsByTrail:(NSString*)trailObjectId {
    PFQuery *query = [PFQuery queryWithClassName:@"Comments"];
    [query whereKey:@"trailObjectId" equalTo:trailObjectId];
    [query orderByDescending:@"workingCreatedDate"];
    [query fromLocalDatastore];
    NSArray * _Nullable objects = [query findObjects];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:objects];
    return array;
}

-(NSArray*)GetAllComments {
    PFQuery *query = [PFQuery queryWithClassName:@"Comments"];
    [query orderByDescending:@"workingCreatedDate"];
    [query fromLocalDatastore];
    NSArray *_Nullable allComments = [query findObjects];
    return allComments;
}

-(void)CreateNewComment:(Comments*)comment {
    if ([ConnectionDetector hasConnectivity]) {
        [self SaveNewComment:comment];
    } else {
        [self addOfflineComment:comment];
    }
}

-(void)SaveNewComment:(Comments*)newComment {
    PFObject *comment = [PFObject objectWithClassName:@"Comments"];
    comment[@"trailObjectId"] = newComment.trailObjectId;
    comment[@"trailName"] = newComment.trailName;
    comment[@"userObjectId"] = newComment.userObjectId;
    comment[@"userName"] = newComment.userName;
    comment[@"comment"] = newComment.comment;
    comment[@"workingCreatedDate"] = newComment.workingCreatedDate;  
    
    [comment pinInBackground];
    [comment saveInBackground];
    
    // TODO add the call to send the notification
}

//TODO use a generic db class?

-(Comments*)GetOfflineComments {
    Comments *allComments = [[Comments alloc] init];
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"offline_trails.db"];
    NSString *query = [NSString stringWithFormat:@"select * from offline_comment LIMIT 1"];
    NSArray *comment = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    if (comment.count > 0) {
        allComments.trailObjectId = [[NSString alloc] initWithString:[[comment objectAtIndex:0] objectAtIndex:1]];
        allComments.trailName = [[NSString alloc] initWithString:[[comment objectAtIndex:0] objectAtIndex:2]];
        allComments.userObjectId = [[NSString alloc] initWithString:[[comment objectAtIndex:0] objectAtIndex:3]];
        allComments.userName = [[NSString alloc] initWithString:[[comment objectAtIndex:0] objectAtIndex:4]];
        allComments.comment = [[NSString alloc] initWithString:[[comment objectAtIndex:0] objectAtIndex:5]];
        allComments.workingCreatedDate = [NSDate date];
    }
    return allComments;
}

-(int)GetDbCommentRowCount {
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"offline_trails.db"];
    NSString *query = [NSString stringWithFormat:@"SELECT Count(*) FROM offline_comment"];
    
     return [[self.dbManager loadNumberFromDB:query] intValue];
}

#pragma private methods

-(void)addOfflineComment:(Comments*)comment {
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"offline_trails.db"];
    NSString *query = [NSString stringWithFormat:@"insert into offline_comment(trail_object_id, trail_name, user_object_id, userName, comment) values('%@','%@','%@','%@','%@')",
                       comment.trailObjectId,
                       comment.trailName,
                       comment.userObjectId,
                       comment.userName,
                       comment.comment];
    
    NSLog(@"Add offline comment Query: %@", query);
    [self.dbManager executeQuery:query];
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"AddOffLineComment query has been successfully inserted. Rows: %d", self.dbManager.affectedRows);
        // set the preferences so we know to look for it later to save
        NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
        [preferences setBool:YES forKey:HasOfflineCommentKey];
    } else {
        NSLog(@"AddOffLineComment query has failed");
    }
    
}

-(void)deleteOneOfflineComment:(NSString*)comment {
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"offline_trails.db"];
    NSString *query = [NSString stringWithFormat:@"delete from offline_comment where comment='%@'", comment];
    NSLog(@"Delete the old Comment Query: %@", query);
    [self.dbManager executeQuery:query];
}

@end
