//
//  MEBabyRootProfile.m
//  fsc-ios
//
//  Created by nanhu on 2018/4/9.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEBabyRootProfile.h"
#import "MEBabyContent.h"
#import "MEBrowserProfile.h"
#import "MEBabyNavigation.h"

@interface MEBabyRootProfile ()

@property (nonatomic, strong) MEBabyContent *babyView;

@property (nonatomic, strong) MEBabyNavigation *babyNavigation;

@end

@implementation MEBabyRootProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
        
    //隐藏导航条
    [self hiddenNavigationBar];
    
    if (!SYSTEM_VERSION_GREATER_THAN(@"11.0")) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.view addSubview: self.babyView];
    [self.view addSubview: self.babyNavigation];
    
    //layout
    [self.babyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(self.view);
    }];
    
    [self.babyNavigation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.height.mas_equalTo(ME_HEIGHT_NAVIGATIONBAR + [MEKits statusBarHeight]);
    }];
}

- (void)dealloc {
    [_babyView removeNotiObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)navigationAnimation:(CGFloat)offset direction:(MEScrollViewDirection)direction {
        if (direction == MEScrollViewDirectionUp) {
            [UIView animateWithDuration: ME_ANIMATION_DURATION animations:^{
                self.babyNavigation.alpha = 0;
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
            }];
        } else {
            [UIView animateWithDuration: ME_ANIMATION_DURATION animations:^{
                self.babyNavigation.alpha = 1;
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
            }];
        }
}

#pragma mark - lazyloading
- (MEBabyContent *)babyView {
    if (!_babyView) {
        _babyView = [[MEBabyContent alloc] initWithFrame: CGRectZero];
        __weak typeof(self) weakself = self;
        _babyView.babyTabBarBadgeCallback = ^(NSInteger badge) {
            [weakself setBadgeValue: 0 atIndex: 2];
        };
        weakify(self);
        _babyView.babyContentScrollCallBack = ^(CGFloat contentOffsetY, MEScrollViewDirection direction) {
            strongify(self);
            [self navigationAnimation:contentOffsetY direction: direction];
        };
    }
    return _babyView;
}

- (MEBabyNavigation *)babyNavigation {
    if (!_babyNavigation) {
        
        NSString *name = self.currentUser.name;
        
        NSString *urlStr = [NSString stringWithFormat: @"%@%@", self.currentUser.bucketDomain, self.currentUser.portrait];
        
        _babyNavigation = [[MEBabyNavigation alloc] initWithFrame: CGRectZero urlStr: urlStr title: name];
        _babyNavigation.alpha = 0;
    }
    return _babyNavigation;
}


@end
