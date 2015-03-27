//
//  AboutViewController.h
//  DotUIDraft
//
//  Created by Titus Cheng on 3/9/15.
//  Copyright (c) 2015 Braison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AboutTableViewCell.h"

@interface AboutViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *aboutTableView;

@end
