//
//  MEMenuButton.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/25.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEMenuButton.h"

static CGFloat const ICON_WIDTH = 35.f;
static CGFloat const TEXT_LAB_HEIGHT = 16.f;

@implementation MEMenuButton

- (instancetype)initWithTouchHandler:(void(^)(void))handler {
    self = [super init];
    if (self) {
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(handler)];
        [self addGestureRecognizer: tapGes];
        
        [self addSubview: self.icon];
        [self addSubview: self.textLab];
        
        //layout
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(self);
            make.width.mas_equalTo(ICON_WIDTH);
            make.height.mas_equalTo(ICON_WIDTH);
        }];
        
        [self.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.top.mas_equalTo(self.icon.mas_bottom).mas_offset(5.f);
            make.height.mas_equalTo(TEXT_LAB_HEIGHT);
        }];
    }
    return self;
}

- (void)menuButtonTouchEvent {
    
}

#pragma mark - lazyloading

- (UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
    }
    return _icon;
}

- (MEBaseLabel *)textLab {
    if (!_textLab) {
        _textLab = [[MEBaseLabel alloc] init];
        _textLab.font = UIFontPingFangSC(11);
        _textLab.textAlignment = NSTextAlignmentCenter;
        _textLab.textColor = UIColorFromRGB(0x999999);
    }
    return _textLab;
}

@end
