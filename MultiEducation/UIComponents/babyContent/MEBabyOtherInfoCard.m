//
//  MEBabyOtherInfoCard.m
//  MultiEducation
//
//  Created by iketang_imac01 on 2018/4/13.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBabyOtherInfoCard.h"
#define left_distance   28

@implementation MEBabyOtherInfoCard
{
    CGFloat _cardHeight;
    MEBaseLabel *_farInfoLabel;
    MEBaseLabel *_farCompanyLabel;
    MEBaseLabel *_momInfoLabel;
    MEBaseLabel *_momCompanyLabel;
}

typedef NS_ENUM(NSUInteger, MEBabyOtherInfoCardType) {
    MEBabyOtherInfoCardTypeFar                                     =   1   <<  0,//宝宝爸
    MEBabyOtherInfoCardTypeMom                                     =   1   <<  1,//宝宝妈
};

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        self.layer.cornerRadius = 2;
        self.layer.shadowColor = UIColorFromRGB(0xeeeeee).CGColor;
        self.layer.shadowOffset = CGSizeMake(2, 5);
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = .5;
        [self setUI:frame];
    }
    return self;
}

- (void)setUI:(CGRect)frame {
    [self relativeInfoCardWith:MEBabyOtherInfoCardTypeFar withName:@"牛不的热" withPhone:@"1565377726" withCompany:@"国会大厦酒后驾驶的" withTop:left_distance];
    [self relativeInfoCardWith:MEBabyOtherInfoCardTypeMom withName:@"牛不的热" withPhone:@"1565377726" withCompany:@"国会大厦酒后驾驶的" withTop:left_distance];
    
    MEBaseButton *editBtn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn setTitleColor:UIColorFromRGB(0xcccccc) forState:UIControlStateNormal];
    editBtn.titleLabel.font = UIFontPingFangSC(METHEME_FONT_SUBTITLE);
    [editBtn sizeToFit];
    [self addSubview:editBtn];
    weakify(self);
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(self.mas_right);
        make.width.mas_equalTo(editBtn.frame.size.width + 20);
    }];
    
    MEBaseLabel *warnLabel = [[MEBaseLabel alloc] init];
    warnLabel.text = @"注意事项";
    warnLabel.font = UIFontPingFangSCBold(METHEME_FONT_TITLE);
    warnLabel.textColor = UIColorFromRGB(0xc42828);
    [self addSubview:warnLabel];
    [warnLabel sizeToFit];
    __block MEBaseLabel *momCopLabel = _momCompanyLabel;
    [warnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(momCopLabel.mas_left);
        make.top.equalTo(momCopLabel.mas_bottom).with.offset(left_distance * 2);
    }];
    
    MEBaseLabel *warnContentLabel = [[MEBaseLabel alloc] init];
    warnContentLabel.text = @"yhghdsgahsdjaj";
    warnContentLabel.font = UIFontPingFangSC(METHEME_FONT_SUBTITLE);
    warnContentLabel.textColor = UIColorFromRGB(0x284e6c);
    [self addSubview:warnContentLabel];
    [warnContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(warnLabel.mas_left);
        make.top.equalTo(warnLabel.mas_bottom).with.offset(left_distance);
    }];
}

- (void)relativeInfoCardWith:(MEBabyOtherInfoCardType)type withName:(NSString *)name withPhone:(NSString *)phone withCompany:(NSString *)company withTop:(CGFloat)top {
    MEBaseLabel *titleLabel = [[MEBaseLabel alloc] init];
    titleLabel.font = UIFontPingFangSCBold(METHEME_FONT_TITLE);
    titleLabel.textColor = UIColorFromRGB(ME_THEME_COLOR_VALUE);
    
    MEBaseLabel *infoLabel = [[MEBaseLabel alloc] init];
    infoLabel.text = [NSString stringWithFormat:@"%@ | %@",name,phone];
    infoLabel.font = UIFontPingFangSC(METHEME_FONT_SUBTITLE);
    infoLabel.textColor = UIColorFromRGB(0x284e6c);
    
    
    MEBaseLabel *companyLabel = [[MEBaseLabel alloc] init];
    companyLabel.text = company;
    companyLabel.font = UIFontPingFangSC(METHEME_FONT_SUBTITLE);
    companyLabel.textColor = UIColorFromRGB(0x284e6c);
    
    
    if (type == MEBabyOtherInfoCardTypeFar) {
        titleLabel.text = @"爸爸信息";
        _farInfoLabel = infoLabel;
        _farCompanyLabel = companyLabel;
    } else if (type == MEBabyOtherInfoCardTypeMom) {
        titleLabel.text = @"妈妈信息";
        _momInfoLabel = infoLabel;
        _momCompanyLabel = companyLabel;
    }
    
    [titleLabel sizeToFit];
    [infoLabel sizeToFit];
    [companyLabel sizeToFit];
    
    UIView *cardBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width - left_distance, titleLabel.frame.size.height + infoLabel.frame.size.height + companyLabel.frame.size.height + 2 * left_distance - 5)];
    [self addSubview:cardBg];
    
    [cardBg addSubview:titleLabel];
    [cardBg addSubview:infoLabel];
    [cardBg addSubview:companyLabel];
    
    if (type == MEBabyOtherInfoCardTypeFar) {
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(left_distance);
            make.top.mas_equalTo(top);
        }];
    } else {
        __block MEBaseLabel *farCompanyLabel = _farCompanyLabel;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(left_distance);
            make.top.equalTo(farCompanyLabel.mas_bottom).offset(left_distance * 2);
        }];
    }
    
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left_distance);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(left_distance);
    }];
    [companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left_distance);
        make.top.equalTo(infoLabel.mas_bottom).with.offset(left_distance - 5);
    }];
}

@end
