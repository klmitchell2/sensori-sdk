//
//  SensoriObjectProtocol.h
//  SensoriSDK
//
//  Created by Andrew Gold on 11/17/14.
//  Copyright (c) 2014 Sensori, LLC. All rights reserved.
//


@class SIData;
@class SISensor;
@class SIEvent;

@protocol SISensorDelegate <NSObject>


- (void) beganMeasuringWithSensor:(SISensor *)sensor;
- (void) stoppedMeasuringWithSensor:(SISensor *)sensor;
- (void) sensor:(SISensor *)sensor didCollectData:(SIData *)data;
- (void) sensor:(SISensor *)sensor didDetectEvent:(SIEvent *)event;

@end
