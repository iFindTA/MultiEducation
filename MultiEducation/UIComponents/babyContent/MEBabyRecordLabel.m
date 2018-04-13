//
//  MEBabyRecordLabel.m
//  MultiEducation
//
//  Created by iketang_imac01 on 2018/4/13.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBabyRecordLabel.h"
#define label_distance      4

@implementation MEBabyRecordLabel
{
    UILabel *_contentLabel;
    UILabel *_titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame withContent:(NSString *)content withTitle:(NSString *)title withTextColor:(UIColor *)color {
    self = [super initWithFrame:frame];
    if (self) {
        [self createComLabelWithContent:content withTitle:title withTextColor:color withSuperView:self];
    }
    return self;
}


- (void)createComLabelWithContent:(NSString *)content withTitle:(NSString *)title withTextColor:(UIColor *)color withSuperView:(UIView *)view {
    CGFloat contentWidth = 0.0;

    UILabel *contentLabel = [[UILabel alloc] init];
    [self addSubview:contentLabel];
    contentLabel.textColor = color;
    contentLabel.text = content;
    contentLabel.font = UIFontPingFangSC(METHEME_FONT_TITLE);
    [contentLabel sizeToFit];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentWidth = contentLabel.frame.size.width;
    _contentLabel = contentLabel;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [self addSubview:titleLabel];
    titleLabel.textColor = color;
    titleLabel.text = title;
    titleLabel.font = UIFontPingFangSC(METHEME_FONT_SUBTITLE);
    [titleLabel sizeToFit];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    CGFloat top = (self.frame.size.height - (titleLabel.frame.size.height + contentLabel.frame.size.height + label_distance)) / 2;
    weakify(self);
    if (contentWidth < titleLabel.frame.size.width) {
        contentWidth = titleLabel.frame.size.width;
    }
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(top);
        make.width.mas_equalTo(contentWidth);
    }];
    _titleLabel = titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLabel.mas_bottom).with.offset(label_distance);
        make.centerX.mas_equalTo(contentLabel.mas_centerX);
    }];
}



@end
