//
//  MECardCell.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/5/19.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MECardCell.h"

@implementation MECardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addShadow];
}

#pragma mark-添加阴影
- (void)addShadow {
    self.layer.shadowColor = UIColorFromRGB(0x878787).CGColor;
    self.layer.shadowOpacity = 0.6f;
    self.layer.shadowOffset = CGSizeMake(-3.0, 3.0f);
    self.layer.shadowRadius = 3.0f;
    self.layer.masksToBounds = NO;
}

@end
