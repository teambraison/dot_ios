//
//  AlarmViewController.m
//  DotUIDraft
//
//  Created by Titus Cheng on 3/9/15.
//  Copyright (c) 2015 Braison. All rights reserved.
//

#import "AlarmViewController.h"

@interface AlarmViewController ()
{
//    NSMutableArray *alarmList;
//    NSMutableArray *alarmDescription;
    NSArray *alarms;
    UITableViewCell *selectedCell;
    UIStoryboard *sb;
    AlarmManager *alarmManager;
}

@end

@implementation AlarmViewController

@synthesize alarmTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    alarmManager = [AlarmManager sharedInstance];
    [alarmManager setUp];
    
    alarmTableView.delegate = self;
    alarmTableView.dataSource = self;
    
    [alarmTableView registerNib:[UINib nibWithNibName:@"AlarmTableViewCell" bundle:nil] forCellReuseIdentifier:@"alarmcell"];
    
    alarms = [alarmManager getAlarmList];
    
    UISwipeGestureRecognizer *addAlarmTap = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(transitToNewAlarmView)];
    addAlarmTap.numberOfTouchesRequired = 1;
    addAlarmTap.direction = UISwipeGestureRecognizerDirectionDown;
    
    UITapGestureRecognizer *returnSwipe = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(returnToMenu)];
    returnSwipe.numberOfTouchesRequired = 2;
    returnSwipe.numberOfTapsRequired = 1;
    
    UIBarButtonItem *addAlarm = [[UIBarButtonItem alloc] initWithTitle:@"Add Alarm" style:UIBarButtonItemStylePlain target:self action:@selector(transitToNewAlarmView)];
    self.navigationItem.rightBarButtonItem = addAlarm;
    
    sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    [self.view addGestureRecognizer:addAlarmTap];
    [self.view addGestureRecognizer:returnSwipe];
    
    [self setTitle:@"Alarm"];
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    alarms = [alarmManager getAlarmList];
    [alarmTableView reloadData];
}

- (void)transitToNewAlarmView
{
    if(sb) {
        AlarmEditViewController *aavc = [sb instantiateViewControllerWithIdentifier:@"editalarm"];
        [aavc setEditingMode:ALARM_ADD_MODE];
        [self.navigationController pushViewController:aavc animated:YES];
    }
}

//- (void)setTime:(NSArray *)theTime
//{
//    selectedCell.textLabel.text = [NSString stringWithFormat:@"%@%@:%@%@", [theTime objectAtIndex:0], [theTime objectAtIndex:1], [theTime objectAtIndex:2], [theTime objectAtIndex:3]];
//}
//
//- (void)addNewAlarm:(NSArray *)newTime
//{
//    [alarmList addObject:[NSString stringWithFormat:@"%@%@:%@%@", [newTime objectAtIndex:0], [newTime objectAtIndex:1], [newTime objectAtIndex:2], [newTime objectAtIndex:3]]];
//}

- (void)returnToMenu
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return alarms.count;
}

- (AlarmTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlarmTableViewCell *cell = [alarmTableView dequeueReusableCellWithIdentifier:@"alarmcell"];
    if(!cell) {
        cell = [[AlarmTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"alarmcell"];
    }
    NSDictionary *alarmSettings = [alarms objectAtIndex:indexPath.row];
    cell.alarmTimeLabel.text = [alarmSettings objectForKey:ALARM_ATTR_TIME];
    cell.alarmDescriptionLabel.text = [alarmSettings objectForKey:ALARM_ATTR_DESCR];
    cell.alarmToggleSwitch.on = [alarmSettings objectForKey:ALARM_ATTR_STATUS];
    return cell;
}

- (double)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    selectedCell = [alarmTableView cellForRowAtIndexPath:indexPath];
//    NSString *targetedAlarm = [alarmList objectAtIndex:indexPath.row];
//    AlarmEditViewController *aavc = [sb instantiateViewControllerWithIdentifier:@"editalarm"];
//    [aavc setEditingMode:ALARM_EDIT_MODE];
//    [aavc setAlarmDescription:[alarmDescription objectAtIndex:indexPath.row]];
//    [self.navigationController pushViewController:aavc animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *selectedAlarm = [alarms objectAtIndex:indexPath.row];
        NSLog(@"Deleting alarm %@ with description %@", [selectedAlarm objectForKey:ALARM_ATTR_TIME], [selectedAlarm objectForKey:ALARM_ATTR_DESCR]);
        if([alarmManager deleteAlarm:[selectedAlarm objectForKey:ALARM_ATTR_TIME] WithDescription:[selectedAlarm objectForKey:ALARM_ATTR_DESCR]]) {
            alarms = [alarmManager getAlarmList];
            [alarmTableView reloadData];
        }
//        [alarmList removeObjectAtIndex:indexPath.row];
//        [alarmDescription removeObjectAtIndex:indexPath.row];
//        [alarmTableView reloadData];
    }
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
