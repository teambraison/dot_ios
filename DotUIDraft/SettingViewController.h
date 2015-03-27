//
//  SettingViewController.h
//  DotUIDraft
//
//  Created by Titus Cheng on 3/9/15.
//  Copyright (c) 2015 Braison. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *settingTableView;

@end
