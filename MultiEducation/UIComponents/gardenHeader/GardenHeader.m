//
//  GardenHeader.m
//  fsc-ios-wan
//
//  Created by 崔小舟 on 2018/4/10.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "GardenHeader.h"

@implementation GardenHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    //layout content button
    CGFloat leftSpace = 14.f;   //to self.view.left
    CGFloat topSpace = 7.f;    //to self.view.top
    CGFloat btnWidth = 60.f;    //btn width
    CGFloat betSpace = (MESCREEN_WIDTH - 20 - leftSpace * 2 - 4 * btnWidth) / 3; //两个btn间距
    
    __weak typeof(self) weakSelf = self;
    [self.gardenAnnounceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentBackView.mas_left).mas_offset(leftSpace);
        make.width.height.mas_equalTo(btnWidth);
        make.top.mas_equalTo(weakSelf.contentBackView.mas_top).mas_offset(topSpace);
    }];
    
    [self.surveyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.gardenAnnounceBtn.mas_right).mas_offset(betSpace);
        make.width.height.mas_equalTo(btnWidth);
        make.top.mas_equalTo(weakSelf.contentBackView.mas_top).mas_offset(topSpace);
    }];
    
    [self.recipesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(weakSelf.surveyBtn.mas_right).mas_offset(betSpace);
        make.width.height.mas_equalTo(btnWidth);
        make.top.mas_equalTo(weakSelf.contentBackView.mas_top).mas_offset(topSpace);
    }];
    
    [self.classLiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.recipesBtn.mas_right).mas_offset(betSpace);
        make.width.height.mas_equalTo(btnWidth);
        make.top.mas_equalTo(weakSelf.contentBackView.mas_top).mas_offset(topSpace);
    }];
    
}


- (IBAction)cameraTouchEvent:(MEBaseButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector: @selector(didTouchCamera)]) {
        [self.delegate didTouchCamera];
    }
}

- (IBAction)gardenAnnounceTouchEvent:(MEBaseButton *)sender {
    [self callbackDelegateWithType: MEGardenHeaderTypeAnnounce];
}

- (IBAction)surveyTouchEvent:(MEBaseButton *)sender {
    [self callbackDelegateWithType: MEGardenHeaderTypeSurvey];
}

- (IBAction)recipesTouchEvent:(MEBaseButton *)sender {
    [self callbackDelegateWithType: MEGardenHeaderTypeRecipes];
}

- (IBAction)classLiveTouchEvent:(MEBaseButton *)sender {
    [self callbackDelegateWithType: MEGardenHeaderTypeLive];
}

- (void)callbackDelegateWithType:(MEGardenHeaderType)type {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchGardenHeaderType:)]) {
        [self.delegate didTouchGardenHeaderType: type];
    }
}

- (void)contentAnimationWithPercent:(CGFloat)percent direction:(METableViewScrollDirection)direction {
    
    self.contentBackView.alpha = 1 - percent * 2;

}


@end
