//
//  DotDBManager.h
//  DotUIDraft
//
//  Created by Titus Cheng on 3/24/15.
//  Copyright (c) 2015 Braison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define ALARM_STORAGE @"Alarm"

#define ASCENDING_ORDER 0
#define DESCENDING_ORDER 1
#define NORMAL_ORDER 2

#define DB_DATATYPE_NULL @"NULL"    //NULL value
#define DB_DATATYPE_INTEGER @"INTEGER"  //Integer value
#define DB_DATATYPE_REAL @"REAL"    //Floating point value
#define DB_DATATYPE_TEXT @"TEXT"    //text string
#define DB_DATATYPE_BLOB @"BLOB"    //blob of data



@interface DotDBManager : NSObject

@property (nonatomic, strong) NSString *documentsDirectory;
@property (nonatomic, strong) NSString *databaseFilename;

- (BOOL)isTableExist:(NSString *)tableName;

- (BOOL)insertInto:(NSString *)tableName Values:(NSDictionary *)dataSet;

- (BOOL)createTable:(NSString *)tableName WithParameters:(NSDictionary *)attributes;

- (void)copyDatabaseIntoDocumentsDirectory;

- (NSArray *)queryTable:(NSString *)tableName ForAllRecordsBy:(NSArray *)attributeNames;

- (BOOL)deleteFromTable:(NSString *)tableName WithParameter:(NSDictionary *)target;


@end
