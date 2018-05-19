//
//  MEBaseScrollView.m
//  MultiEducation
//
//  Created by nanhu on 2018/5/19.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseScrollView.h"

@implementation MEBaseScrollView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
