//
//  BluetoothViewController.m
//  DotUIDraft
//
//  Created by Titus Cheng on 3/9/15.
//  Copyright (c) 2015 Braison. All rights reserved.
//

#import "BluetoothViewController.h"

@interface BluetoothViewController ()
{
    NSMutableArray *deviceList;
    NSArray *connectionStatus;
    UIAlertView *alertView;
    DotBLEManager *ble;
    NSInteger numOfSection;
    NSArray *connectedDevice;
    BOOL isConnected;
}

@end

@implementation BluetoothViewController

@synthesize devicesTableView;


- (void)viewDidLoad {
    [super viewDidLoad];
    devicesTableView.delegate = self;
    devicesTableView.dataSource = self;
    
    [self setTitle:@"Bluetooth"];
    
    deviceList = [[NSMutableArray alloc] init];
    
    ble = [[DotBLEManager alloc] init];
    ble.delegate = self;
    [ble startScan];
    numOfSection = 1;
    isConnected = NO;
    // Do any additional setup after loading the view.
}

- (void)scanForDevice
{
    alertView = [[UIAlertView alloc] initWithTitle:@"Device found" message:@"Mike's watch" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Connect", nil];
    [alertView show];
}

- (void)dotBLEManagerDidFoundDevices:(NSString *)deviceName
{
    if(deviceName) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [deviceList addObject:deviceName];
            [devicesTableView reloadData];
        });
    }
}

- (void)dotBLEManagerDidConnectWithDevice:(NSString *)deviceName
{
    numOfSection = 2;
    connectedDevice = [NSArray arrayWithObject:deviceName];
    [deviceList removeObject:deviceName];
    isConnected = YES;
    [devicesTableView reloadData];
}

- (void)dotBLEManagerDidPowerOffBLE
{
    [self restartDeviceList];
}

- (void)restartDeviceList
{
    deviceList = [[NSMutableArray alloc] init];
    isConnected = NO;
    numOfSection = 1;
    [devicesTableView reloadData];
}


- (void)returnToMenu
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isConnected && section == 0) {
        return 1;
    } else {
        return deviceList.count;
    }

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return numOfSection;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [devicesTableView dequeueReusableCellWithIdentifier:@"device"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"device"];
    }
    if(isConnected && indexPath.section == 0) {
        cell.textLabel.text = [connectedDevice objectAtIndex:indexPath.row];
    } else {
        cell.textLabel.text = [deviceList objectAtIndex:indexPath.row];
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            if(isConnected){
                return @"Connected device";
            } else {
                return @"Available device";
            }
            break;
        case 1:
            return @"Available device";
            break;
        default:
            break;
    }
    return @"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [ble connectToDevice:[deviceList objectAtIndex:indexPath.row]];

}

- (void)dotBLEManagerDidDisconnectWithDevice
{
    numOfSection = 1;
    connectedDevice = [[NSArray alloc] init];
    [devicesTableView reloadData];
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
