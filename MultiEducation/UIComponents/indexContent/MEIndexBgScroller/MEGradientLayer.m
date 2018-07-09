//
//  MEGradientLayer.m
//  MultiEducation
//
//  Created by nanhu on 2018/7/9.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEGradientLayer.h"

@interface MEGradientLayer ()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation MEGradientLayer

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CAGradientLayer *layer = [CAGradientLayer layer];
        layer.frame = self.bounds;
        layer.colors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor blackColor].CGColor];
        layer.opacity = 0.5;
        layer.startPoint = CGPointMake(0.5, 0);
        layer.endPoint = CGPointMake(0.5, 1);
        [self.layer insertSublayer:layer atIndex:0];
        _gradientLayer = layer;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _gradientLayer.frame = self.bounds;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
