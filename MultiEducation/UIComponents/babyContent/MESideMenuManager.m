//
//  MEMenuManager.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/25.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MESideMenuManager.h"
#import "MESideHideenMenu.h"

static CGFloat const HIDEVIEW_WIDTH = 26.f;
static CGFloat const HIDEVIEW_HEIGHT = 100.f;
static CGFloat const SHOWVIEW_WIDTH = 54.f;
static CGFloat const SHOWVIEW_HEIGHT = 305.f;

static CGFloat const MAX_TIME = 4;  //4s后对操作列表无任何操作，自动返回hideMenu

@interface MESideMenuManager () {
    NSInteger _count;   //用来计数判断是否要隐藏showMenu视图
}

@property (nonatomic, weak) UIView *superView;

@property (nonatomic, strong) MESideHideenMenu *hideMenu;
@property (nonatomic, strong) MESideShowMenu *showMenu;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, copy) void(^sideMenuCallback)(MEUserTouchEventType type);
@property (nonatomic, copy) void(^operationMenuCallback)(void);

@end

@implementation MESideMenuManager

- (instancetype)initWithMenuSuperView:(UIView *)view sideMenuCallback:(void(^)(MEUserTouchEventType type))sideMenuCallback operationMenuCallback:(void(^)(void))operationMenuCallback {
    if (self = [super init]) {
        self.sideMenuCallback = sideMenuCallback;
        self.operationMenuCallback = operationMenuCallback;
        _count = MAX_TIME;
        _superView = view;
        [view addSubview: self.hideMenu];
        [view addSubview: self.showMenu];
        
        //layout
        [self.hideMenu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_superView.mas_right);
            make.width.mas_equalTo(HIDEVIEW_WIDTH);
            make.height.mas_equalTo(HIDEVIEW_HEIGHT);
            make.centerY.mas_equalTo(_superView);
        }];
        
        [self.showMenu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_superView.mas_right).mas_offset(SHOWVIEW_WIDTH);
            make.width.mas_equalTo(SHOWVIEW_WIDTH);
            make.height.mas_equalTo(SHOWVIEW_HEIGHT);
            make.centerY.mas_equalTo(_superView);
        }];
        
    }
    return self;
}

- (void)dealloc {
    [self timerStop];
}

- (void)timerStart {
    _count = MAX_TIME;
    _timer = [NSTimer scheduledTimerWithTimeInterval: 1.f target: self selector: @selector(timerRun) userInfo: nil repeats: YES];
    [_timer setFireDate: [NSDate date]];
}

- (void)timerRun {
    if (_count <= 0) {
        _count = MAX_TIME;
        [self animationWithTouch: MEUSERTouchMenuTypeShowMenu];
    } else {
        _count--;
    }
}

- (void)timerStop {
    [_timer invalidate];
    _timer = nil;
    _count = MAX_TIME;
}

- (void)animationWithTouch:(MEUSERTouchMenuType)type {
    if (type == MEUSERTouchMenuTypeHideMenu) {
        [self timerStart];
    } else {
        [self timerStop];
    }
    [self.hideMenu setNeedsUpdateConstraints];
    [self.showMenu setNeedsUpdateConstraints];

    if (type == MEUSERTouchMenuTypeHideMenu) {
        weakify(self);
        [UIView animateWithDuration:ME_ANIMATION_DURATION delay:0 options: UIViewAnimationOptionCurveEaseInOut animations:^{
            strongify(self);
            [self.hideMenu mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(_superView).mas_offset(HIDEVIEW_WIDTH);
            }];
            [self.hideMenu.superview layoutIfNeeded];
        } completion: nil];
        
        [UIView animateWithDuration: ME_ANIMATION_DURATION delay: ME_ANIMATION_DURATION options: UIViewAnimationOptionCurveEaseInOut animations:^{
            strongify(self);
            [self.showMenu mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(_superView.mas_right);
            }];
            [self.showMenu.superview layoutIfNeeded];
        } completion: nil];
        
    } else {
        weakify(self);
        [UIView animateWithDuration: ME_ANIMATION_DURATION delay: ME_ANIMATION_DURATION options: UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.showMenu mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(_superView).mas_offset(SHOWVIEW_WIDTH);
            }];
            [self.showMenu.superview layoutIfNeeded];
        } completion: nil];
        
        [UIView animateWithDuration: ME_ANIMATION_DURATION delay: ME_ANIMATION_DURATION options: UIViewAnimationOptionCurveEaseInOut animations:^{
            strongify(self);
            [self.hideMenu mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(_superView);
            }];
            [self.hideMenu.superview layoutIfNeeded];
        } completion: nil];
    }
}

- (void)hideSideMenuManager {
    [self.hideMenu mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_superView.mas_right).mas_offset(HIDEVIEW_WIDTH);
        make.width.mas_equalTo(HIDEVIEW_WIDTH);
        make.height.mas_equalTo(HIDEVIEW_HEIGHT);
        make.centerY.mas_equalTo(_superView);
    }];
    
    [self.showMenu mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_superView.mas_right).mas_offset(SHOWVIEW_WIDTH);
        make.width.mas_equalTo(SHOWVIEW_WIDTH);
        make.height.mas_equalTo(SHOWVIEW_HEIGHT);
        make.centerY.mas_equalTo(_superView);
    }];
}

- (void)showSideMenuManager {
    [self.hideMenu mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_superView.mas_right);
        make.width.mas_equalTo(HIDEVIEW_WIDTH);
        make.height.mas_equalTo(HIDEVIEW_HEIGHT);
        make.centerY.mas_equalTo(_superView);
    }];
    
    [self.showMenu mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_superView.mas_right).mas_offset(SHOWVIEW_WIDTH);
        make.width.mas_equalTo(SHOWVIEW_WIDTH);
        make.height.mas_equalTo(SHOWVIEW_HEIGHT);
        make.centerY.mas_equalTo(_superView);
    }];
}

#pragma mark - lazyloading
- (MESideHideenMenu *)hideMenu {
    if (!_hideMenu) {
        weakify(self);
        _hideMenu = [[MESideHideenMenu alloc] initWithHandler:^{
            strongify(self);
            [self animationWithTouch: MEUSERTouchMenuTypeHideMenu];
            if (self.operationMenuCallback) {
                self.operationMenuCallback();
            }
        }];
    }
    return _hideMenu;
}

- (MESideShowMenu *)showMenu {
    if (!_showMenu) {
        _showMenu = [[MESideShowMenu alloc] initWitHandler:^(MEUserTouchEventType type) {
            [self animationWithTouch: MEUSERTouchMenuTypeShowMenu];
            if (self.sideMenuCallback) {
                self.sideMenuCallback(type);
            }
        }];
    }
    return _showMenu;
}

@end
