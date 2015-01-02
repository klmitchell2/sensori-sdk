//
//  SensorObj.h
//  Baseball Swing
//
//  Created by sqzhu on 2/3/14.
//  Copyright (c) 2014 sensori. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLEDevice.h"
#import "TISensors.h"

@protocol ConnectionStatusUpdate <NSObject>
@required
- (void) statusUpdatedWithConnection:(BOOL)connection;
//- (void) receivedNotificationFromUUID:(CBUUID*)UUID WithData:(NSData*)data;
- (void) receivedDataTime:(float)time AccX:(float)accx Y:(float)accy Z:(float)accz GyroX:(float)gyrox Y:(float)gyroy Z:(float)gyroz MagX:(float)magx Y:(float)magy Z:(float)magz additional:(NSString*)additional;
- (void) receivedBatteryInfo:(int)batteryRaw;
@end

@interface SensorObj : NSObject <CBCentralManagerDelegate,CBPeripheralDelegate>

@property (strong,nonatomic) BLEDevice *d;
@property (strong,nonatomic) sensorMAG3110 *magSensor;
@property (strong,nonatomic) sensorIMU3000 *gyroSensor;
@property (strong,nonatomic) id <ConnectionStatusUpdate> delegate;
@property (assign,nonatomic,readonly) bool sensor_connected;
@property (assign,nonatomic,readonly) BOOL is_recording;

+ (SensorObj*)current;
-(void)setSensor:(BLEDevice*)d;
-(void) startRecording;
-(void) stopRecording;
-(void) disconnectSensor;
-(void) queryBattery;
-(BOOL)isConnected;
@end
