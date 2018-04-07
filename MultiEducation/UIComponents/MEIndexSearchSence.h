//
//  MEIndexSearchSence.h
//  MultiEducation
//
//  Created by nanhu on 2018/4/5.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseScene.h"

typedef void(^MESearchBlock)(void);

@interface MEIndexSearchSence : MEBaseScene

- (void)handleSearchBlock:(MESearchBlock)block;

@end
