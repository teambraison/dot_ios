//
//  SampleVoiceRecordingViewController.h
//  DotUIDraft
//
//  Created by Titus Cheng on 3/24/15.
//  Copyright (c) 2015 Braison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenEars/OELanguageModelGenerator.h>
#import <OpenEars/OEAcousticModel.h>
#import <OpenEars/OEPocketsphinxController.h>
#import <OpenEars/OEEventsObserver.h>
#import <AVFoundation/AVFoundation.h>

@interface SampleVoiceRecordingViewController : UIViewController<OEEventsObserverDelegate, AVAudioRecorderDelegate>

@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) OEEventsObserver *openEarsEventsObserver;

@end
