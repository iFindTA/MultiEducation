//
//  MEBaseButton.m
//  fsc-ios
//
//  Created by nanhu on 2018/4/11.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEBaseButton.h"

@implementation MEBaseButton

+ (id)buttonWithType:(UIButtonType)buttonType {
    MEBaseButton *btn = [super buttonWithType:buttonType];
    btn.exclusiveTouch = true;
    return btn;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.exclusiveTouch = true;
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
