//
//  MEInterestNotFound.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/5/23.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEInterestNotFound.h"

@interface MEInterestNotFound ()

@property (nonatomic, strong) MEBaseImageView *icon;
@property (nonatomic, strong) MEBaseLabel *tipLab;
@property (nonatomic, strong) MEBaseButton *submitButton;

@end

@implementation MEInterestNotFound

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview: self.icon];
        [self addSubview: self.tipLab];
        [self addSubview: self.submitButton];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //layout
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(140.f);
        make.height.mas_equalTo(125.f);
        make.top.mas_equalTo(self);
        make.centerX.mas_equalTo(self);
    }];
    
    [self.tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.icon.mas_bottom).mas_offset(23.f);
        make.width.mas_equalTo(self);
        make.height.mas_equalTo(18.f);
        make.centerX.mas_equalTo(self);
    }];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipLab.mas_bottom).mas_offset(33.f);
        make.height.mas_equalTo(44.f);
        make.width.mas_equalTo(200.f);
        make.centerX.mas_equalTo(self);
    }];
    
    [self.submitButton layoutIfNeeded];
    self.submitButton.layer.cornerRadius = self.submitButton.frame.size.height / 2;
    self.submitButton.layer.masksToBounds = true;
}

- (void)didSubmitInterestingPhotoTouchEvent {
    if (self.didSubmitCallback) {
        self.didSubmitCallback();
    }
}

#pragma mark - lazyloading
- (MEBaseImageView *)icon {
    if (!_icon) {
        _icon = [[MEBaseImageView alloc] initWithFrame: CGRectZero];
        _icon.image = [UIImage imageNamed: @"baby_interesting_not_found"];
//        _icon.contentMode = UIViewContentModeScaleAspectFill;
//        _icon.clipsToBounds = true;
    }
    return _icon;
}

- (MEBaseLabel *)tipLab {
    if (!_tipLab) {
        _tipLab = [[MEBaseLabel alloc] initWithFrame: CGRectZero];
        _tipLab.text = @"你还没有发布任何图片，快去发布吧！";
        _tipLab.textColor = UIColorFromRGB(0xCCCCCC);
        _tipLab.font = UIFontPingFangSC(13);
        _tipLab.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLab;
}

- (MEBaseButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [[MEBaseButton alloc] initWithFrame: CGRectZero];
        _submitButton.backgroundColor = UIColorFromRGB(0x609EE1);
        [_submitButton setTitle: @"拍照" forState: UIControlStateNormal];
        [_submitButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
        [_submitButton setImage: [UIImage pb_iconFont: nil withName: @"\U0000e670" withSize: 13 withColor: [UIColor whiteColor]] forState: UIControlStateNormal];
        [_submitButton setImageEdgeInsets: UIEdgeInsetsMake(0, -10, 0, 10)];
        [_submitButton setTitleEdgeInsets: UIEdgeInsetsMake(0, 10, 0, -10)];
        [_submitButton addTarget: self action: @selector(didSubmitInterestingPhotoTouchEvent) forControlEvents: UIControlEventTouchUpInside];
    }
    return _submitButton;
}


@end
