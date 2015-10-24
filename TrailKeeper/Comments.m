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

@interface Comments ()

@property (nonatomic, strong) DBManager *dbManager;

-(void)addOfflineComment:(Comments*)comment;
-(void)deleteOneOfflineComment:(int)tableId;

@end

@implementation Comments

#pragma Properties

@synthesize dbManager;

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

-(NSMutableArray*)GetCommentsByUser:(NSString*)userObjectId {
    NSMutableArray *userComments = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"Comment"];
    [query whereKey:@"userObjectId" equalTo:userObjectId];
    [query fromLocalDatastore];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            for (PFObject *object in objects) {
                Comments *comment = [[Comments alloc] init];
                comment.objectId = object.objectId;
                comment.trailObjectId = [object objectForKey:@"trailObjectId"];
                comment.trailName = [object objectForKey:@"trailName"];
                comment.userObjectId = [object objectForKey:@"userObjectId"];
                comment.userName = [object objectForKey:@"userName"];
                comment.comment = [object objectForKey:@"comment"];
                
                [userComments addObject:comment];
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    return userComments;
}

-(NSMutableArray*)GetCommentsByTrail:(NSString*)trailObjectId {
    NSMutableArray *trailComments = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"Comment"];
    [query whereKey:@"trailObjecId" equalTo:trailObjectId];
    [query fromLocalDatastore];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            for (PFObject *object in objects) {
                Comments *comment = [[Comments alloc] init];
                comment.objectId = object.objectId;
                comment.trailObjectId = [object objectForKey:@"trailObjectId"];
                comment.trailName = [object objectForKey:@"trailName"];
                comment.userObjectId = [object objectForKey:@"userObjectId"];
                comment.userName = [object objectForKey:@"userName"];
                comment.comment = [object objectForKey:@"comment"];
                
                [trailComments addObject:comment];
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    return trailComments;
}

-(NSMutableArray*)GetAllComments {
    NSMutableArray *allComments = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"Comment"];
    [query orderByDescending:@"createdAt"];
    [query fromLocalDatastore];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            for (PFObject *object in objects) {
                Comments *comment = [[Comments alloc] init];
                comment.objectId = object.objectId;
                comment.trailObjectId = [object objectForKey:@"trailObjectId"];
                comment.trailName = [object objectForKey:@"trailName"];
                comment.userObjectId = [object objectForKey:@"userObjectId"];
                comment.userName = [object objectForKey:@"userName"];
                comment.comment = [object objectForKey:@"comment"];
                
                [allComments addObject:comment];
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
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
    PFObject *comment = [PFObject objectWithClassName:@"Comment"];
    comment[@"trailObjecId"] = newComment.trailObjectId;
    comment[@"trailName"] = newComment.trailName;
    comment[@"userObjectId"] = newComment.userObjectId;
    comment[@"userName"] = newComment.userName;
    comment[@"comment"] = newComment.comment;
    
    [comment pinInBackground];
    [comment saveEventually];
    
    // TODO add the call to send the notification
}

//TODO use a generic db class?

-(Comments*)GetOfflineComments {
    Comments *allComments = [[Comments alloc] init];
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"offline_trails.db"];
    NSString *query = [NSString stringWithFormat:@"select * from offline_comment LIMIT 1"];
    NSArray *comment = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    if (comment.count > 0) {
        allComments.trailObjectId = [[NSString alloc] initWithString:[[comment objectAtIndex:0] objectAtIndex:0]];
        allComments.trailName = [[NSString alloc] initWithString:[[comment objectAtIndex:0] objectAtIndex:1]];
        allComments.userObjectId = [[NSString alloc] initWithString:[[comment objectAtIndex:0] objectAtIndex:2]];
        allComments.userName = [[NSString alloc] initWithString:[[comment objectAtIndex:0] objectAtIndex:3]];
        allComments.comment = [[NSString alloc] initWithString:[[comment objectAtIndex:0] objectAtIndex:4]];
    }
    return allComments;
}

-(NSNumber*)GetDbCommentRowCount {
    NSNumber *num;
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"offline_trails.db"];
    NSString *query = [NSString stringWithFormat:@"SELECT Count(*) FROM offline_comment"];
    
    return num = [self.dbManager loadNumberFromDB:query];
}

#pragma private methods

-(void)addOfflineComment:(Comments*)comment {
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"offline_trails.db"];
    NSString *query = [NSString stringWithFormat:@"insert into offline_comment(trailObjectId, trailName, userObjectId, userName, comment) values('%@','%@','%@','%@','%@')",
                       comment.trailObjectId,
                       comment.trailName,
                       comment.userObjectId,
                       comment.userName,
                       comment.comment];
    
    [self.dbManager executeQuery:query];
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"AddOffLineComment query has been successfully inserted. Rows: %d", self.dbManager.affectedRows);
    } else {
        NSLog(@"AddOffLineComment query has failed");
    }
    
}

-(void)deleteOneOfflineComment:(int)tableId {
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"offline_trails.db"];
    NSString *query = [NSString stringWithFormat:@"delete from offline_comment where id=%d", tableId];
    [self.dbManager executeQuery:query];
}

@end
