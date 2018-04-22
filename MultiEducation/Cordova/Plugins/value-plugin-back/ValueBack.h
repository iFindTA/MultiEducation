//
//  ValueBack.h
//  MultiEducation
//
//  Created by nanhu on 2018/4/22.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "CDVPlugin.h"

@interface ValueBack : CDVPlugin

/**
 原生返回事件传递给Cordova js
 */
- (void)nativeBack2CordovaEvent;

@end
