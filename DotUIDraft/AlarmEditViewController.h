//
//  AlarmEditViewController.h
//  DotUIDraft
//
//  Created by Titus Cheng on 3/10/15.
//  Copyright (c) 2015 Braison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlarmManager.h"

#define ALARM_EDIT_MODE 1
#define ALARM_ADD_MODE 2

@interface AlarmEditViewController : UIViewController <UITextFieldDelegate>

- (void)setEditingMode:(NSInteger)theMode;

@property (weak, nonatomic) IBOutlet UIDatePicker *timePickerView;
@property (weak, nonatomic) IBOutlet UITextField *alarmDescriptionField;

@property (weak, nonatomic) IBOutlet UIButton *finishButton;

- (void)setAlarmDescription:(NSString *)theDescription;

@end
