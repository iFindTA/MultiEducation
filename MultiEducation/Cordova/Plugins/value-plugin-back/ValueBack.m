//
//  ValueBack.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/22.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "ValueBack.h"

@implementation ValueBack

- (void)nativeBack2CordovaEvent {
    NSString *callback = [NSString stringWithFormat:@"alert()"];
    [self.commandDelegate evalJs:callback];
}

@end
