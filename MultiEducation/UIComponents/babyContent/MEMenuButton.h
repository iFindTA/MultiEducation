//
//  MEMenuButton.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/25.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseScene.h"

@interface MEMenuButton : MEBaseScene

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) MEBaseLabel *textLab;

- (instancetype)initWithTouchHandler:(void(^)(void))handler;

@end
