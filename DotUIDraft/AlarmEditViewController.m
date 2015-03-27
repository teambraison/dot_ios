//
//  AlarmEditViewController.m
//  DotUIDraft
//
//  Created by Titus Cheng on 3/10/15.
//  Copyright (c) 2015 Braison. All rights reserved.
//

#import "AlarmEditViewController.h"

@interface AlarmEditViewController ()
{
    NSInteger mode;
    NSString *alarmDescription;
}

@end

@implementation AlarmEditViewController

@synthesize finishButton, alarmDescriptionField, timePickerView;

- (void)viewDidLoad {
    [super viewDidLoad];
    if(mode == ALARM_EDIT_MODE) {
        [self setTitle:@"Edit Alarm"];
        if(alarmDescription){
            alarmDescriptionField.text = alarmDescription;
        }
    } else if(mode == ALARM_ADD_MODE) {
        [self setTitle:@"Add Alarm"];
    }
    alarmDescriptionField.delegate = self;
    // Do any additional setup after loading the view.
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)setAlarmDescription:(NSString *)theDescription
{
    alarmDescription = theDescription;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setEditingMode:(NSInteger)theMode
{
    mode = theMode;
}


- (IBAction)saveAlarmTapped:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSLog(@"Date: %@", [dateFormatter stringFromDate:timePickerView.date]);
    AlarmManager *alarmManager = [AlarmManager sharedInstance];
    if([alarmManager addAlarm:[dateFormatter stringFromDate:timePickerView.date] WithDescription:alarmDescriptionField.text AndStatus:YES]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}






/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
