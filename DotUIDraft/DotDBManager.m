//
//  DotDBManager.m
//  DotUIDraft
//
//  Created by Titus Cheng on 3/24/15.
//  Copyright (c) 2015 Braison. All rights reserved.
//

#import "DotDBManager.h"

static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

#define DATABASE_NAME @"dot.db"

@implementation DotDBManager
{
    NSString *databasePath;
}

- (instancetype)initWithDatabaseFilename:(NSString *)dbFilename {
    self = [super init];
    if (self) {
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentsDirectory = [path objectAtIndex:0];
        
        self.databaseFilename = dbFilename;
        
        [self copyDatabaseIntoDocumentsDirectory];
    }
    return self;
}

-(BOOL)createDB{
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: DATABASE_NAME]];
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmts[] = {"create table if not exists Alarm (id integer primary key, time text, status integer, occurence text)"};
            for(int i = 0; i < 4; i++) {
                if (sqlite3_exec(database, sql_stmts[i], NULL, NULL, &errMsg) != SQLITE_OK)
                {
                    isSuccess = NO;
                    NSLog(@"Failed to create table");
                }
            }

            sqlite3_close(database);
            return  isSuccess;
        }
        else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    return isSuccess;
}

- (BOOL)createTable:(NSString *)tableName WithParameters:(NSDictionary *)attributes
{
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: DATABASE_NAME]];
    BOOL isSuccess = NO;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        char *errMsg;
        
        NSMutableString *ns_sql_stmt = [[NSMutableString alloc] init];
        [ns_sql_stmt appendFormat:@"create table if not exists %@ (", tableName];
        NSArray *attributeKeys = [attributes allKeys];
        for(int i = 0; i < attributeKeys.count; i++) {
            [ns_sql_stmt appendFormat:@"%@ %@", [attributeKeys objectAtIndex:i], [attributes objectForKey:[attributeKeys objectAtIndex:i]]];
            if(i != attributeKeys.count - 1) {
                [ns_sql_stmt appendString:@", "];
            }
        }
        [ns_sql_stmt appendString:@")"];
        NSLog(@"sql query: %@", ns_sql_stmt);
        const char *sql_stmt = [ns_sql_stmt cStringUsingEncoding:NSASCIIStringEncoding];
        if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
            != SQLITE_OK)
        {
            isSuccess = NO;
            NSLog(@"Failed to create table %@", tableName);
        } else {
            NSLog(@"Successfull created table %@", tableName);
            isSuccess = YES;
        }
        sqlite3_close(database);
        return  isSuccess;
    }
    else {
        isSuccess = NO;
        NSLog(@"Failed to open/create database %@", tableName);
    }
    return isSuccess;
}

- (BOOL)insertInto:(NSString *)tableName Values:(NSDictionary *)dataSet
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSArray *allKeys = [dataSet allKeys];
        NSArray *allValues = (NSArray *)[dataSet allValues];
        
        NSString *insertSQL = [NSString stringWithFormat:@"insert into %@ (%@) values (%@)", tableName, [allKeys componentsJoinedByString:@", "], [allValues componentsJoinedByString:@", "]];
        NSLog(@"sql insert: %@", insertSQL);
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            NSLog(@"Successfull insert into %@", tableName);
            return YES;
        } 
        else {
            sqlite3_reset(statement);
            NSLog(@"Failed to insert into %@ with error: %s", tableName, sqlite3_errmsg(database));
            return NO;
        }
    }
    return NO;
}

