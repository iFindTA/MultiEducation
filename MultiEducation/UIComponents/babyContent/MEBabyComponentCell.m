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
    switch (type) {
        case MEBabyContentTypeGrowth: {
            title = @"成长档案";
            subTitle = @"123张";
            backgroundColor = UIColorFromRGB(0xeca0a0);
            iconImage = [UIImage imageNamed: @"baby_content_growth"];
        }
            break;
        case MEBabyContentTypeEvaluate: {
            title = @"发展评价";
            subTitle = @"小班4月";
            backgroundColor = UIColorFromRGB(0x929cd8);
            iconImage = [UIImage imageNamed: @"baby_content_evaluate"];
        }
            break;
        case MEBabyContentTypeAnnounce: {
            title = @"园所公告";
            subTitle = @"开学典礼";
            backgroundColor = UIColorFromRGB(0xbc97d5);
            iconImage = [UIImage imageNamed: @"baby_content_growth"];
        }
            break;
        case MEBabyContentTypeSurvey: {
            title = @"问卷调查";
            subTitle = @"教师app体验";
            backgroundColor = UIColorFromRGB(0xdfc191);
            iconImage = [UIImage imageNamed: @"baby_content_growth"];
        }
            break;
        case MEBabyContentTypeRecipes: {
            title = @"每周食谱";
            subTitle = @"15周";
            backgroundColor = UIColorFromRGB(0xb1d899);
            iconImage = [UIImage imageNamed: @"baby_content_growth"];
        }
            break;
        case MEBabyContentTypeLive: {
            title = @"直播课堂";
            subTitle = @"123张";
            backgroundColor = UIColorFromRGB(0x717171);
            iconImage = [UIImage imageNamed: @"baby_content_growth"];
        }
            break;
        default:
            break;
    }
    
    self.titleLabel.text = title;
    self.subtitleLabel.text = subTitle;
    self.backView.backgroundColor = backgroundColor;
    self.icon.image = iconImage;
    
}

@end
