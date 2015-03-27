//
//  ViewController.h
//  DotUIDraft
//
//  Created by Titus Cheng on 3/9/15.
//  Copyright (c) 2015 Braison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingViewController.h"
#import "AlarmViewController.h"
#import "VoiceRecordingViewController.h"
#import "BluetoothViewController.h"
#import "AboutViewController.h"
#import "InstructionViewController.h"
#import "MainMenuCell.h"


@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *menuTableView;

@end

