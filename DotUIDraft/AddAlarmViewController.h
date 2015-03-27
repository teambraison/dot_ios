//
//  AddAlarmViewController.h
//  DotUIDraft
//
//  Created by Titus Cheng on 3/9/15.
//  Copyright (c) 2015 Braison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlarmViewController.h"

@interface AddAlarmViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *hour1;

@property (weak, nonatomic) IBOutlet UILabel *hour1Label;

@property (weak, nonatomic) IBOutlet UILabel *hour2Label;

@property (weak, nonatomic) IBOutlet UILabel *minute1Label;

@property (weak, nonatomic) IBOutlet UILabel *minute2Label;

@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UIButton *editAlarmButton;

- (void)setAlarmTime:(NSString *)time;
- (void)setIsNewAlarm:(BOOL)alarmStatus;

@end