- (BOOL)deleteFromTable:(NSString *)tableName WithParameter:(NSDictionary *)target
{
    const char *dbpath = [databasePath UTF8String];
    NSLog(@"%@", target);
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSArray *allKeys = [target allKeys];
        NSArray *allValues = (NSArray *)[target allValues];
        NSMutableString *deleteSQL = [[NSMutableString alloc] init];
        [deleteSQL appendFormat:@"delete from %@ where ", tableName];
        for(int i = 0; i < allKeys.count; i++) {
            NSString *key = [allKeys objectAtIndex:i];
            [deleteSQL appendFormat:@"%@=", key];
            if([[target valueForKey:key] isKindOfClass:[NSNumber class]]) {
                NSNumber *val = [allValues objectAtIndex:i];
                [deleteSQL appendFormat:@"%d", [val intValue]];
            } else if([[target valueForKey:key] isKindOfClass:[NSString class]]) {
                [deleteSQL appendString:[allValues objectAtIndex:i]];
            }
            if(i != allValues.count - 1) {
                [deleteSQL appendString:@" AND "];
            }
        }
        
        NSLog(@"sql delete: %@", deleteSQL);
        const char *insert_stmt = [deleteSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            NSLog(@"Successfull delete record from %@", tableName);
            return YES;
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Failed to delete record from %@ with error: %s", tableName, sqlite3_errmsg(database));
            return NO;
        }
    }
    return NO;

}

- (NSArray *)queryTable:(NSString *)tableName ForAllRecordsBy:(NSArray *)attributeNames
{
    NSMutableArray *resultSet = [[NSMutableArray alloc] init];
    //Prepare sql format
    NSMutableString *ns_sql_stmt = [[NSMutableString alloc] init];
    [ns_sql_stmt appendFormat:@"select "];
    for(int i = 0 ; i < attributeNames.count; i++) {
        [ns_sql_stmt appendString:[attributeNames objectAtIndex:i]];
        if(i != attributeNames.count - 1) {
            [ns_sql_stmt appendString:@", "];
        }
    }
    [ns_sql_stmt appendFormat:@" from %@",tableName];
    
    //query table
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        //     char *errMsg;
        const char *sql_stmt = [ns_sql_stmt cStringUsingEncoding:NSASCIIStringEncoding];
        if (sqlite3_prepare_v2(database,
                               sql_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
                
                for(int i = 0; i < attributeNames.count; i++) {
                    if(sqlite3_column_type(statement, i) == SQLITE_INTEGER) {
                        NSNumber *numVal = [NSNumber numberWithInt:sqlite3_column_int(statement, i)];
                        [result setObject:numVal forKey:[attributeNames objectAtIndex:i]];
                    } else if(sqlite3_column_type(statement, i) == SQLITE_TEXT) {
                        NSString *strVal = [[NSString alloc]initWithUTF8String:
                                            (const char *) sqlite3_column_text(statement, i)];
                        [result setObject:strVal forKey:[attributeNames objectAtIndex:i]];

                    }
                }
                [resultSet addObject:result];
 //               NSLog(@"Found table %@", tableName);
            }
            sqlite3_reset(statement);
        }
    }
    else {
        NSLog(@"Failed to open/create database");
    }
    return resultSet;
    
}

- (BOOL)isTableExist:(NSString *)tableName
{
    const char *dbpath = [databasePath UTF8String];
    BOOL tableExists = NO;
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
   //     char *errMsg;
        NSString *ns_sql_stmt = [NSString stringWithFormat:@"select count(x) from %@", tableName];
        const char *sql_stmt = [ns_sql_stmt cStringUsingEncoding:NSASCIIStringEncoding];
        int count = 0;
        
        if (sqlite3_prepare_v2(database,
                               sql_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
               NSLog(@"Found table %@", tableName);
                tableExists = YES;
                count++;
            }
            else{
                NSLog(@"Not found");
                tableExists = NO;
            }
            sqlite3_reset(statement);
        }
    }
    else {
        NSLog(@"Failed to open/create database");
    }
    return tableExists;
}


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

- (void)runQueryOn:(NSString *)table WithParameter:(NSArray *)parameter ByOrder:(NSInteger)order
{
    
}

-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable{
    // Create a sqlite object.
    sqlite3 *sqlite3Database;
    
    // Set the database file path.
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    
}

@end
