//
//  AboutViewController.m
//  DotUIDraft
//
//  Created by Titus Cheng on 3/9/15.
//  Copyright (c) 2015 Braison. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()
{
    NSArray *titles;
    NSArray *descriptions;
}

@end

@implementation AboutViewController

@synthesize aboutTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"About"];
    
    aboutTableView.delegate = self;
    aboutTableView.dataSource = self;
    
    titles = [NSArray arrayWithObjects:@"Watch name", @"Watch version", @"App version", nil];
    descriptions = [NSArray arrayWithObjects:@"v1.0", @"v1.0", @"v1.0", nil];
    
    [aboutTableView registerNib:[UINib nibWithNibName:@"AboutTableViewCell" bundle:nil] forCellReuseIdentifier:ABOUT_CELL];
    
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titles.count;
}

- (AboutTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AboutTableViewCell *cell = [aboutTableView dequeueReusableCellWithIdentifier:ABOUT_CELL];
    if(!cell) {
        cell = [[AboutTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ABOUT_CELL];
    }
    cell.title.text = [titles objectAtIndex:indexPath.row];
    cell.description.text = [descriptions objectAtIndex:indexPath.row];
    return cell;
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
