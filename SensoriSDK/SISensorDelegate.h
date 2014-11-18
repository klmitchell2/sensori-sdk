//
//  SensoriObjectProtocol.h
//  SensoriSDK
//
//  Created by Andrew Gold on 11/17/14.
//  Copyright (c) 2014 Sensori, LLC. All rights reserved.
//

#import "SISensor.h"
#import "SIData.h"
#import "SIEvent.h"

@protocol SISensorDelegate <NSObject>

@required
- (void) beganMeasuringWithSensor:(SISensor *)sensor;
- (void) stoppedMeasuringWithSensor:(SISensor *)sensor;
- (void) sensor:(SISensor *)sensor didCollectData:(SIData *)data;
@optional
- (void) sensor:(SISensor *)sensor didDetectEvent:(SIEvent *)event;


@end
