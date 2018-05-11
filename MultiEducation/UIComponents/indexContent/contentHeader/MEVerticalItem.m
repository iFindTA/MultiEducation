//
//  MEVerticalItem.m
//  fsc-ios
//
//  Created by nanhu on 2018/4/11.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEVerticalItem.h"
#import "MEBaseLabel.h"
#import <UIImageView+WebCache.h>

@interface MEVerticalItem ()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) MEBaseLabel *label;

@end

@implementation MEVerticalItem

+ (instancetype)itemWithTitle:(NSString *)title imageURL:(NSString *)urlString {
    MEVerticalItem *item = [[MEVerticalItem alloc] initWithFrame:CGRectZero title:title imageURL:urlString];
    return item;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title imageURL:(NSString *)urlString {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.icon];
        [self addSubview:self.label];
        self.label.text = title.copy;
        [self.icon sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"appicon_placeholder"]];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat scale = 0.7;
    [self.icon makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(self.mas_height).multipliedBy(scale);
        make.height.equalTo(self.mas_height).multipliedBy(scale);
    }];
    [self.label makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.icon.mas_bottom).offset(ME_LAYOUT_MARGIN);
        make.left.bottom.right.equalTo(self);
    }];
}

#pragma mark --- lazy getter
- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _icon.userInteractionEnabled = true;
    }
    return _icon;
}

- (MEBaseLabel *)label {
    if (!_label) {
        _label = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
        _label.font = UIFontPingFangSC(METHEME_FONT_SUBTITLE);
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text = @"儿歌欣赏";
        _label.textColor = UIColorFromRGB(0x666666);
        _label.userInteractionEnabled = true;
    }
    return _label;
}

#pragma mark --- UITouch Event
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (self.MESubClassItemCallback) {
        self.MESubClassItemCallback(self.tag);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
