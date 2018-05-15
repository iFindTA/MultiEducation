//
//  METhemeItem.m
//  MultiEducation
//
//  Created by nanhu on 2018/5/15.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "METhemeItem.h"

@interface METhemeItem ()

@property (nonatomic, copy, readwrite) NSString *type;
@property (nonatomic, strong, readwrite) UIImageView *icon;
@property (nonatomic, strong, readwrite) MEBaseLabel *label;

@end

@implementation METhemeItem

- (id)initWithType:(NSString *)type {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.type = type;
        //self.backgroundColor = [UIColor pb_randomColor];
    }
    return self;
}

- (void)configureItemSubviews {
    [self addSubview:self.icon];
    [self addSubview:self.label];
    self.label.text = self.title.copy;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:self.uri] placeholderImage:[UIImage imageNamed:@"appicon_placeholder"]];
    
    [self.icon makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(ME_LAYOUT_MARGIN);
        make.right.equalTo(self).offset(-ME_LAYOUT_MARGIN);
        make.height.equalTo(self.icon.mas_width);
    }];
    [self.label makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.icon.mas_bottom).offset(ME_LAYOUT_MARGIN);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
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
        _label = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
        //_label.backgroundColor = [UIColor pb_randomColor];
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
