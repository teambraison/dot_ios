//
//  BluetoothViewController.h
//  DotUIDraft
//
//  Created by Titus Cheng on 3/9/15.
//  Copyright (c) 2015 Braison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DotBLEManager.h"
@interface BluetoothViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, DotBLEManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *devicesTableView;

@end
