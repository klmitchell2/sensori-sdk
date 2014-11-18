//
//  SISensorManager.h
//  SensoriSDK
//
//  Created by Andrew Gold on 11/18/14.
//  Copyright (c) 2014 Sensori, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SIError.h"
#import "SISensor.h"

@interface SISensorManager : NSObject

- (NSArray *) sensorsInRange; //returns an array of the SISensors in range of the iOS device.
- (NSArray *) sensorsConnected; //returns an array of the SISensors connected to the device.
- (void) disconnectAllSensorsWithCallback:(void(^)(SIError *error))callback;
- (SISensor *) strongestSensor; //returns the strongest sensor (best connection/battery life) connected to the device.
- (SISensor *) sensorWithName:(NSString *)name; //returns the sensor with the given name parameter.
- (SISensor *) latest; //returns the latest sensor used.

@end
