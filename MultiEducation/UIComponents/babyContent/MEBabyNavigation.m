//
//  MEBabyNavigation.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/16.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBabyNavigation.h"
#import "MEKits.h"

static CGFloat const ICON_HEIGHT = 20.f;

@interface MEBabyNavigation ()

@property (nonatomic, strong) NSString *urlStr;
@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) MEBaseScene *backView;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) MEBaseLabel *titleLabel;

@end

@implementation MEBabyNavigation

- (instancetype)initWithFrame:(CGRect)frame urlStr:(NSString *)url title:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.urlStr = url;
        self.title = title;
        [self customSubviews];
    }
    return self;
}

- (void)customSubviews {
    _backView = [[MEBaseScene alloc] init];
    _backView.backgroundColor = [UIColor clearColor];
    
    [self addSubview: _backView];
    [_backView addSubview: self.icon];
    [_backView addSubview: self.titleLabel];
    
    //layout
    CGFloat labelWidth = [_title sizeWithAttributes: [NSDictionary dictionaryWithObjectsAndKeys: UIFontPingFangSC(16), NSFontAttributeName, nil]].width;
    CGFloat space = 10.f;   //space between label and imageView
    CGFloat backViewWidth = labelWidth + ICON_HEIGHT + space;
    
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(ME_HEIGHT_NAVIGATIONBAR);
        make.top.mas_equalTo(self.mas_top).mas_offset([MEKits statusBarHeight]);
        make.width.mas_equalTo(backViewWidth);
        make.left.mas_equalTo((MESCREEN_WIDTH - backViewWidth) / 2);
    }];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(ICON_HEIGHT);
        make.left.mas_equalTo(_backView);
        make.centerY.mas_equalTo(_backView);
    }];
    
    [self.icon layoutIfNeeded];
    self.icon.layer.cornerRadius = ICON_HEIGHT / 2;
    self.icon.clipsToBounds = YES;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).mas_offset(space);
        make.width.mas_equalTo(labelWidth);
        make.height.mas_equalTo(ICON_HEIGHT);
        make.centerY.mas_equalTo(_backView);
    }];
}

- (void)changeTitle:(NSString *)babyName url:(NSString *)url {
    self.titleLabel.text = [NSString stringWithFormat: @"%@家长", babyName];
    [self.icon sd_setImageWithURL: [NSURL URLWithString: url] placeholderImage: [UIImage imageNamed: @"appicon_placeholder"]];
    
    CGFloat labelWidth = [self.titleLabel.text sizeWithAttributes: [NSDictionary dictionaryWithObjectsAndKeys: UIFontPingFangSC(16), NSFontAttributeName, nil]].width + 10;
    CGFloat space = 10.f;   //space between label and imageView
    CGFloat backViewWidth = labelWidth + ICON_HEIGHT + space;
    
    [_backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(ME_HEIGHT_NAVIGATIONBAR);
        make.top.mas_equalTo(self.mas_top).mas_offset([MEKits statusBarHeight]);
        make.width.mas_equalTo(backViewWidth);
        make.left.mas_equalTo((MESCREEN_WIDTH - backViewWidth) / 2);
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).mas_offset(space);
        make.width.mas_equalTo(labelWidth);
        make.height.mas_equalTo(ICON_HEIGHT);
        make.centerY.mas_equalTo(_backView);
    }];
}

#pragma mark - lazyloading
- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        [_icon sd_setImageWithURL: [NSURL URLWithString: self.urlStr] placeholderImage: [UIImage imageNamed: @"appicon_placeholder"]];
    }
    return _icon;
}

- (MEBaseLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[MEBaseLabel alloc] init];
        _titleLabel.font = UIFontPingFangSC(16);
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.text = _title;
    }
    return _titleLabel;
}

@end
