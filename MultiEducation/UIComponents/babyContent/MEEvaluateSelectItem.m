//
//  MEEvaluateSelectItem.m
//  MultiEducation
//
//  Created by iketang_imac01 on 2018/4/14.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEEvaluateSelectItem.h"
#define item_height     80
#define title_font      14

@implementation MEEvaluateSelectItem
{
    UIImageView *_iconImageView;
    UIView *_titleBgView;
    MEBaseLabel *_titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, item_height, item_height)];
    iconImageView.backgroundColor = UIColorFromRGB(0xeeeeee);
    [self addSubview:iconImageView];
    _iconImageView = iconImageView;
    
    weakify(self);
    UIView *titleBgView = [[UIView alloc] init];
    titleBgView.backgroundColor = UIColorFromRGB(0xf8f8f8);
    [self addSubview:titleBgView];
    [titleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self);
        make.left.mas_equalTo(iconImageView.mas_right);
        make.top.mas_equalTo(iconImageView.mas_top);
        make.height.mas_equalTo(iconImageView.mas_height);
        make.right.mas_equalTo(self.mas_right);
    }];
    
    MEBaseLabel *titleLabel = [[MEBaseLabel alloc] init];
    titleLabel.textColor = UIColorFromRGB(0x333333);
    titleLabel.font = UIFontPingFangSC(title_font);
    [titleBgView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleBgView.left).with.offset(15);
        make.height.mas_equalTo(title_font);
        make.centerY.mas_equalTo(titleBgView.mas_centerY);
        make.right.mas_equalTo(titleBgView.mas_right);
    }];
}

- (void)setIsSelected:(BOOL)isSelected {
    if (_isSelected) {
        _iconImageView.backgroundColor = UIColorFromRGB(0x609ee1);
        _titleBgView.backgroundColor = UIColorFromRGB(0xcce2fa);
        _titleLabel.textColor = UIColorFromRGB(0x609ee1);
    } else {
        _iconImageView.backgroundColor = UIColorFromRGB(0xeeeeee);
        _titleBgView.backgroundColor = UIColorFromRGB(0xf8f8f8);
        _titleLabel.textColor = UIColorFromRGB(0x333333);
    }
}

@end
