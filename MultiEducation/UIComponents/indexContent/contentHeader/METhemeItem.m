//
//  METhemeItem.m
//  MultiEducation
//
//  Created by nanhu on 2018/5/15.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "METhemeItem.h"

@interface METhemeItem ()

@property (nonatomic, assign, readwrite) METhemeLayout type;
@property (nonatomic, strong, readwrite) UIImageView *icon;
@property (nonatomic, strong, readwrite) MEBaseLabel *label;

@property (nonatomic, strong) MEBaseScene *layoutBg;

@end

@implementation METhemeItem

- (id)initWithType:(METhemeLayout)type {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)configureItemSubviews {
    [self addSubview:self.layoutBg];
    [self.layoutBg addSubview:self.icon];
    [self.layoutBg addSubview:self.label];
    self.label.text = self.title.copy;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:self.uri] placeholderImage:[UIImage imageNamed:@"appicon_placeholder"]];
    
    if (self.type == METhemeLayoutRect) {//方形
        [self.layoutBg makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.icon makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.layoutBg);
            make.centerX.equalTo(self.layoutBg.mas_centerX);
            make.width.lessThanOrEqualTo(self.layoutBg.mas_width).multipliedBy(0.8);
            make.height.lessThanOrEqualTo(self.icon.mas_width).multipliedBy(0.5);
        }];
        [self.label makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.icon.mas_bottom).offset(ME_LAYOUT_MARGIN*0.5);
            make.left.right.equalTo(self.layoutBg);
            make.bottom.equalTo(self.layoutBg);
        }];
    } else if (self.type == METhemeLayoutCircle) {//圆形
        [self.layoutBg makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.icon makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.layoutBg);
            make.centerX.equalTo(self.layoutBg.mas_centerX);
            make.width.lessThanOrEqualTo(self.layoutBg.mas_width).multipliedBy(0.8);
            make.height.lessThanOrEqualTo(self.icon.mas_width);
        }];
        [self.label makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.icon.mas_bottom).offset(ME_LAYOUT_MARGIN*0.5);
            make.left.right.equalTo(self.layoutBg);
            make.bottom.equalTo(self.layoutBg);
        }];
    } else if (self.type == METhemeLayoutLandscape) {//左右
        [self.layoutBg makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
            make.height.equalTo(self.layoutBg.mas_width).multipliedBy(0.5);
        }];
        [self.label makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.layoutBg.mas_centerX).offset(-ME_LAYOUT_MARGIN*0.5);
            make.centerY.equalTo(self.layoutBg.mas_centerY);
        }];
        [self.icon makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.layoutBg);
            make.width.equalTo(ME_LAYOUT_ICON_HEIGHT);
            make.right.equalTo(self.label.mas_left).offset(-ME_LAYOUT_MARGIN*0.5);
            make.height.lessThanOrEqualTo(self.icon.mas_width);
        }];
        
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark --- lazy getter
- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectZero];
        //_icon.backgroundColor = [UIColor pb_randomColor];
        _icon.contentMode = UIViewContentModeScaleAspectFit;
        _icon.userInteractionEnabled = true;
    }
    return _icon;
}

- (MEBaseLabel *)label {
    if (!_label) {
        UIFont *font;NSTextAlignment alignment;
        if (self.type == 3) {
            alignment = NSTextAlignmentLeft;
            font = UIFontPingFangSC(METHEME_FONT_TITLE);
        } else {
            alignment = NSTextAlignmentCenter;
            font = UIFontPingFangSC(METHEME_FONT_SUBTITLE-ME_LAYOUT_OFFSET);
        }
        _label = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
        //_label.backgroundColor = [UIColor pb_randomColor];
        _label.font = font;
        _label.textAlignment = alignment;
        _label.text = @"儿歌欣赏";
        _label.textColor = UIColorFromRGB(0x666666);
        _label.userInteractionEnabled = true;
    }
    return _label;
}

- (MEBaseScene *)layoutBg {
    if (!_layoutBg) {
        _layoutBg = [[MEBaseScene alloc] initWithFrame:CGRectZero];
        //_layoutBg.backgroundColor = [UIColor pb_randomColor];
    }
    return _layoutBg;
}

#pragma mark --- UITouch Event
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (self.callback) {
        self.callback(self.tag);
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
