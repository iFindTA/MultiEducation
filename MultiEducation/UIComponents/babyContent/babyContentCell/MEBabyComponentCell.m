//
//  MEBabyComponentCell.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/13.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBabyComponentCell.h"

@implementation MEBabyComponentCell

- (void)setItemWithType:(MEBabyContentType)type {
    [self setComponentValueWithType: type];
}

- (void)setComponentValueWithType:(MEBabyContentType)type {
    NSString *title;
    NSString *subTitle;
    UIColor *backgroundColor;
    UIImage *iconImage;
    CGSize size;
    switch (type) {
        case MEBabyContentTypeGrowth: {
            title = @"成长档案";
            subTitle = @"幼儿成长过程中的记录";
            backgroundColor = UIColorFromRGB(0xeca0a0);
            iconImage = [UIImage imageNamed: @"baby_content_growth"];
            size = CGSizeMake(27, 22);
        }
            break;
        case MEBabyContentTypeEvaluate: {
            title = @"发展评价";
            subTitle = @"共同记录孩子的发展和进步";
            backgroundColor = UIColorFromRGB(0x929cd8);
            iconImage = [UIImage imageNamed: @"baby_content_evaluate"];
            size = CGSizeMake(20, 25);
        }
            break;
        case MEBabyContentTypeAnnounce: {
            title = @"园所公告";
            subTitle = @"掌握幼儿园的最新事项";
            backgroundColor = UIColorFromRGB(0xbc97d5);
            iconImage = [UIImage imageNamed: @"baby_content_announce"];
            size = CGSizeMake(24, 24);
        }
            break;
        case MEBabyContentTypeSurvey: {
            title = @"问卷调查";
            subTitle = @"反馈你对幼儿园的看法和建议";
            backgroundColor = UIColorFromRGB(0xdfc191);
            iconImage = [UIImage imageNamed: @"baby_content_survey"];
            size = CGSizeMake(20, 23);
        }
            break;
        case MEBabyContentTypeRecipes: {
            title = @"每周食谱";
            subTitle = @"成为最懂你孩子的营养师";
            backgroundColor = UIColorFromRGB(0xb1d899);
            iconImage = [UIImage imageNamed: @"baby_content_recipes"];
            size = CGSizeMake(26, 23);

        }
            break;
        case MEBabyContentTypeLive: {
            title = @"直播课堂";
            subTitle = @"随时随地了解宝宝的动态";
            backgroundColor = UIColorFromRGB(0x717171);
            iconImage = [UIImage imageNamed: @"baby_content_live"];
            size = CGSizeMake(26, 19);
        }
            break;
        default:
            break;
    }
    
    self.titleLabel.text = title;
    self.subtitleLabel.text = subTitle;
    self.backView.backgroundColor = backgroundColor;
    self.icon.image = iconImage;
    
    [self.icon mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(size);
    }];
}

@end
