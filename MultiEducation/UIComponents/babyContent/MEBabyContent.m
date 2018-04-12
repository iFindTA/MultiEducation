//
//  MEChatContent.m
//  fsc-ios-wan
//
//  Created by 崔小舟 on 2018/4/10.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEBabyContent.h"
#import "UIView+Frame.h"

@implementation MEBabyContent

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    UIView *babyPhotoView = [self createContentView: MEBabyContentTypeBabyPhoto title: @"宝宝相册" subTitle: @"77张"];
    [self addSubview: babyPhotoView];
    UIView *beautyDayView = [self createContentView: MEBabyContentTypeBeautyDay title: @"一日精彩" subTitle: @"记录每个瞬间"];
    [self addSubview: beautyDayView];
    UIView *growthView = [self createContentView: MEBabyContentTypeGrowth title: @"成长档案" subTitle: @"小班上"];
    [self addSubview: growthView];
    UIView *evaluateView = [self createContentView: MEBabyContentTypeEvaluate title: @"发展评价" subTitle: @"小班四月"];
    [self addSubview: evaluateView];
    UIView *inviteView = [self createContentView: MEBabyContentTypeInvite title: @"邀请家人" subTitle: @"邀请有礼"];
    [self addSubview: inviteView];
    
    //contentView width and height
    CGFloat contentWidth = (MESCREEN_WIDTH - 28) / 2;
    CGFloat contentHeight = 104;
    
    //layout
    [babyPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(10);
        make.top.mas_equalTo(self.mas_top).mas_offset(10);
        make.width.mas_equalTo(contentWidth);
        make.height.mas_equalTo(contentHeight);
    }];
    
    [beautyDayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(babyPhotoView.mas_right).mas_offset(8);
        make.top.mas_equalTo(self.mas_top).mas_offset(10);
        make.width.mas_equalTo(contentWidth);
        make.height.mas_equalTo(contentHeight);
    }];
    
    //reset contentView width and height
    contentWidth = (MESCREEN_WIDTH - 36) / 3;
    contentHeight = 113;
    
    [growthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(10);
        make.top.mas_equalTo(babyPhotoView.mas_bottom).mas_offset(10);
        make.width.mas_equalTo(contentWidth);
        make.height.mas_equalTo(contentHeight);
    }];
    
    [evaluateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(growthView.mas_right).mas_offset(8);
        make.top.mas_equalTo(babyPhotoView.mas_bottom).mas_offset(10);
        make.width.mas_equalTo(contentWidth);
        make.height.mas_equalTo(contentHeight);
    }];
    
    [inviteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(evaluateView.mas_right).mas_offset(8);
        make.top.mas_equalTo(babyPhotoView.mas_bottom).mas_offset(10);
        make.width.mas_equalTo(contentWidth);
        make.height.mas_equalTo(contentHeight);
    }];
    
}

- (UIView *)createContentView:(MEBabyContentType)type title:(NSString *)title subTitle:(NSString *)subTitle {
    
    UIColor *contentBackgroundColor;
    NSString *imageName;
    CGSize imageSize;
    switch (type) {
        case MEBabyContentTypeBabyPhoto: {
            contentBackgroundColor = UIColorFromRGB(0xE78B8B);
            imageName = @"baby_content_photo";
            imageSize = CGSizeMake(28, 22);
        }
            break;
        case MEBabyContentTypeBeautyDay: {
            contentBackgroundColor = UIColorFromRGB(0x8F9BE6);
            imageName = @"baby_content_beauty_day";
            imageSize = CGSizeMake(26, 21);
        }
            break;
        case MEBabyContentTypeGrowth: {
            contentBackgroundColor = UIColorFromRGB(0xB0D996);
            imageName = @"baby_content_growth";
            imageSize = CGSizeMake(27, 22);
        }
            break;
        case MEBabyContentTypeEvaluate: {
            contentBackgroundColor = UIColorFromRGB(0xDFC191);
            imageName = @"baby_content_evaluate";
            imageSize = CGSizeMake(20, 25);
        }
            break;
        case MEBabyContentTypeInvite: {
            contentBackgroundColor = UIColorFromRGB(0xBC97D5);
            imageName = @"baby_content_invite";
            imageSize = CGSizeMake(26, 26);
        }
        default:
            break;
    }
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = contentBackgroundColor;
    contentView.userInteractionEnabled = YES;
    contentView.layer.cornerRadius = 2.f;
    contentView.clipsToBounds = YES;
    contentView.tag = type;
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(babyContentTapEvent:)];
    [contentView addGestureRecognizer: tapGes];
    
    
    MEBaseLabel *nameLab = [[MEBaseLabel alloc] init];
    nameLab.text = title;
    nameLab.textColor = [UIColor whiteColor];
    nameLab.font = UIFontPingFangSC(14);
    nameLab.textAlignment = NSTextAlignmentLeft;
    [contentView addSubview: nameLab];
    
    MEBaseLabel *tipLab = [[MEBaseLabel alloc] init];
    tipLab.text = subTitle;
    tipLab.textColor = [UIColor whiteColor];
    tipLab.font = UIFontPingFangSC(12);
    tipLab.textAlignment = NSTextAlignmentLeft;
    [contentView addSubview: tipLab];
    
    UIImageView *icon = [[UIImageView alloc] init];
    icon.image = [UIImage imageNamed: imageName];
    [contentView addSubview: icon];
    
    //layout
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentView.mas_left).offset(11);
        make.top.mas_equalTo(contentView.mas_top).offset(16);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(20);
    }];
    
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentView.mas_left).offset(11);
        make.top.mas_equalTo(nameLab.mas_bottom).offset(4);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(17);
    }];
    
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(contentView.mas_right).offset(-15);
        make.bottom.mas_equalTo(contentView.mas_bottom).offset(-12);
        make.width.mas_equalTo(imageSize.width);
        make.height.mas_equalTo(imageSize.height);
    }];
    
    return contentView;
}

- (void)babyContentTapEvent:(UITapGestureRecognizer *)ges {
    MEBabyContentType type = [ges view].tag;
    if (self.delegate && [self.delegate respondsToSelector: @selector( didTouchBabyContentType:)]) {
        [self.delegate didTouchBabyContentType: type];
    }
}

@end
