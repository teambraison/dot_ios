//
//  AlarmManager.h
//  DotUIDraft
//
//  Created by Titus Cheng on 3/26/15.
//  Copyright (c) 2015 Braison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DotDBManager.h"

#define ALARM_TABLE_NAME @"Alarm"
#define ALARM_ATTR_TIME @"time"
#define ALARM_ATTR_STATUS @"status"
#define ALARM_ATTR_DESCR @"description"

@interface AlarmManager : NSObject

- (void)setUp;
- (BOOL)addAlarm:(NSString *)time WithDescription:(NSString *)text AndStatus:(BOOL)isOn;

- (BOOL)deleteAlarm:(NSString *)time WithDescription:(NSString *)text;

- (NSArray *)getAlarmList;

+ (AlarmManager *)sharedInstance;

@end
