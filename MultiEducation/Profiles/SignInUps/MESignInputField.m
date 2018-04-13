//
//  MESignInputField.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/13.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MESignInputField.h"

@implementation MESignInputField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (NSStringFromSelector(action) == @"paste:") {
        return false;
    }
    return [super canPerformAction:action withSender:sender];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
