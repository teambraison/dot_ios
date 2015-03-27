//
//  VoiceTableViewCell.h
//  DotUIDraft
//
//  Created by Titus Cheng on 3/10/15.
//  Copyright (c) 2015 Braison. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoiceTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *recordingDate;
@property (weak, nonatomic) IBOutlet UILabel *recordingDescription;

@property (weak, nonatomic) IBOutlet UILabel *recordingDuration;

@end
