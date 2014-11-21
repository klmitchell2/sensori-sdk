//
//  SIDeviceSelectorDelegate.h
//  SensoriSDK
//
//  Created by Andrew Gold on 11/21/14.
//  Copyright (c) 2014 Sensori, LLC. All rights reserved.
//

#import "SISensor.h"

@protocol SIDeviceSelectorDelegate <NSObject>

- (void) didSelectSensor:(SISensor *)sensor;
- (void) didSelectSensors:(NSArray *)sensors;

@end
