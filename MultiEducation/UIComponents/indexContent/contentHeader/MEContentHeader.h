//
//  MEContentHeader.h
//  fsc-ios
//
//  Created by nanhu on 2018/4/11.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEBaseScene.h"

@interface MEContentHeader : MEBaseScene

/**
 大致预估头部的高度
 */
//+ (CGFloat)calculateHeaderHeight4MapInfo:(NSDictionary *)map;

/**
 类方法加载
 */
+ (instancetype)headerWithLayoutInfo:(NSDictionary *)info;

@end
