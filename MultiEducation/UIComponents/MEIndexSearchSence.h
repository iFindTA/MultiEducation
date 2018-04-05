//
//  MEIndexSearchSence.h
//  MultiEducation
//
//  Created by nanhu on 2018/4/5.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseSence.h"

typedef void(^MESearchBlock)(void);

@interface MEIndexSearchSence : MEBaseSence

- (void)handleSearchBlock:(MESearchBlock)block;

@end
