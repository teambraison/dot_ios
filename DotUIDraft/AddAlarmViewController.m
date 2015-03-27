//
//  AddAlarmViewController.m
//  DotUIDraft
//
//  Created by Titus Cheng on 3/9/15.
//  Copyright (c) 2015 Braison. All rights reserved.
//

#import "AddAlarmViewController.h"

@interface AddAlarmViewController ()
{
    NSArray *alarmTime;
    BOOL isNewAlarm;
    int hour;
    int minute;
}

@end

@implementation AddAlarmViewController

@synthesize hour1Label, hour2Label, minute1Label, minute2Label, descriptionTextField, editAlarmButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", alarmTime);
    if(alarmTime && alarmTime.count > 0) {
        hour1Label.text = [NSString stringWithFormat:@"%@%@ hour", [alarmTime objectAtIndex:0], [alarmTime objectAtIndex:1]];
   //     hour2Label.text = [alarmTime objectAtIndex:1];
        minute1Label.text = [NSString stringWithFormat:@"%@%@ minute", [alarmTime objectAtIndex:2], [alarmTime objectAtIndex:3]];
    //    minute2Label.text = [alarmTime objectAtIndex:3];
        
    } else {
        hour1Label.text = @"12 hour";
      //  hour2Label.text = @"2";
        minute1Label.text = @"0 minute";
    //    minute2Label.text = @"0";
        alarmTime = [NSArray arrayWithObjects:@"1", @"2", @"0", @"0", nil];
    }
    
    hour = [[NSString stringWithFormat:@"%@%@", [alarmTime objectAtIndex:0], [alarmTime objectAtIndex:1]] intValue];
    minute = [[NSString stringWithFormat:@"%@%@", [alarmTime objectAtIndex:2], [alarmTime objectAtIndex:3]] intValue];
    
    
    [self addGestureToAlarm:hour1Label];
    [self addGestureToAlarm:hour2Label];
    [self addGestureToAlarm:minute1Label];
    [self addGestureToAlarm:minute2Label];
    
    [hour1Label setUserInteractionEnabled:YES];
    [hour2Label setUserInteractionEnabled:YES];
    [minute1Label setUserInteractionEnabled:YES];
    [minute2Label setUserInteractionEnabled:YES];
    
    descriptionTextField.delegate = self;
    [editAlarmButton addTarget:self action:@selector(returnToSetting) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *returnToSettingSwipe = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(returnToSetting)];
    returnToSettingSwipe.numberOfTouchesRequired = 2;
    returnToSettingSwipe.numberOfTapsRequired = 1;
    
    [self.view addGestureRecognizer:returnToSettingSwipe];
    [self setTitle:@"Add Or Edit Alarm"];
    // Do any additional setup after loading the view.
}

- (IBAction)increaseHourTapped:(id)sender {
    if(hour < 23) {
        hour++;
    UIButton *increaseButton = (UIButton*)sender;
    [increaseButton setTitle:[NSString stringWithFormat:@"Increase button, 10 o'clock", hour] forState:UIControlStateNormal];
    hour1Label.text = [NSString stringWithFormat:@"%d hour", hour];
    }
}

- (IBAction)decreaseHourTapped:(id)sender {
    if(hour > 0) {
        hour--;
        UIButton *increaseButton = (UIButton*)sender;
        [increaseButton setTitle:[NSString stringWithFormat:@"Decrease button, hour is now %d hour", hour] forState:UIControlStateNormal];
        hour1Label.text = [NSString stringWithFormat:@"%d hour", hour];
    }
}
- (IBAction)increaseMinuteTapped:(id)sender {
    if(minute < 59) {
        minute++;
        UIButton *increaseButton = (UIButton*)sender;
        [increaseButton setTitle:[NSString stringWithFormat:@"Increase button, minute is now %d minute", minute] forState:UIControlStateNormal];
        minute1Label.text = [NSString stringWithFormat:@"%d minute", minute];
    }
}


- (IBAction)decreaseMinuteTapped:(id)sender {
    if(minute > 0) {
        minute--;
        UIButton *increaseButton = (UIButton*)sender;
        [increaseButton setTitle:[NSString stringWithFormat:@"Decrease button, minute is now %d minute", minute] forState:UIControlStateNormal];
        minute1Label.text = [NSString stringWithFormat:@"%d minute", minute];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)setIsNewAlarm:(BOOL)alarmStatus
{
    isNewAlarm = alarmStatus;
    if(isNewAlarm) {
        [editAlarmButton setTitle:@"Save Alarm" forState:UIControlStateNormal];
    } else {
        [editAlarmButton setTitle:@"Save Edit" forState:UIControlStateNormal];
    }
}

- (void)returnToSetting
{
    AlarmViewController *avc = (AlarmViewController*)[self presentingViewController];
    if(isNewAlarm) {
        [avc addNewAlarm:[NSArray arrayWithObjects:hour1Label.text, hour2Label.text, minute1Label.text, minute2Label.text, nil]];
    } else {
        [avc setTime:[NSArray arrayWithObjects:hour1Label.text, hour2Label.text, minute1Label.text, minute2Label.text, nil]];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addGestureToAlarm:(UILabel *)theView
{
    NSLog(@"Adding gesture recognizer to label");
    UISwipeGestureRecognizer *increaseSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(increaseTime:)];
    increaseSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    increaseSwipe.numberOfTouchesRequired = 1;
    
    UISwipeGestureRecognizer *decreaseSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(decreaseTime:)];
    decreaseSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    decreaseSwipe.numberOfTouchesRequired = 1;
    
    [theView addGestureRecognizer:increaseSwipe];
    [theView addGestureRecognizer:decreaseSwipe];
}


- (void)increaseTime:(UIGestureRecognizer *)swipeGesture
{
    NSLog(@"Increasing time");
    UILabel *swipeView = (UILabel *)[swipeGesture view];
    if((swipeView == hour1Label && [swipeView.text integerValue]  < 2)
       || (swipeView == minute1Label && [swipeView.text integerValue] < 5)
       || (swipeView == minute2Label && [swipeView.text integerValue] < 9)){
        NSInteger digit = [swipeView.text integerValue];
        digit++;
        swipeView.text = [NSString stringWithFormat:@"%ld", digit];
    } else if(swipeView == hour2Label) {
        if(([hour1Label.text integerValue] == 1 || [hour1Label.text integerValue] == 0) && [swipeView.text integerValue] < 9) {
            NSInteger digit = [swipeView.text integerValue];
            digit++;
            swipeView.text = [NSString stringWithFormat:@"%ld", digit];
        }
        if(([hour1Label.text integerValue] == 2) && [swipeView.text integerValue] < 4) {
            NSInteger digit = [swipeView.text integerValue];
            digit++;
            swipeView.text = [NSString stringWithFormat:@"%ld", digit];
        }
    }
}

- (void)decreaseTime:(UIGestureRecognizer *)swipeGesture
{
    NSLog(@"Decreasing time");
    UILabel *swipeView = (UILabel *)[swipeGesture view];
    if([swipeView.text integerValue] > 0){
        NSInteger digit = [swipeView.text integerValue];
        digit--;
        swipeView.text = [NSString stringWithFormat:@"%ld", digit];
    }
}



- (void)setAlarmTime:(NSString *)time
{
    time = [time stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < [time length]; i++) {
        NSString *ch = [time substringWithRange:NSMakeRange(i, 1)];
        [array addObject:ch];
    }
    alarmTime = (NSArray *)array;
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
