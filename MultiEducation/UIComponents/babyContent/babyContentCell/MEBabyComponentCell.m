//
//  MEBabyComponentCell.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/13.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBabyComponentCell.h"
#import "MEKits.h"

@implementation MEBabyComponentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.badageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8.f);
        make.right.mas_equalTo(-8.f);
        make.width.height.mas_equalTo(10.f);
    }];
    self.badageLab.hidden = YES;
}

- (void)setItemWithType:(MEBabyContentType)type badge:(NSInteger)badge {
    NSString *title;
    NSString *subTitle;
    UIColor *backgroundColor;
    UIImage *iconImage;
    CGSize size;
    [self setbadgeValueProperty: badge];
    switch (type) {
        case MEBabyContentTypeGrowth: {
            title = @"成长档案";
            subTitle = @"客观记录 成长可见";
            backgroundColor = UIColorFromRGB(0xeca0a0);
            iconImage = [UIImage imageNamed: @"baby_content_growth"];
            size = CGSizeMake(27, 22);
        }
            break;
        case MEBabyContentTypeEvaluate: {
            title = @"发展评价";
            subTitle = @"科学评价 促进发展";
            backgroundColor = UIColorFromRGB(0x929cd8);
            iconImage = [UIImage imageNamed: @"baby_content_evaluate"];
            size = CGSizeMake(20, 25);
        }
            break;
        case MEBabyContentTypeAnnounce: {
            title = @"园所公告";
            subTitle = @"精准送达 温馨提醒";
            backgroundColor = UIColorFromRGB(0xbc97d5);
            iconImage = [UIImage imageNamed: @"baby_content_announce"];
            size = CGSizeMake(24, 24);
        }
            break;
        case MEBabyContentTypeSurvey: {
            title = @"问卷调查";
            subTitle = @"搜集意见 倾听反馈";
            backgroundColor = UIColorFromRGB(0xdfc191);
            iconImage = [UIImage imageNamed: @"baby_content_survey"];
            size = CGSizeMake(20, 23);
        }
            break;
        case MEBabyContentTypeRecipes: {
            title = @"每周食谱";
            subTitle = @"营养均衡 健康成长";
            backgroundColor = UIColorFromRGB(0xb1d899);
            iconImage = [UIImage imageNamed: @"baby_content_recipes"];
            size = CGSizeMake(26, 23);
        }
            break;
        case MEBabyContentTypeLive: {
            title = @"直播课堂";
            subTitle = @"课堂动态 精彩瞬间";
            backgroundColor = UIColorFromRGB(0x717171);
            iconImage = [UIImage imageNamed: @"baby_content_live"];
            size = CGSizeMake(26, 19);
        }
            break;
        default:
            break;
    }
    
    if (MESCREEN_WIDTH == 320.f) {
        self.subtitleLabel.font = UIFontPingFangSC(10);
    } else {
        self.subtitleLabel.font = UIFontPingFangSC(13);
    }
    
    self.titleLabel.text = title;
    self.subtitleLabel.text = subTitle;
    self.backView.backgroundColor = backgroundColor;
    self.icon.image = iconImage;
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.backView.mas_right).mas_offset(-12.f);
        make.bottom.mas_equalTo(self.backView.mas_bottom).mas_offset(-12.f);
        make.width.mas_equalTo(size.width);
        make.height.mas_equalTo(size.height);
    }];
}

- (void)setbadgeValueProperty:(NSInteger)badge {
    CGFloat badgeDiam;
    if (badge == 0) {
        self.badageLab.hidden = YES;
    } else {
        if (badge == 1) {
            badgeDiam = 10.f;
            self.badageLab.text = @"";
        } else {
            badgeDiam = 14.f;
            self.badageLab.text = [NSString stringWithFormat: @"%ld", badge];
        }
        [self.badageLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(badgeDiam);
        }];
        [self.badageLab.superview layoutIfNeeded];
        self.badageLab.hidden = NO;
        self.badageLab.layer.cornerRadius = badgeDiam / 2;
    }
}


@end
