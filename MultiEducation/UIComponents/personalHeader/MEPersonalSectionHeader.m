//
//  MEPersonalSectionHeader.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/16.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEPersonalSectionHeader.h"

@interface MEPersonalSectionHeader()

@property (nonatomic, strong) MEBaseLabel *textLabel;
@property (nonatomic, strong) MEBaseScene *sep; //分割线

@end

@implementation MEPersonalSectionHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview: self.textLabel];
        [self addSubview: self.sep];
        
        //layout
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).mas_offset(10);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(20);
            make.centerY.mas_equalTo(self);
        }];
        
        [self.sep mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.bottom.mas_equalTo(self);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

#pragma mark - lazyloading
- (MEBaseLabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[MEBaseLabel alloc] init];
        _textLabel.text = @"历史记录";
        _textLabel.font = UIFontPingFangSC(15);
        _textLabel.textAlignment = NSTextAlignmentLeft;
        _textLabel.textColor = [UIColor blackColor];
    }
    return _textLabel;
}

- (MEBaseScene *)sep {
    if (!_sep) {
        _sep = [[MEBaseScene alloc] init];
        _sep.backgroundColor = UIColorFromRGB(0xf9f9f9);
    }
    return _sep;
}



@end
