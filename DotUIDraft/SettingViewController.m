//
//  SettingViewController.m
//  DotUIDraft
//
//  Created by Titus Cheng on 3/9/15.
//  Copyright (c) 2015 Braison. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()
{
    NSArray *settingList;
    UIAlertView *alertView;
    UITableViewCell *selectedCell;
}

@end

@implementation SettingViewController

@synthesize settingTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    settingList = [NSArray arrayWithObjects:@"English", @"한국어", nil];
    settingTableView.dataSource = self;
    settingTableView.delegate = self;
    
    UITapGestureRecognizer *returnToMenuTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(returnToMenu)];
    returnToMenuTap.numberOfTouchesRequired = 2;
    returnToMenuTap.numberOfTapsRequired = 1;
    
    [self.view addGestureRecognizer:returnToMenuTap];
    [self setTitle:@"Language Setting"];
    // Do any additional setup after loading the view.
}

- (void)returnToMenu
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return settingList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [settingTableView dequeueReusableCellWithIdentifier:@"Test"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Test"];
    }
    cell.textLabel.text = [settingList objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedCell = [settingTableView cellForRowAtIndexPath:indexPath];
    NSString *title = [NSString stringWithFormat:@"You have chosen %@ Language", [settingList objectAtIndex:indexPath.row]];
    alertView = [[UIAlertView alloc] initWithTitle:title  message:@"The changes will be made on next sync" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
    [alertView show];
    
    NSArray *allCells = [settingTableView visibleCells];
    for(int i = 0; i < allCells.count; i++) {
        UITableViewCell *myCell = (UITableViewCell *)[allCells objectAtIndex:i];
        myCell.detailTextLabel.text = @"";
    }
    selectedCell.detailTextLabel.text = @"Selected";
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
