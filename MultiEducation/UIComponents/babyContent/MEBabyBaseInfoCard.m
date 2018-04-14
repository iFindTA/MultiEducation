//
//  MEBabyBaseInfoCard.m
//  MultiEducation
//
//  Created by iketang_imac01 on 2018/4/13.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBabyBaseInfoCard.h"
#import "MEBabyRecordLabel.h"
#define header_raduis                       80
#define address_label_height                METHEME_FONT_SUBTITLE

@implementation MEBabyBaseInfoCard
{
    MEBaseLabel *_addressLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 2;
        self.layer.shadowColor = UIColorFromRGB(0xeeeeee).CGColor;
        self.layer.shadowOffset = CGSizeMake(2, 5);
        self.layer.shadowRadius = 5;
        [self setUI:frame];
    }
    return self;
}

- (void)setUI:(CGRect)frame {
    [self headerView];
    [self setAddressLabel];
    [self babyBaseInfoList];
}

- (void)headerView {
    CGFloat heightHeader = self.frame.size.height / 3;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, heightHeader)];
    [self addSubview:headerView];
    headerView.backgroundColor = UIColorFromRGB(0xeeeeee);
    
    UIImageView *headerImgView = [[UIImageView alloc] init];
    headerImgView.backgroundColor = UIColorFromRGB(0xffffff);
    headerImgView.layer.borderColor = UIColorFromRGB(0xeeeeee).CGColor;
    headerImgView.layer.borderWidth = 1.5;
    headerImgView.layer.cornerRadius = header_raduis / 2;
    headerImgView.layer.masksToBounds = YES;
    [headerView addSubview:headerImgView];
    [headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headerView.mas_centerX);
        make.top.mas_equalTo(24);
        make.width.mas_equalTo(header_raduis);
        make.height.mas_equalTo(header_raduis);
    }];
    
    CGFloat labelWidth = (headerView.frame.size.width - header_raduis) / 2;
    
    
    MEBabyRecordLabel *sexView = [[MEBabyRecordLabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, header_raduis) withContent:@"男" withTitle:@"性别" withTextColor:UIColorFromRGB(0xffffff)];;
    [headerView addSubview:sexView];
    [sexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerView.mas_left);
        make.centerY.mas_equalTo(headerImgView.mas_centerY);
        make.height.mas_equalTo(header_raduis);
        make.width.mas_equalTo(labelWidth);
    }];
    
    MEBabyRecordLabel *ageView = [[MEBabyRecordLabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, header_raduis) withContent:@"2018/8" withTitle:@"生日" withTextColor:UIColorFromRGB(0xffffff)];;
    [headerView addSubview:ageView];
    [ageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headerImgView.mas_centerY);
        make.left.mas_equalTo(headerImgView.mas_right);
        make.height.mas_equalTo(header_raduis);
        make.width.mas_equalTo(labelWidth);
    }];
     
    MEBabyRecordLabel *personInfoView = [[MEBabyRecordLabel alloc] initWithFrame:CGRectMake(0, 0, headerView.frame.size.width, header_raduis) withContent:@"钱多多" withTitle:@"63462387378287276" withTextColor:UIColorFromRGB(0xffffff)];;
    [headerView addSubview:personInfoView];
    [personInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headerImgView.mas_centerX);
        make.width.mas_equalTo(headerView.mas_width);
        make.top.mas_equalTo(headerImgView.mas_bottom);
        make.bottom.mas_equalTo(headerView.mas_bottom);
    }];
    
}

- (void)setAddressLabel {
    MEBaseLabel *addressLabel = [[MEBaseLabel alloc] init];
    addressLabel.text = @"gweghdjkehudidslksakojedsdaf";
    addressLabel.font = UIFontPingFangSC(METHEME_FONT_SUBTITLE);
    addressLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:addressLabel];
    _addressLabel = addressLabel;
    weakify(self);
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self);
        make.width.mas_equalTo(self.mas_width);
        make.bottom.equalTo(self.mas_bottom).with.offset(-20);
        make.height.mas_equalTo(address_label_height);
    }];
}

- (void)babyBaseInfoList {
    
    CGFloat startX = 0;
    CGFloat startY = self.frame.size.height / 3;
    CGFloat width = self.frame.size.width / 3;
    CGFloat height = (self.frame.size.height - startY - address_label_height - 10)/ 3;
    
    
    NSArray *contentArr = @[@"eawerw",@"jfrehwiu",@"jfrehwiu",@"eawerw",@"jfrehwiu",@"eawerw",@"jfrehwiu",@"hdsyh",@"hdsyh"];
    NSArray *titleArr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    
    int countLine = 0;
    int countList = 0;
    for (int i = 0; i < contentArr.count; i++) {
        MEBabyRecordLabel *infoView = [[MEBabyRecordLabel alloc] initWithFrame:CGRectMake(0, 0, width, height) withContent:[contentArr objectAtIndex:i]    withTitle:[titleArr objectAtIndex:i] withTextColor:UIColorFromRGB(0x000000)];;
        [self addSubview:infoView];
        [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(startX + countList * width);
            make.top.mas_equalTo(startY + countLine * height);
            make.height.mas_equalTo(height);
            make.width.mas_equalTo(width);
        }];
        countList ++;
        if (countList >= 3) {
            countList = 0;
            countLine++;
        }
    }
}


@end
