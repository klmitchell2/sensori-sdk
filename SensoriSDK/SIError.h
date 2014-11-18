//
//  SensoriError.h
//  SensoriSDK
//
//  Created by Andrew Gold on 11/17/14.
//  Copyright (c) 2014 Sensori, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SIErrorType){BATTERY_TOO_LOW, NO_SENSORS_FOUND, OUT_OF_RANGE};


@interface SIError : NSError

@property (nonatomic) SIErrorType error;

@end
