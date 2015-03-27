//
//  DotBLEManager.m
//  DotUIDraft
//
//  Created by Titus Cheng on 3/23/15.
//  Copyright (c) 2015 Braison. All rights reserved.
//

#import "DotBLEManager.h"

@implementation DotBLEManager
{
    CBCentralManager *cbCentral;
    BOOL stateOn;
    NSMutableDictionary *discoveredDevices;
    CBPeripheral *connectedDevice;
}

@synthesize delegate;

- (id)init
{
    self = [super init];
    if(self) {
        cbCentral = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    return self;
}


//Scan without specifying any UUID
- (void)startScan
{
    NSLog(@"Bluetooth start scanning");
    discoveredDevices = [[NSMutableDictionary alloc] init];
    [cbCentral scanForPeripheralsWithServices:nil options:nil];
}

//Scan with a list of UUID
- (void)startScanWithServices:(NSArray *)UUIDs
{
    NSLog(@"Bluetooth start scanning with service");
    NSMutableArray *cbuuids = [[NSMutableArray alloc] init];
    for(int i = 0; i < UUIDs.count; i++) {
        [cbuuids addObject:[CBUUID UUIDWithString:[UUIDs objectAtIndex:i]]];
    }
    NSMutableDictionary *scanningOption = [[NSMutableDictionary alloc] init];
    [scanningOption setObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    [cbCentral scanForPeripheralsWithServices:cbuuids options:scanningOption];
}


//Found devices
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSString *deviceID;
    if(peripheral.name) {
        deviceID = peripheral.name;
    } else if(peripheral.identifier) {
        deviceID = peripheral.identifier.UUIDString;
    }
    if(![discoveredDevices objectForKey:deviceID]) {
        NSLog(@"Bluetooth did found device %@", deviceID);
        [discoveredDevices setObject:peripheral forKey:deviceID];
        [delegate dotBLEManagerDidFoundDevices:deviceID];
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSString *deviceID;
    if(peripheral.name) {
        NSLog(@"Bluetooth did disconnect with device %@ with error %@", peripheral.name, error.localizedDescription);
        deviceID = peripheral.name;
    } else {
        NSLog(@"Bluetooth did disconnect with device %@ with error %@", peripheral.identifier.UUIDString, error.localizedDescription);
        deviceID = peripheral.identifier.UUIDString;
    }
    [delegate dotBLEManagerDidDisconnectWithDevice];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    if(peripheral.name) {
        NSLog(@"Bluetooth did connect to device %@", peripheral.name);
        [delegate dotBLEManagerDidConnectWithDevice:peripheral.name];
    } else {
        NSLog(@"Bluetooth did connect to device %@", peripheral.identifier.UUIDString);
        [delegate dotBLEManagerDidConnectWithDevice:peripheral.identifier.UUIDString];
    }
    connectedDevice = peripheral;
    connectedDevice.delegate = self;
//    [peripheral discoverServices:nil];
    [cbCentral stopScan];
}


- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSString *name;
    if(!error) {
        if(peripheral.name) {
            NSLog(@"Services on %@", peripheral.name);
            name = peripheral.name;
        } else {
            NSLog(@"Services on %@", peripheral.identifier.UUIDString);
            name = peripheral.identifier.UUIDString;
        }
        for(int i = 0; i < peripheral.services.count; i++) {
            CBService *myService = [peripheral.services objectAtIndex:i];
            [peripheral discoverCharacteristics:nil forService:myService];
            NSLog(@"%d.  %@(%d)", i,myService.UUID.UUIDString, myService.isPrimary);
        }
    } else {
        NSLog(@"Cannot find services in %@ with error %@", name, error.localizedDescription);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if(!error) {
        NSArray *characteristics = service.characteristics;
        for(int i = 0; i < characteristics.count; i++) {
            CBCharacteristic *myCharac = [characteristics objectAtIndex:i];
            NSLog(@"Characteristics (%@): %@ (%@)", service.UUID.UUIDString, myCharac.UUID.UUIDString, [self getCharacteristicPropertyName:myCharac.properties]);
        }
    }
}

- (NSString *)getCharacteristicPropertyName:(CBCharacteristicProperties)properties
{
    if(properties == CBCharacteristicPropertyAuthenticatedSignedWrites) {
        return @"Authenticated Signed Writes";
    } else if(properties == CBCharacteristicPropertyBroadcast) {
        return @"Broadcast";
    } else if(properties == CBCharacteristicPropertyExtendedProperties) {
        return @"Extended Properties";
    } else if(properties == CBCharacteristicPropertyIndicate) {
        return @"Indicate";
    } else if(properties == CBCharacteristicPropertyIndicateEncryptionRequired) {
        return @"Indicated Encryption Required";
    } else if(properties == CBCharacteristicPropertyNotify) {
        return @"Notify";
    } else if(properties == CBCharacteristicPropertyNotifyEncryptionRequired) {
        return @"Notify Encryption Required";
    } else if(properties == CBCharacteristicPropertyRead) {
        return @"Read";
    } else if(properties == CBCharacteristicPropertyWrite) {
        return @"Write";
    } else if(properties == CBCharacteristicPropertyWriteWithoutResponse) {
        return @"Write Without Response";
    }  else {
        return @"N/A";
    }
}



- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    if(peripheral.name) {
        NSLog(@"Bluetooth failed to connect to device %@ with error %@", peripheral.name, error.localizedDescription);
    } else {
        NSLog(@"Bluetooth failed to connect to device %@ with error %@", peripheral.identifier.UUIDString, error.localizedDescription);
    }
}


- (void)connectToDevice:(NSString *)deviceID
{
    NSLog(@"Bluetooth connecting with device %@", deviceID);
    [cbCentral connectPeripheral:[discoveredDevices objectForKey:deviceID] options:nil];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case 0:
            //State unknown
            NSLog(@"Bluetooth state unknown");
            break;
        case 1:
            //State ressetting
            NSLog(@"Bluetooth state resetting");
            break;
        case 2:
            //State unsupported
            NSLog(@"Bluetooth state unsupported");
            break;
        case 3:
            //State unauthorized
            NSLog(@"Bluetooth state unauthorized");
            break;
        case 4:
            //State PoweredOff
            NSLog(@"Bluetooth state powered off");
            stateOn = NO;
            [delegate dotBLEManagerDidPowerOffBLE];
            discoveredDevices = [[NSMutableDictionary alloc] init];
            break;
        case 5:
            //State PoweredOn
            NSLog(@"Bluetooth state powered on");
            [self startScan];
            stateOn = YES;
            break;
        default:
            break;
    }
}




@end
