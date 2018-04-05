//
//  NSURLSessionTask+PBHelper.m
//  FLKNetServicePro
//
//  Created by nanhujiaju on 2017/4/6.
//  Copyright © 2017年 nanhu. All rights reserved.
//

#import "NSURLSessionTask+PBHelper.h"
#import <objc/runtime.h>

static const void *pbTaskIdentifierKey = &pbTaskIdentifierKey;

@implementation NSURLSessionTask (PBHelper)
@dynamic pb_taskIdentifier;

- (NSString *)pb_taskIdentifier {
    return objc_getAssociatedObject(self, pbTaskIdentifierKey);
}

- (void)setPb_taskIdentifier:(NSString *)pb_taskIdentifier {
    objc_setAssociatedObject(self, pbTaskIdentifierKey, pb_taskIdentifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
