//
//  SIEvent.h
//  SensoriSDK
//
//  Created by Andrew Gold on 11/18/14.
//  Copyright (c) 2014 Sensori, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SIEventType){PICKED_UP, DROPPED, SWIPE_RIGHT, SWIPE_LEFT};

@interface SIEvent : NSObject

@property (nonatomic) SIEventType type;

@end
