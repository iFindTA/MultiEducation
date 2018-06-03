//
//  SBNetState.m
//  MultiEducation
//
//  Created by nanhu on 2018/6/3.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "SBNetState.h"
#import <RealReachability/RealReachability.h>

@interface SBNetState ()

@end

static SBNetState *instance = nil;

@implementation SBNetState

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[[self class] alloc] init];
        }
    });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark --- Class Methods for Ping

+ (void)startPing {
    GLobalRealReachability.hostForPing = @"www.baidu.com";
    GLobalRealReachability.hostForCheck = @"www.x16.com";
    [GLobalRealReachability startNotifier];
}

+ (BOOL)isReachable {
    return GLobalRealReachability.currentReachabilityStatus != RealStatusNotReachable;
}

+ (BOOL)isViaWifi {
    return GLobalRealReachability.currentReachabilityStatus == RealStatusViaWiFi;
}

@end
