//
//  SensoriSDK.h
//  SensoriSDK
//
//  Created by Andrew Gold on 11/16/14.
//  Copyright (c) 2014 Sensori, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SensoriSDK/SISensor.h>
#import <SensoriSDK/SIError.h>
#import <SensoriSDK/SISensorDelegate.h>
#import <SensoriSDK/SIData.h>
#import <SensoriSDK/SISensorManager.h>

//! Project version number for SensoriSDK.
FOUNDATION_EXPORT double SensoriSDKVersionNumber;

//! Project version string for SensoriSDK.
FOUNDATION_EXPORT const unsigned char SensoriSDKVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <SensoriSDK/PublicHeader.h>
+ (void) initWithDeveloperID:(NSString *)developerID ProjectID:(NSString *)projectID;
+ (SISensorManager *) getManager;

