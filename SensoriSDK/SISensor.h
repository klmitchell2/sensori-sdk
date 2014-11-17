//
//  SensorObject.h
//  SensoriSDK
//
//  Created by Andrew Gold on 11/17/14.
//  Copyright (c) 2014 Sensori, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SIError.h"
#import "SISensorDelegate.h"

typedef enum SensorStatus {CONNECTED, NOT_CONNECTED, MEASURING} SISensorStatus;
typedef enum SensorCollectionProfile {CONTINUOUS, PER_SECOND, PER_MINUTE, ON_EVENT} SISensorCollectionProfile;

@interface SISensor : NSObject

@property (nonatomic) enum SISensorStatus status; //an emun representing the status of the sensor (CONNECTED, NOT_CONNECTED, RECORDING).
@property (nonatomic) enum SISensorCollectionProfile collectionProfile; //this enum lets the sensor know at what rate data should be collected.
@property (nonatomic, strong, readonly) NSString *sensorID; //a unique ID for the sensor that is not mutable.
@property (nonatomic, strong) NSString *sensorName; //a user-defined name for the sensor.
@property (nonatomic) int batteryLife; //int (ideally 0-100), representing the strength of the battery.
@property (nonatomic) int connectionStrength; //int (ideally 0-100), representing the strength of the connection to the sensor.
@property (strong, nonatomic) id<SISensorDelegate> delegate;

- (BOOL) isConnected; //Returns whether or not the sensor is connected to the device.
- (BOOL) isMeasuring; //Returns whether or not the sensor is currently measuring.
- (void) connectSensorWithCallback:(void(^)(SIError *error))callback; //Connects the sensor to the device. Callback function is called upon completion, and an error is passed if one exists.
- (void) disConnectSensorWithCallback:(void(^)(SIError *error))callback; //Disconnects the sensor from the device. Callback function is called upon completion, and an error is passed if one exists.
- (void) setParameter:(NSString *)key WithValue:(id)value; //sets a given value for a given key and is stored associated with the sensor device.
- (void) startMeasuring; //Device begins measuring data.
- (void) stopMeasuring; //Device stops measuring data.
- (void) setName:(NSString *)name; //Sets a name for the device.

@end
