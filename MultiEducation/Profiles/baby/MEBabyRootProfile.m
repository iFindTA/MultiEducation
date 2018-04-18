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
    
    [self.view addSubview: self.babyView];
    [self.view addSubview: self.babyNavigation];
    
    //layout
    [self.babyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(self.view);
    }];
    
    [self.babyNavigation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.height.mas_equalTo(ME_HEIGHT_NAVIGATIONBAR + ME_HEIGHT_STATUSBAR);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)navigationAnimation:(CGFloat)offset direction:(MEScrollViewDirection)direction {
        if (direction == MEScrollViewDirectionUp) {
            [UIView animateWithDuration: ME_ANIMATION_DURATION animations:^{
                self.babyNavigation.alpha = 0;
            }];
        } else {
            [UIView animateWithDuration: ME_ANIMATION_DURATION animations:^{
                self.babyNavigation.alpha = 1;
            }];
        }
}

#pragma mark - lazyloading
- (MEBabyContent *)babyView {
    if (!_babyView) {
        _babyView = [[MEBabyContent alloc] init];
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
        _babyNavigation = [[MEBabyNavigation alloc] initWithFrame: CGRectZero urlStr: @"" title: @"某某某家长，您好！"];
        _babyNavigation.alpha = 0;
    }
    return _babyNavigation;
}


@end
