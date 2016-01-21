//
//  DBManager.m
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/11/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import "DBManager.h"
#import <sqlite3.h>

@interface DBManager ()

@property (nonatomic, strong) NSString *documentsDirectory;
@property (nonatomic, strong) NSString *databaseFilename;

// declared here since it is just a private class mathod
-(void)copyDatabaseIntoDocumentsDirectory;

//test properties and methods to make sure database attaches
@property (nonatomic, strong) NSMutableArray *arrResults;
@property (nonatomic, strong) NSString *oneStringResult;
@property (nonatomic) NSNumber *oneNumberResult;

// this is a very generic method that other public methods suited to needs will call - multiple items returned
-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable;

// generic method to call when you only need one result returned
-(void)runSingleQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable;

@end

@implementation DBManager

#pragma initdatabase and directory methods

// custom init method for database
-(instancetype)initWithDatabaseFilename:(NSString *)offline_trails{
    self = [super init];
    if (self) {
        // Set the documents directory path to the documentsDirectory property.
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentsDirectory = [paths objectAtIndex:0];
        NSLog(@"Database Location:%@", self.documentsDirectory);
        
        // Keep the database filename.
        self.databaseFilename = offline_trails;
        
        // Copy the database file into the documents directory if necessary.
        [self copyDatabaseIntoDocumentsDirectory];
    }
    return self;
}

// called everytime an object of the class is initilized, if the database file is not found
// then the block will run, other wise it will be skipped. Should run only once when the app is run the
// first time
-(void)copyDatabaseIntoDocumentsDirectory{
    // Check if the database file exists in the documents directory.
    NSString *destinationPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
        // The database file does not exist in the documents directory, so copy it from the main bundle now.
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseFilename];
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error];
        
        // Check if any error occurred during copying and display it.
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
}

#pragma query methods

// dbquery method, selects multiple items and runs executable SQL statements
-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable{
    // Create a sqlite object.
    sqlite3 *sqlite3Database;
    
    // Set the database file path.
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    
    // Initialize the results array.
    if (self.arrResults != nil) {
        [self.arrResults removeAllObjects];
        self.arrResults = nil;
    }
    self.arrResults = [[NSMutableArray alloc] init];
    
    // Initialize the column names array.
    if (self.arrColumnNames != nil) {
        [self.arrColumnNames removeAllObjects];
        self.arrColumnNames = nil;
    }
    self.arrColumnNames = [[NSMutableArray alloc] init];
    
    
    // Open the database.
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
    if(openDatabaseResult == SQLITE_OK) {
        // Declare a sqlite3_stmt object in which will be stored the query after having been compiled into a SQLite statement.
        sqlite3_stmt *compiledStatement;
        
        // Load all data from database to memory.
        BOOL prepareStatementResult = sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledStatement, NULL);
        if(prepareStatementResult == SQLITE_OK) {
            // Check if the query is non-executable.
            if (!queryExecutable){
                // In this case data must be loaded from the database.
                
                // Declare an array to keep the data for each fetched row.
                NSMutableArray *arrDataRow;
                
                // Loop through the results and add them to the results array row by row.
                while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                    // Initialize the mutable array that will contain the data of a fetched row.
                    arrDataRow = [[NSMutableArray alloc] init];
                    
                    // Get the total number of columns.
                    int totalColumns = sqlite3_column_count(compiledStatement);
                    
                    // Go through all columns and fetch each column data.
                    for (int i=0; i<totalColumns; i++){
                        // Convert the column data to text (characters).
                        char *dbDataAsChars = (char *)sqlite3_column_text(compiledStatement, i);
                        
                        // If there are contents in the currenct column (field) then add them to the current row array.
                        if (dbDataAsChars != NULL) {
                            // Convert the characters to string.
                            [arrDataRow addObject:[NSString  stringWithUTF8String:dbDataAsChars]];
                        }
                        
                        // Keep the current column name.
                        if (self.arrColumnNames.count != totalColumns) {
                            dbDataAsChars = (char *)sqlite3_column_name(compiledStatement, i);
                            [self.arrColumnNames addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                        }
                    }
                    
                    // Store each fetched data row in the results array, but first check if there is actually data.
                    if (arrDataRow.count > 0) {
                        [self.arrResults addObject:arrDataRow];
                    }
                }
            }
            else {
                // This is the case of an executable query (insert, update, ...).
                
                // Execute the query.
                NSInteger executeQueryResults = sqlite3_step(compiledStatement);
                if (executeQueryResults == SQLITE_DONE) {
                    // Keep the affected rows.
                    self.affectedRows = sqlite3_changes(sqlite3Database);
                    
                    // Keep the last inserted row ID.
                    self.lastInsertedRowID = sqlite3_last_insert_rowid(sqlite3Database);
                    NSLog(@"LastInsertRecord: %lld", self.lastInsertedRowID);
                }
                else {
                    // If could not execute the query show the error message on the debugger.
                    NSLog(@"DB Error: %s", sqlite3_errmsg(sqlite3Database));
                }
            }
        } else {
            // If the statement could not be prepared then show the error message on the debugger.
            NSLog(@"%s", sqlite3_errmsg(sqlite3Database));
        }
        
        // Release the compiled statement from memory.
        sqlite3_finalize(compiledStatement);
        
    } else {
        // If the database cannot be opened then show the error message on the debugger.
        NSLog(@"%s", sqlite3_errmsg(sqlite3Database));
    }
    
    // Close the database.
    sqlite3_close(sqlite3Database);
}

