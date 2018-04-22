//
//  MEWebProgress.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/22.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEWebProgress.h"
#import <NJKWebViewProgress/NJKWebViewProgress.h>

const float MEInitialProgressValue = 0.1f;
const float MEInteractiveProgressValue = 0.5f;
const float MEFinalProgressValue = 0.9f;

@implementation MEWebProgress {
    NSUInteger _loadingCount;
    NSUInteger _maxLoadCount;
    NSURL *_currentURL;
    BOOL _interactive;
}

- (id)init
{
    self = [super init];
    if (self) {
        _maxLoadCount = _loadingCount = 0;
        _interactive = NO;
    }
    return self;
}

- (void)startProgress
{
    if (_progress < MEInitialProgressValue) {
        [self setProgress:MEInitialProgressValue];
    }
}

- (void)incrementProgress
{
    float progress = self.progress;
    float maxProgress = _interactive ? MEFinalProgressValue : MEInteractiveProgressValue;
    float remainPercent = (float)_loadingCount / (float)_maxLoadCount;
    float increment = (maxProgress - progress) * remainPercent;
    progress += increment;
    progress = fmin(progress, maxProgress);
    [self setProgress:progress];
}

- (void)completeProgress
{
    [self setProgress:1.0];
}

- (void)setProgress:(float)progress
{
    // progress should be incremental only
    if (progress > _progress || progress == 0) {
        _progress = progress;
        if (self.webProxyCallback) {
            self.webProxyCallback(progress);
        }
    }
}

- (void)reset
{
    _maxLoadCount = _loadingCount = 0;
    _interactive = NO;
    [self setProgress:0.0];
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webviewDidStartLoad {
    _loadingCount++;
    _maxLoadCount = fmax(_maxLoadCount, _loadingCount);
    
    [self startProgress];
}

- (void)webViewDidFinishLoad {
    _loadingCount--;
    [self incrementProgress];
    
    [self completeProgress];
}

@end
