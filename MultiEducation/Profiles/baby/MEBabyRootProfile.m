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
#import "MEPhotoBrowser.h"
#import "MEBaseNavigationProfile.h"
#import "Meuser.pbobjc.h"
#import "Meclass.pbobjc.h"
#import "MebabyGrowth.pbobjc.h"
#import "MEBabyIndexVM.h"

@interface MEBabyRootProfile () <MWPhotoBrowserDelegate>

@property (nonatomic, strong) MEBabyContent *babyView;

@property (nonatomic, strong) MEBabyNavigation *babyNavigation;

@property (nonatomic, strong) MEPhotoBrowser *photoBrowser;
@property (nonatomic, strong) NSArray <MWPhoto *> *photos;

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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self.babyView viewWillAppear];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    //layout
    [self.babyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.height.mas_equalTo(MESCREEN_HEIGHT - ME_HEIGHT_TABBAR);
    }];
    
    [self.babyNavigation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.view);
        make.width.mas_equalTo(MESCREEN_WIDTH);
        make.height.mas_equalTo(ME_HEIGHT_NAVIGATIONBAR + [MEKits statusBarHeight]);
    }];
}

- (void)dealloc {
    [_babyView removeNotiObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)gotoBabyPhotoProfile:(NSInteger)classId {
    NSDictionary *params = @{@"classId": [NSNumber numberWithInteger: classId], @"title": @"宝宝相册"};
    NSString *urlString =@"profile://root@MEBabyPhotoProfile";
    NSError * err = [MEDispatcher openURL:[NSURL URLWithString:urlString] withParams:params];
    [MEKits handleError:err];
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
    [self.photoBrowser.navigationController dismissViewControllerAnimated: YES completion: nil];
    _photoBrowser = nil;
    _photos = nil;
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
            [self.navigationController pushViewController: self.photoBrowser animated:YES];
            [self.photoBrowser setCurrentPhotoIndex: index];
        };
        _babyView.didChangeSelectedBaby = ^(NSString *babyName, NSString *babyPortrait) {
            strongify(self);
            [self.babyNavigation changeTitle: babyName url: babyPortrait];
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

- (MEPhotoBrowser *)photoBrowser {
    if (!_photoBrowser) {
        _photoBrowser = [[MEPhotoBrowser alloc] initWithDelegate: self];
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
        
        weakify(self);
        _photoBrowser.DidBackItemHandler = ^{
            strongify(self);
            [self.photoBrowser.navigationController popViewControllerAnimated: YES];
            _photoBrowser = nil;
            _photos = nil;
        };
        
        _photoBrowser.DidGotoBabyPhotoProfileHandler = ^{
            strongify(self);
            
            if (self.currentUser.userType == MEPBUserRole_Teacher) {
                if (self.currentUser.teacherPb.classPbArray.count > 1) {
                    NSString *urlString = @"profile://root@METeacherMultiClassTableProfile/";
                    NSDictionary *params = @{@"pushUrlStr": @"profile://root@MEBabyPhotoProfile/", @"title": @"宝宝相册"};
                    NSError * err = [MEDispatcher openURL:[NSURL URLWithString:urlString] withParams: params];
                    [MEKits handleError:err];
                } else {
                    NSInteger classId = self.currentUser.teacherPb.classPbArray[0].id_p;
                    [self gotoBabyPhotoProfile: classId];
                }
            } else if(self.currentUser.userType == MEPBUserRole_Gardener) {
                if (self.currentUser.deanPb.classPbArray.count > 1) {
                    NSString *urlString = @"profile://root@METeacherMultiClassTableProfile/";
                    NSDictionary *params = @{@"pushUrlStr": @"profile://root@MEBabyPhotoProfile/", @"title": @"宝宝相册"};
                    NSError * err = [MEDispatcher openURL:[NSURL URLWithString:urlString] withParams: params];
                    [MEKits handleError:err];
                    
                } else {
                    NSInteger classId =  self.currentUser.deanPb.classPbArray[0].id_p;
                    [self gotoBabyPhotoProfile: classId];
                }
            } else {
                GuIndexPb *indexPb = [MEBabyIndexVM fetchSelectBaby];
                NSInteger classId;
                if (indexPb) {
                    classId = indexPb.studentArchives.classId;
                } else {
                    classId = self.currentUser.parentsPb.classPbArray[0].id_p;
                }
                [self gotoBabyPhotoProfile: classId];
            }
        };
        
    }
    return _photoBrowser;
}

@end
