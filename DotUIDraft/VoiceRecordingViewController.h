//
//  VoiceRecordingViewController.h
//  DotUIDraft
//
//  Created by Titus Cheng on 3/9/15.
//  Copyright (c) 2015 Braison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoiceTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SampleVoiceRecordingViewController.h"
#import "VoiceRecordItem.h"


@interface VoiceRecordingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    AVAudioPlayer *audioPlayer;
    MPMoviePlayerViewController *moviePlayer;
}

@property (weak, nonatomic) IBOutlet UITableView *voiceMemoTableView;

@end
