//
//  MEWebProgress.h
//  MultiEducation
//
//  Created by nanhu on 2018/4/22.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MEWebProgress : NSObject

@property (nonatomic, copy) void(^webProxyCallback)(CGFloat progress);

@property (nonatomic, readonly) float progress; // 0.0..1.0

- (void)webviewDidStartLoad;

- (void)webViewDidFinishLoad;

- (void)reset;

@end
