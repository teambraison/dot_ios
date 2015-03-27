//
//  AboutTableViewCell.h
//  DotUIDraft
//
//  Created by Titus Cheng on 3/10/15.
//  Copyright (c) 2015 Braison. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ABOUT_CELL @"aboutcell"

@interface AboutTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *description;

@end
