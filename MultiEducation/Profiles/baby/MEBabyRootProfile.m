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
#import <MWPhotoBrowser.h>

@interface MEBabyRootProfile () <MWPhotoBrowserDelegate>

@property (nonatomic, strong) MEBabyContent *babyView;

@property (nonatomic, strong) MEBabyNavigation *babyNavigation;

@property (nonatomic, strong) MWPhotoBrowser *photoBrowser;
@property (nonatomic, strong) NSArray <MWPhoto *> *photos;

@end

@implementation MEBabyRootProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBadgeValue:<#(NSInteger)#> atIndex:<#(NSUInteger)#>]
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

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    return [self.photos objectAtIndex: index];
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    _photoBrowser = nil;
    self.photos = nil;
    [self.navigationController popViewControllerAnimated: YES];
}

#pragma mark - lazyloading
- (MEBabyContent *)babyView {
    if (!_babyView) {
        _babyView = [[MEBabyContent alloc] initWithFrame: CGRectZero];
        __weak typeof(self) weakself = self;
        _babyView.babyTabBarBadgeCallback = ^(NSInteger badge) {
            [weakself setBadgeValue: 0 atIndex: 1];
        };
        weakify(self);
        _babyView.babyContentScrollCallBack = ^(CGFloat contentOffsetY, MEScrollViewDirection direction) {
            strongify(self);
            [self navigationAnimation:contentOffsetY direction: direction];
        };
        
        _babyView.DidSelectHandler = ^(NSInteger index, NSArray *photos) {
            strongify(self);
            self.photos = photos;
            [self.navigationController pushViewController: self.photoBrowser animated: YES];
        };
    }
    return _babyView;
}

- (MEBabyNavigation *)babyNavigation {
    if (!_babyNavigation) {
        
        NSString *name;
        if (self.currentUser.userType == MEPBUserRole_Teacher || self.currentUser.userType == MEPBUserRole_Gardener) {
            name = self.currentUser.schoolName;
        } else {
            name = self.currentUser.name;
        }
        
        NSString *urlStr = [NSString stringWithFormat: @"%@/%@", self.currentUser.bucketDomain, self.currentUser.portrait];
        _babyNavigation = [[MEBabyNavigation alloc] initWithFrame: CGRectZero urlStr: urlStr title: name];
        _babyNavigation.alpha = 0;
    }
    return _babyNavigation;
}

- (MWPhotoBrowser *)photoBrowser {
    if (!_photoBrowser) {
        _photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate: self];
        //set options
        _photoBrowser.displayActionButton = NO;//显示分享按钮(左右划动按钮显示才有效)
        _photoBrowser.displayNavArrows = NO; //显示左右划动
        _photoBrowser.displaySelectionButtons = NO; //是否显示选择图片按钮
        _photoBrowser.alwaysShowControls = YES; //控制条始终显示
        _photoBrowser.zoomPhotosToFill = YES; //是否自适应大小
        _photoBrowser.enableGrid = NO;//是否允许网络查看图片
        _photoBrowser.startOnGrid = NO; //是否以网格开始;
        _photoBrowser.enableSwipeToDismiss = YES;
        _photoBrowser.autoPlayOnAppear = NO;//是否自动播放视频
    }
    return _photoBrowser;
}

@end
