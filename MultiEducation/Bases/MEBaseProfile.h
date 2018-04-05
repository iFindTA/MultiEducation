//
// Created by nanhu on 2018/4/3.
// Copyright (c) 2018 niuduo. All rights reserved.
//

#import <PBBaseClasses/PBBaseProfile.h>
#import "MEDispatcher.h"
#import "MEConstTypes.h"
#import <Masonry/Masonry.h>

@interface MEBaseProfile : PBBaseProfile

/**
 切换授权中心与主界面
 */
- (void)splash2ChangeDisplayStyle:(MEDisplayStyle)style;

@end
