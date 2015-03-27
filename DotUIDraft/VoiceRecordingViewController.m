//
//  VoiceRecordingViewController.m
//  DotUIDraft
//
//  Created by Titus Cheng on 3/9/15.
//  Copyright (c) 2015 Braison. All rights reserved.
//

#import "VoiceRecordingViewController.h"

@interface VoiceRecordingViewController ()
{
//    NSArray *recording_dates;
//    NSArray *recording_description;
//    NSArray *recording_duration;
    NSMutableArray *recordings;
    NSInteger previousSelectedNote;
}

@end

@implementation VoiceRecordingViewController

@synthesize voiceMemoTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [voiceMemoTableView registerNib:[UINib nibWithNibName:@"VoiceTableViewCell" bundle:nil] forCellReuseIdentifier:@"voicecell"];
    
    voiceMemoTableView.delegate = self;
    voiceMemoTableView.dataSource = self;
    
    recordings = [[NSMutableArray alloc] init];
    
    previousSelectedNote = -1;
    
//    recording_dates = [NSArray arrayWithObjects:@"2015, March 10th,  09:00am", @"2015, March 9th, 04:15pm", nil];
//    recording_description = [NSArray arrayWithObjects:@"The sashimi was delicious at the Tavern.  Remember to come to this place again", @"Berlin has an awesome bar!", nil];
//    recording_duration = [NSArray arrayWithObjects:@"", @"", nil];
    
    UITapGestureRecognizer *returnToMenuTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(returnToMenu)];
    returnToMenuTap.numberOfTouchesRequired = 2;
    returnToMenuTap.numberOfTapsRequired = 1;
    
    [self.view addGestureRecognizer:returnToMenuTap];
    [self setTitle:@"Voice Recording"];
    
    
    UIBarButtonItem *addVoiceNote = [[UIBarButtonItem alloc] initWithTitle:@"Add Note" style:UIBarButtonItemStylePlain target:self action:@selector(transitToSampleVoiceView)];
    self.navigationItem.rightBarButtonItem = addVoiceNote;
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [recordings removeAllObjects];
    [self getVoiceNoteList];
}

- (NSString *)getDurationFromVoiceRecord:(NSString *)fileName
{
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               fileName,
                               nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    AVURLAsset* audioAsset = [AVURLAsset URLAssetWithURL:outputFileURL options:nil];
    CMTime audioDuration = audioAsset.duration;
    int audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    int minutes = audioDurationSeconds / 60;
    int seconds = audioDurationSeconds % 60;
    
    if(minutes > 0) {
        return [NSString stringWithFormat:@"%d minutes %d seconds", minutes, seconds];
    } else {
        return [NSString stringWithFormat:@"%d seconds", seconds];
    }
}

- (void)getVoiceNoteList
{
    [recordings removeAllObjects];
    NSFileManager *fManager = [NSFileManager defaultManager];
    NSString *item;
    NSArray *contents = [fManager contentsOfDirectoryAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] error:nil];
    
    // >>> this section here adds all files with the chosen extension to an array
    for (item in contents){
        if ([[item pathExtension] isEqualToString:@"m4a"]) {
            VoiceRecordItem *recordedItem = [[VoiceRecordItem alloc] init];
            recordedItem.date = [item stringByReplacingOccurrencesOfString:@".m4a" withString:@""];
            recordedItem.summary = @"Sample voice data";
            recordedItem.duration = [self getDurationFromVoiceRecord:item];
            [recordings addObject:recordedItem];
        }
    }
    recordings = (NSMutableArray *)[[recordings reverseObjectEnumerator] allObjects];
    [voiceMemoTableView reloadData];
}

- (void)transitToSampleVoiceView
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SampleVoiceRecordingViewController *svrvc = [sb instantiateViewControllerWithIdentifier:@"samplevoicerecording"];
    [self.navigationController pushViewController:svrvc animated:YES];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        VoiceRecordItem *item = [recordings objectAtIndex:indexPath.row];
        
        NSString *fileName = [item.date stringByAppendingString:@".m4a"];
        NSArray *pathComponents = [NSArray arrayWithObjects:
                                   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                                   fileName,
                                   nil];
        NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
        if([[NSFileManager defaultManager] removeItemAtURL:outputFileURL error:nil]) {
            NSLog(@"Deleted file");
            [self getVoiceNoteList];
        }
    }
}

- (void)returnToMenu
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return recordings.count;
}

- (void)performActionOnSelectedVoiceNote:(NSString *)filename WithStatus:(BOOL)shouldPlay
{
    NSURL *outputFileURL;
    if(filename) {
        NSArray *pathComponents = [NSArray arrayWithObjects:
                                   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                                   [filename stringByAppendingString:@".m4a"],
                                   nil];
        outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    }
    if(shouldPlay) {
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:outputFileURL error:nil];
        [audioPlayer play];
    } else {
        [audioPlayer stop];
    }
    
}



- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Unselected");
        [self performActionOnSelectedVoiceNote:nil WithStatus:NO];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //If the audio is not playing
    if(![audioPlayer isPlaying]) {
        if(previousSelectedNote != indexPath.row) {
            previousSelectedNote = indexPath.row;
        }
        VoiceRecordItem *recordingItem = [recordings objectAtIndex:indexPath.row];
        [self performActionOnSelectedVoiceNote:recordingItem.date WithStatus:YES];
        NSLog(@"Playing audio %@", [[recordings objectAtIndex:indexPath.row] date]);

    } else {
        if(previousSelectedNote != indexPath.row) {
            previousSelectedNote = indexPath.row;
            VoiceRecordItem *recordingItem = [recordings objectAtIndex:indexPath.row];
            [self performActionOnSelectedVoiceNote:recordingItem.date WithStatus:YES];
            NSLog(@"Playing audio %@", [[recordings objectAtIndex:indexPath.row] date]);
        } else {
            [audioPlayer stop];
            NSLog(@"Stop playing audio");
        }

    }
}

- (VoiceTableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VoiceTableViewCell *cell = [voiceMemoTableView dequeueReusableCellWithIdentifier:@"voicecell"];
    if(!cell) {
        cell = [[VoiceTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"voicecell"];
    }
    VoiceRecordItem *myItem = [recordings objectAtIndex:indexPath.row];
    cell.recordingDate.text = myItem.date;
    cell.recordingDescription.text = myItem.summary;
    cell.recordingDuration.text = myItem.duration;
  //  cell.recordingDuration.text = [recording_duration objectAtIndex:indexPath.row];
    return cell;
}

- (double)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
