//
//  SIData.h
//  SensoriSDK
//
//  Created by Andrew Gold on 11/17/14.
//  Copyright (c) 2014 Sensori, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIData : NSObject

@property (nonatomic, strong) NSArray *attitude; //array of CMAttitudes
@property (nonatomic, strong) NSArray *acceleration; //array of CMAccelerations
@property (nonatomic, strong) NSArray *gyroData; //array of CMRotationRates
@property (nonatomic, strong) NSMutableDictionary *metrics; //a mutable dictionary of metrics (i.e. velocity, number of swings)

- (void) addMetric:(id)metrics ForKey:(NSString *)key; //adds a metric for a given key.
- (void) saveData; //saves the data to a database (either locally or in the cloud).

@end