// does a single select
-(void)runSingleQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable {
    // Create a sqlite object.
    sqlite3 *sqlite3Database;
    
    // Set the database file path.
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    
    // Open the database.
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
    if(openDatabaseResult == SQLITE_OK) {
        // Declare a sqlite3_stmt object in which will be stored the query after having been compiled into a SQLite statement.
        sqlite3_stmt *compiledStatement;
        
        // Load all data from database to memory.
        BOOL prepareStatementResult = sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledStatement, NULL);
        if(prepareStatementResult == SQLITE_OK) {
            
            // if there is a result
            if(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
                self.oneStringResult = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(compiledStatement, 0)];
                NSLog(@"Select result was %@", self.oneStringResult);
                
            } else {
                // If the database cannot be opened then show the error message on the debugger.
                NSLog(@"%s", sqlite3_errmsg(sqlite3Database));
                NSLog(@"No results found");
            }
        } else {
            // If could not execute the query show the error message on the debugger.
            NSLog(@"DB Error: %s", sqlite3_errmsg(sqlite3Database));
            NSLog(@"Statement did not get prepared correctly");
        }
        
        // Release the compiled statement from memory.
        sqlite3_finalize(compiledStatement);
        
    } else {
        // If the database cannot be opened then show the error message on the debugger.
        NSLog(@"%s", sqlite3_errmsg(sqlite3Database));
        NSLog(@"Database did not get opened correctly");
    }
}

#pragma Public Query methods

// this will fetch multiple results from the database  - public method
-(NSArray *)loadDataFromDB:(NSString *)query {
    
    // the query string is converted to a char* object
    [self runQuery:[query UTF8String] isQueryExecutable:NO];
    
    // return the loaded results from the two dimensional array
    return (NSArray *)self.arrResults;
}

// this will fetch one NSString result from the database - public method
-(NSString *)loadOneDataFromDB:(NSString *)query {
    
    [self runSingleQuery:[query UTF8String] isQueryExecutable:NO];
    
    return self.oneStringResult;
}

//this will fetch one int result from the database - public method
-(NSNumber*)loadNumberFromDB:(NSString *)query{
    
    [self runSingleQuery:[query UTF8String] isQueryExecutable:NO];
    
    return self.oneNumberResult = [NSNumber numberWithInteger:[self.oneStringResult integerValue]];
}

// this is the public execute query method
-(void)executeQuery:(NSString *)query{
    
    //run the query and indicate that is executable
    [self runQuery:[query UTF8String] isQueryExecutable:YES];
}


@end
