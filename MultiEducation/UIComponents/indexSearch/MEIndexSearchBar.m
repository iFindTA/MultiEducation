//
//  MEIndexSearchBar.m
//  fsc-ios
//
//  Created by nanhu on 2018/4/10.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEIndexSearchBar.h"
#import "MESearchBar.h"

@interface MEIndexSearchBar ()<UISearchBarDelegate>
//是否为被动失去焦点 即不是点击取消按钮
@property (nonatomic, assign) BOOL isPassive;
@property (nonatomic, strong) MASConstraint *searchRightConstraint;

@end

@implementation MEIndexSearchBar

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setNeedsLayout];
    
    self.searchBar.delegate = self;
    
    CGFloat cancelSize = 50;
    [self.searchBar remakeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self);
        make.height.equalTo(ME_LAYOUT_SUBBAR_HEIGHT);
        make.right.equalTo(self).priority(UILayoutPriorityDefaultHigh);
        if (!self.searchRightConstraint) {
            self.searchRightConstraint = make.right.equalTo(self).offset(-cancelSize-20).priority(UILayoutPriorityRequired);
        }
    }];
    [self.searchRightConstraint deactivate];
    [self.cancelBtn remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.searchBar);
        make.left.equalTo(self.searchBar.mas_right).offset(5);
        make.width.equalTo(cancelSize);
        make.height.equalTo(ME_LAYOUT_SUBBAR_HEIGHT);
    }];
    
    //
    [self.searchBar changePlaceholder2Left:@"搜索故事、儿歌、唐诗"];
    [[UILabel appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (IBAction)cancelSearchTouchEvent:(UIButton *)sender {
    //如果取消的时候已经失去焦点 则不会回调endEnditing 需要在此主动调起回调
    BOOL shouldInitiativeCallback = self.isPassive;
    self.isPassive = false;
    [self.searchBar resignFirstResponder];
    [self updateSubviewsState:false];
    if (shouldInitiativeCallback) {
        if (self.callback) {
            self.callback(false);
        }
    }
}

- (void)updateSubviewsState:(BOOL)active {
    if (!self.isPassive) {
        active?[self.searchRightConstraint activate]:[self.searchRightConstraint deactivate];
        [UIView animateWithDuration:ME_ANIMATION_DURATION animations:^{
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)passive2ResignFirsetResponder {
    self.isPassive = true;
    [self.searchBar resignFirstResponder];
}

#pragma mark -- searchBar Delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    self.isPassive = false;
    [self updateSubviewsState:true];
    if (self.callback) {
        self.callback(true);
    }
    return true;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    if (self.isPassive) {
        return true;
    }
    
    [self updateSubviewsState:false];
    if (self.callback) {
        self.callback(false);
    }
    return true;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"点击键盘- 搜索按钮");
}

@end
