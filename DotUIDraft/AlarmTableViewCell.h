//
//  AlarmTableViewCell.h
//  DotUIDraft
//
//  Created by Titus Cheng on 3/10/15.
//  Copyright (c) 2015 Braison. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlarmTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *alarmDescriptionLabel;

@property (weak, nonatomic) IBOutlet UILabel *alarmTimeLabel;

@property (weak, nonatomic) IBOutlet UISwitch *alarmToggleSwitch;

@end
