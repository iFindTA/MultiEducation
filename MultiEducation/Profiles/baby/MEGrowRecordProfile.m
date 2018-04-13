//
//  MEGrowRecordProfile.m
//  fsc-ios
//
//  Created by iketang_imac01 on 2018/4/12.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEGrowRecordProfile.h"
#define card_distance                 10
#define card_left_width               30

@interface MEGrowRecordProfile ()
{
    UIScrollView *_babyScrollView;
    UIView *_fillBaseInfoView;
    UIView *_fillGrowInfoView;
}

@end

@implementation MEGrowRecordProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"成长";
    [self setBabyRecordView];
}

- (void)setBabyRecordView {
    float contentHeight = 72.0f;
    _babyScrollView = [[UIScrollView alloc] init];
    _babyScrollView.backgroundColor = UIColorFromRGB(0xf9fee2);
    [self.view addSubview:_babyScrollView];
    
    CGFloat cardWidth = MESCREEN_WIDTH - card_distance * 2 - card_left_width;
    weakify(self);
    [_babyScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self);
        make.left.mas_equalTo(card_distance);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-contentHeight);
        make.top.equalTo(self.view.mas_top).with.offset(contentHeight + 64);
    }];
    
    _babyScrollView.contentSize = CGSizeMake(2 * cardWidth + 10, _babyScrollView.frame.size.height);
    
    _fillBaseInfoView = [[UIView alloc] init];
    [_babyScrollView addSubview:_fillBaseInfoView];
    _fillBaseInfoView.backgroundColor = UIColorFromRGB(0xffffff);
    __block UIScrollView *babyScrollView = _babyScrollView;
    [_fillBaseInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(babyScrollView.mas_top);
        make.left.mas_equalTo(babyScrollView.mas_left);
        make.bottom.mas_equalTo(babyScrollView.mas_bottom);
        make.width.mas_equalTo(cardWidth);
    }];
    
    _fillGrowInfoView = [[UIView alloc] init];
    [_fillGrowInfoView addSubview:_fillBaseInfoView];
    _fillGrowInfoView.backgroundColor = UIColorFromRGB(0xffffff);
    __block UIScrollView *babyScrollView1 = _fillGrowInfoView;
    [_fillGrowInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(babyScrollView.mas_top);
        make.left.mas_equalTo(babyScrollView.mas_left);
        make.bottom.mas_equalTo(babyScrollView.mas_bottom);
        make.width.mas_equalTo(cardWidth);
    }];
}





@end
