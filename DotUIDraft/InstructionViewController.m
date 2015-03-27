//
//  InstructionViewController.m
//  DotUIDraft
//
//  Created by Titus Cheng on 3/9/15.
//  Copyright (c) 2015 Braison. All rights reserved.
//

#import "InstructionViewController.h"

@interface InstructionViewController ()
{
    NSArray *instructionList;
}

@end

@implementation InstructionViewController

@synthesize instructionTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    instructionTableView.delegate = self;
    instructionTableView.dataSource = self;
    
    instructionList = [NSArray arrayWithObjects:@"How to use this app video", nil];
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return instructionList.count;
}
                       
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [instructionTableView dequeueReusableCellWithIdentifier:@"inst"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"inst"];
    }
    cell.textLabel.text = [instructionList objectAtIndex:indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"You chose %@", [instructionList objectAtIndex:indexPath.row]] message:@"" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
    [alertview show];
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
