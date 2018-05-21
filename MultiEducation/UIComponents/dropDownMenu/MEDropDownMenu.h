//
//  MEDropDownMenu.h
//  MultiEducation
//
//  Created by nanhu on 2018/5/21.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseScene.h"
#import "MEForwardEvaListVM.h"

typedef void(^MEForwardEvaCallback)(BOOL back);

@interface MEDropDownMenu : MEBaseScene

@property (nonatomic, copy) MEForwardEvaCallback callback;

/**
 class method for instance
 */
+ (instancetype)dropDownWithSuperView:(UIView *)view;

/**
 configure
 */
- (void)configureMenu:(ForwardEvaluateList *)list;

@end
