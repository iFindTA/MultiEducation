//
//  MEGrowRecordProfile.m
//  fsc-ios
//
//  Created by iketang_imac01 on 2018/4/12.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEGrowRecordProfile.h"
#import "MEBabyFillBaseLabel.h"
#import "MEBabyBaseInfoCard.h"
#import "MEBabyOtherInfoCard.h"
#define card_distance                 10
#define card_left_width               30

@interface MEGrowRecordProfile ()
{
    UIScrollView *_babyScrollView;
    MEBabyBaseInfoCard *_fillBaseInfoView;
    MEBabyOtherInfoCard *_fillGrowInfoView;
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
    _babyScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(card_distance, contentHeight + 64, MESCREEN_WIDTH - card_distance, MESCREEN_HEIGHT - contentHeight * 2 - 64)];
    _babyScrollView.delegate = self;
    [self.view addSubview:_babyScrollView];
    CGFloat cardWidth = MESCREEN_WIDTH - card_distance * 2 - card_left_width - 20;
    _babyScrollView.contentSize = CGSizeMake(2 * cardWidth + card_distance + 10, _babyScrollView.frame.size.height);
    
    _fillBaseInfoView = [[MEBabyBaseInfoCard alloc] initWithFrame:CGRectMake(0, 1, cardWidth, _babyScrollView.frame.size.height - 2)];
    [_babyScrollView addSubview:_fillBaseInfoView];
    
    _fillGrowInfoView = [[MEBabyOtherInfoCard alloc] initWithFrame:CGRectMake(_fillBaseInfoView.frame.size.width + card_distance, 1, cardWidth, _babyScrollView.frame.size.height - 2)];
    [_babyScrollView addSubview:_fillGrowInfoView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}





@end
