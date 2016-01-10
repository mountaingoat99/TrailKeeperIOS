//
//  AuthorizedCommentors.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/13/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "AuthorizedCommentors.h"
#import <Parse/PFObject+Subclass.h>
#import "Converters.h"

@implementation AuthorizedCommentors

#pragma properties

@dynamic userObjectId;
@dynamic userName;
@dynamic canComment;

#pragma init methods

-(id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        self.userObjectId = [aDecoder decodeObjectForKey:@"userObjectId"];
        self.userName = [aDecoder decodeObjectForKey:@"userName"];
        self.canComment = [aDecoder decodeBoolForKey:@"canComment"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.userObjectId forKey:@"userObjectId"];
    [aCoder encodeObject:self.userName forKey:@"userName"];
    [aCoder encodeBool:self.canComment forKey:@"canComment"];
}


+(void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return @"AuthorizedCommentors";
}

#pragma public methods

-(void)AddAuthorizedCommentor:(AuthorizedCommentors*)commentor {
    PFObject *authorizedCommentors = [PFObject objectWithClassName:@"AuthorizedCommentors"];
    authorizedCommentors[@"userObjectId"] = commentor.userObjectId;
    authorizedCommentors[@"userName"] = commentor.userName;
    authorizedCommentors[@"canComment"] = [Converters ConvertBoolToNSNumber:commentor.canComment];
    
    [authorizedCommentors pinInBackground];
    [authorizedCommentors saveInBackground];
    
}

-(void)UpdateAuthorizedCommentorsUserName:(NSString*)objectId Username:(NSString*)username {
    PFQuery *query = [PFQuery queryWithClassName:@"AuthorizedCommentors"];
    
    [query whereKey:@"userObjectId" equalTo:objectId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        object[@"userName"] = username;
        [object pinInBackground];
        [object saveInBackground];
    }];
}

-(void)DeleteAuthorizedCommentor:(NSString*)userName {
    PFQuery *query = [PFQuery queryWithClassName:@"AuthorizedCommentors"];
    [query whereKey:@"userName" equalTo:userName];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (object) {
            [object deleteInBackground];
        } else {
            NSLog(@"Unable to retrieve object with title %@.", userName);
        }
    }];
}


-(NSArray*)GetUserNames {
    NSMutableArray *userNames = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"AuthorizedCommentors"];
    [query fromLocalDatastore];
    NSArray * _Nullable objects = [query findObjects];
    NSLog(@"Successfully Retrieved UserNames");
    for (PFObject *object in objects) {
        
        [userNames addObject:[object objectForKey:@"userName"]];
    }
    return userNames;
}

-(NSString*)GetUserObjectIdByName:(NSString*)userName {
    PFQuery *query = [PFQuery queryWithClassName:@"AuthorizedCommentors"];
    [query fromLocalDatastore];
    [query whereKey:@"userName" matchesRegex:userName modifiers:@"i"];
    //[query whereKey:@"userName" equalTo:userName];
    PFObject * _Nullable userObject = [query getFirstObject];
    return [userObject objectForKey:@"userObjectId"];
}

@end
