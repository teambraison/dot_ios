//
//  ViewController.m
//  DotUIDraft
//
//  Created by Titus Cheng on 3/9/15.
//  Copyright (c) 2015 Braison. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSArray *menuList;
    UIStoryboard *sb;
    BOOL isFirstTime;
}

@end

@implementation ViewController

@synthesize menuTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [menuTableView registerNib:[UINib nibWithNibName:@"MainMenuCell" bundle:nil] forCellReuseIdentifier:MAINMENUCELL_REUSEID];
    menuList = [NSArray arrayWithObjects:@"Bluetooth", @"Alarm", @"Voice Recording", @"Language Setting", @"About", @"Instruction", nil];
    menuTableView.dataSource = self;
    menuTableView.delegate = self;
    
    sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [self setTitle:@"Main Menu"];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidLayoutSubviews
{
//    if(!isFirstTime) {
//        isFirstTime = YES;
//        BluetoothViewController *bvc = [sb instantiateViewControllerWithIdentifier:@"bluetooth"];
//        [self.navigationController pushViewController:bvc animated:YES];
//    }
}

- (MainMenuCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainMenuCell *cell = [menuTableView dequeueReusableCellWithIdentifier:MAINMENUCELL_REUSEID];
    if(!cell) {
        cell = [[MainMenuCell alloc] init];
    }
    cell.menuTitle.text = [menuList objectAtIndex:indexPath.row];
//    cell.textLabel.text = [menuList objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0) {
        BluetoothViewController *bvc = [sb instantiateViewControllerWithIdentifier:@"bluetooth"];
        [self.navigationController pushViewController:bvc animated:YES];
    } else if(indexPath.row == 1) {
        AlarmViewController *avc = [sb instantiateViewControllerWithIdentifier:@"alarm"];
        [self.navigationController pushViewController:avc animated:YES];
    } else if(indexPath.row == 2) {
        VoiceRecordingViewController *vrvc = [sb instantiateViewControllerWithIdentifier:@"voice_recording"];
        [self.navigationController pushViewController:vrvc animated:YES];
    } else if(indexPath.row == 3) {
        SettingViewController *svc = [sb instantiateViewControllerWithIdentifier:@"setting"];
        [self.navigationController pushViewController:svc animated:YES];
    } else if(indexPath.row == 4) {
        AboutViewController *avc = [sb instantiateViewControllerWithIdentifier:@"about"];
        [self.navigationController pushViewController:avc animated:YES];
    } else if(indexPath.row == 5) {
        InstructionViewController *ivc = [sb instantiateViewControllerWithIdentifier:@"instruction"];
        [self.navigationController pushViewController:ivc animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return menuList.count;
}

- (double)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
