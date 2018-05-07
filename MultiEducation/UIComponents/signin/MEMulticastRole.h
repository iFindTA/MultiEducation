//
//  MEMulticastRole.h
//  MultiEducation
//
//  Created by nanhu on 2018/5/7.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseScene.h"

@class MEPBUser;
@interface MEMulticastRole : MEBaseScene

/**
 callback
 */
@property (nonatomic, copy) void(^callback)(MEPBUser *user);

/**
 init method
 */
- (id)initWithFrame:(CGRect)frame users:(NSArray<MEPBUser*>*)list;

@end
