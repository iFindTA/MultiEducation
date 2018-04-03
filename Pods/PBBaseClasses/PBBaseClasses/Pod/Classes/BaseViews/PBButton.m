//
//  PBButton.m
//  PBBaseClasses
//
//  Created by nanhujiaju on 2017/9/8.
//  Copyright © 2017年 nanhujiaju. All rights reserved.
//

#import "PBButton.h"

@implementation PBButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    PBButton *btn = [super buttonWithType:buttonType];
    if (btn) {
        btn.exclusiveTouch = true;
    }
    return btn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
