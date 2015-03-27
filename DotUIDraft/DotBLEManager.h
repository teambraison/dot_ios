//
//  DotBLEManager.h
//  DotUIDraft
//
//  Created by Titus Cheng on 3/23/15.
//  Copyright (c) 2015 Braison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol DotBLEManagerDelegate <NSObject>

- (void)dotBLEManagerDidFoundDevices:(NSString *)deviceName;
- (void)dotBLEManagerDidConnectWithDevice:(NSString *)deviceName;
- (void)dotBLEManagerDidPowerOffBLE;
- (void)dotBLEManagerDidDisconnectWithDevice;

@end

@interface DotBLEManager : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (weak) id<DotBLEManagerDelegate> delegate;

- (void)startScan;

- (void)startScanWithServices:(NSArray *)UUIDs;

- (void)connectToDevice:(NSString *)deviceID;

@end
