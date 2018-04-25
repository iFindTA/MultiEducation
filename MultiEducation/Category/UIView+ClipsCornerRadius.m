//
//  UIView+ClipsCornerRadius.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/25.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "UIView+ClipsCornerRadius.h"

@implementation UIView (ClipsCornerRadius)

- (void)clipsCorner:(UIRectCorner)corner cornerRadii:(CGSize)size {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii: size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = self.bounds;
    maskLayer.path = path.CGPath;
    self.layer.mask = maskLayer;
}

@end
