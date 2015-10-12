//
//  DBManager.h
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/11/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

// custom init method declaration
-(instancetype)initWithDatabaseFilename:(NSString *)dive_dod;

// properties for db query
@property (nonatomic, strong) NSMutableArray *arrColumnNames;
@property (nonatomic) int affectedRows;
@property (nonatomic) long long lastInsertedRowID;

// public methods for the db selects and querys
// select multiple results first
-(NSArray *)loadDataFromDB:(NSString *)query;

// selects one NSString value
-(NSString *)loadOneDataFromDB:(NSString *)query;

// select one int value
-(NSNumber*)loadNumberFromDB:(NSString *)query;

// insert, update, and delete
-(void)executeQuery:(NSString *)query;

@end
