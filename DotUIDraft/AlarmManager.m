//
//  AlarmManager.m
//  DotUIDraft
//
//  Created by Titus Cheng on 3/26/15.
//  Copyright (c) 2015 Braison. All rights reserved.
//

#import "AlarmManager.h"

@implementation AlarmManager
{
    DotDBManager *dbManager;
}


+ (AlarmManager *)sharedInstance {
    static dispatch_once_t once;
    static AlarmManager *instance;
    dispatch_once(&once, ^{
        instance = [[AlarmManager alloc] init];
    });
    return instance;
    
}


- (void)setUp
{
    dbManager = [[DotDBManager alloc] init];
    NSMutableDictionary *tableAttributes = [[NSMutableDictionary alloc] init];
    [tableAttributes setObject:DB_DATATYPE_TEXT forKey:ALARM_ATTR_TIME];
    [tableAttributes setObject:DB_DATATYPE_INTEGER forKey:ALARM_ATTR_STATUS];
    [tableAttributes setObject:DB_DATATYPE_TEXT forKey:ALARM_ATTR_DESCR];
    if(![dbManager isTableExist:ALARM_TABLE_NAME]) {
        [dbManager createTable:ALARM_TABLE_NAME WithParameters:tableAttributes];
    }
}

- (NSArray *)getAlarmList
{
    NSArray *parameters = [NSArray arrayWithObjects:ALARM_ATTR_TIME, ALARM_ATTR_STATUS, ALARM_ATTR_DESCR, nil];
    return [dbManager queryTable:ALARM_TABLE_NAME ForAllRecordsBy:parameters];
}

- (BOOL)deleteAlarm:(NSString *)time WithDescription:(NSString *)text
{
    NSLog(@"Deleting alarm %@", time);
    NSMutableDictionary *dataSet = [[NSMutableDictionary alloc] init];
    time = [NSString stringWithFormat:@"\"%@\"", time];
    text = [NSString stringWithFormat:@"\"%@\"", text];
    [dataSet setValue:time forKey:ALARM_ATTR_TIME];
    [dataSet setValue:text forKey:ALARM_ATTR_DESCR];
    if(!dbManager) {
        dbManager = [[DotDBManager alloc] init];
    }
    return [dbManager deleteFromTable:ALARM_TABLE_NAME WithParameter:dataSet];

}

- (BOOL)addAlarm:(NSString *)time WithDescription:(NSString *)text AndStatus:(BOOL)isOn
{
    NSLog(@"Adding alarm %@", time);
    NSMutableDictionary *dataSet = [[NSMutableDictionary alloc] init];
    time = [NSString stringWithFormat:@"\"%@\"", time];
    text = [NSString stringWithFormat:@"\"%@\"", text];
    [dataSet setValue:time forKey:ALARM_ATTR_TIME];
    [dataSet setValue:[NSNumber numberWithBool:isOn] forKey:ALARM_ATTR_STATUS];
    [dataSet setValue:text forKey:ALARM_ATTR_DESCR];
    if(!dbManager) {
        dbManager = [[DotDBManager alloc] init];
    }
    return [dbManager insertInto:ALARM_TABLE_NAME Values:dataSet];
}



@end
