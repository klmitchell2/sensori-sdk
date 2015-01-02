/*
 *  deviceSelector.h
 *
 * Created by Ole Andreas Torvmark on 10/2/12.
 * Copyright (c) 2012 Texas Instruments Incorporated - http://www.ti.com/
 * ALL RIGHTS RESERVED
 */

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BLEDevice.h"
//#import "SensorTagApplicationViewController.h"

@interface deviceSelector : UIViewController <CBCentralManagerDelegate,CBPeripheralDelegate, UITableViewDataSource, UITableViewDelegate> {
    UIView *footerView;
    UIView *headerView;
}

@property (strong,nonatomic) CBCentralManager *m;
@property (strong,nonatomic) NSMutableArray *nDevices;
@property (strong,nonatomic) NSMutableArray *sensorTags;
@property (strong, nonatomic) UITableView *tableView;

-(NSMutableDictionary *) makeSensorTagConfiguration;

@end

