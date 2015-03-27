//
//  AlarmViewController.h
//  DotUIDraft
//
//  Created by Titus Cheng on 3/9/15.
//  Copyright (c) 2015 Braison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddAlarmViewController.h"
#import "AlarmEditViewController.h"
#import "AlarmTableViewCell.h"
#import "AlarmManager.h"

@interface AlarmViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *alarmTableView;


@end
