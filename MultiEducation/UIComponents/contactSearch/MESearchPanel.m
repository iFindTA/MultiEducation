//
//  MESearchPanel.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/24.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MESearchPanel.h"
#import "MESearchBar.h"

@interface MESearchPanel () <UISearchBarDelegate>

@property (nonatomic, strong, readwrite) MESearchBar *searchBar;
@property (nonatomic, strong) MEBaseButton *cancelBtn;
@property (nonatomic, strong) MASConstraint *searchRightConstraint;
//是否为被动失去焦点 即不是点击取消按钮
@property (nonatomic, assign) BOOL isPassive;

@end

@implementation MESearchPanel

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xF5F5F5);
        
        [self addSubview:self.searchBar];
        [self addSubview:self.cancelBtn];
        
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
            make.left.equalTo(self.searchBar.mas_right).offset(ME_LAYOUT_MARGIN);
            make.width.equalTo(cancelSize);
            make.height.equalTo(ME_LAYOUT_SUBBAR_HEIGHT);
        }];
        
        //
        [self.searchBar setPlaceholder:@"搜索联系人"];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark --- lazy loading

- (MESearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[MESearchBar alloc] initWithFrame:CGRectZero];
        _searchBar.delegate = self;
        _searchBar.tintColor = UIColorFromRGB(ME_THEME_COLOR_TEXT_GRAY);
        //设置背景图是为了去掉上下黑线
        _searchBar.backgroundImage = [[UIImage alloc] init];
        // 设置SearchBar的颜色主题为白色
        _searchBar.barTintColor = [UIColor whiteColor];
    }
    return _searchBar;
}

- (MEBaseButton *)cancelBtn {
    if (!_cancelBtn) {
        UIColor *textColor = UIColorFromRGB(ME_THEME_COLOR_VALUE);
        _cancelBtn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.titleLabel.font = UIFontPingFangSC(METHEME_FONT_TITLE);
        [_cancelBtn setTitleColor:textColor forState:UIControlStateNormal];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelSearchEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (void)cancelSearchEvent {
    //如果取消的时候已经失去焦点 则不会回调endEnditing 需要在此主动调起回调
    BOOL shouldInitiativeCallback = self.isPassive;
    self.isPassive = false;
    [self.searchBar resignFirstResponder];
    
}

- (void)updateLayoutConstraint:(BOOL)first {
    if (!self.isPassive) {
        first?[self.searchRightConstraint activate]:[self.searchRightConstraint deactivate];
        [UIView animateWithDuration:ME_ANIMATION_DURATION animations:^{
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark --- search bar delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    if (self.searchPanelFirstResponder) {
        self.searchPanelFirstResponder(true);
    }
    [self updateLayoutConstraint:true];
    return true;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    if (self.searchPanelFirstResponder) {
        self.searchPanelFirstResponder(false);
    }
    [self updateLayoutConstraint:false];
    return true;
}

@end
