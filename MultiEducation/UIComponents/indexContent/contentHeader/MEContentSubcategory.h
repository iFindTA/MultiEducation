//
//  MEContentSubcategory.h
//  fsc-ios
//
//  Created by nanhu on 2018/4/11.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEBaseScene.h"
#import "Meres.pbobjc.h"

@interface MEContentSubcategory : MEBaseScene

/**
 子分类回调
 */
@property (nonatomic, copy) void(^subClassesCallback)(NSUInteger tag);

/**
 init method
 */
- (instancetype)initWithFrame:(CGRect)frame classes:(NSArray<NSDictionary*>*)cls layoutType:(NSString *)type;

@end
