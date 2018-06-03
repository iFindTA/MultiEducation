//
//  SBNetState.h
//  MultiEducation
//
//  Created by nanhu on 2018/6/3.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBNetState : NSObject

+ (void)startPing;

/**
 whether network alavilable
 */
+ (BOOL)isReachable;

+ (BOOL)isViaWifi;

@end
