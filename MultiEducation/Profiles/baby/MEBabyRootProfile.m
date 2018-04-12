//
//  MEBabyRootProfile.m
//  fsc-ios
//
//  Created by nanhu on 2018/4/9.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEBabyRootProfile.h"
#import "MEBabyHeader.h"
#import "MEBabyContent.h"
#import "MEBabyWebProfile.h"

@interface MEBabyRootProfile () <MEBabyContentDelegate>

@property (nonatomic, strong) MEBabyHeader *headerView;

@property (nonatomic, strong) MEBabyContent *babyView;

@end

@implementation MEBabyRootProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //隐藏导航条
    [self hideNavigationBar];
    
    self.headerView = [[[NSBundle mainBundle] loadNibNamed:@"MEBabyHeader" owner:self options:nil] lastObject];
    [self.view addSubview: self.headerView];
    [self.view addSubview: self.babyView];
    
    //layout
    __weak typeof(self)weakSelf = self;
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view.mas_left).mas_offset(0);
        make.top.mas_equalTo(weakSelf.view.mas_top).mas_offset(0);
        make.right.mas_equalTo(weakSelf.view.mas_right).mas_offset(0);
        make.height.mas_equalTo(adoptValue(230));
    }];
    
    [self.babyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view.mas_left).mas_offset(0);
        make.top.mas_equalTo(weakSelf.headerView.mas_bottom).mas_offset(10);
        make.right.mas_equalTo(weakSelf.view.mas_right).mas_offset(0);
        make.height.mas_equalTo(240);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)pushBabyContentProfile:(NSString *)title webUrl:(NSString *)webUrl doUrl:(NSString *)doUrl {    
    SchedulerParams *params = [[[[SchedulerParams builder] addCtrlParams: @"title" value: title] addCtrlParams: @"webUrl" value: webUrl] build];
    
    self.hidesBottomBarWhenPushed = YES;
    [MEScheduler doUrl: doUrl  widthTarget:self widthParams: params];
    self.hidesBottomBarWhenPushed =NO;
}

#pragma mark - MEBabyContentDelegate
- (void)didTouchBabyContentType:(MEBabyContentType)type {
    NSLog(@"did touch baby content type:%ld", (unsigned long)type);
    
    NSString *title;
    NSString *webUrl;
    NSString *doUrl;
    switch (type) {
        case MEBabyContentTypeBabyPhoto:
            title = @"宝宝相册";
            webUrl = @"http://www.baidu.com";
            doUrl = ME_URL_JUMP_NATIVE_BABY_PHOTO;
            break;
        case MEBabyContentTypeBeautyDay:
            title = @"一日精彩";
            webUrl = @"http://www.baidu.com";
            doUrl = ME_URL_JUMP_NATIVE_BEAUTY_DAY;
            break;
        case MEBabyContentTypeGrowth:
            title = @"成长档案";
            webUrl = @"http://www.baidu.com";
            doUrl = ME_URL_JUMP_NATIVE_GROWTH;
            break;
        case MEBabyContentTypeEvaluate:
            title = @"发展评价";
            webUrl = @"http://www.baidu.com";
            doUrl = ME_URL_JUMP_NATIVE_EVALUATE;
            break;
        case MEBabyContentTypeInvite:
            title = @"邀请家人";
            webUrl = @"http://www.baidu.com";
            doUrl = ME_URL_JUMP_NATIVE_INVITE;
            break;
        default:
            break;
    }
    
    [self pushBabyContentProfile: title webUrl: webUrl doUrl: doUrl];
}

#pragma mark - lazyloading
- (MEBabyContent *)babyView {
    if (!_babyView) {
        _babyView = [[MEBabyContent alloc] init];
        _babyView.delegate = self;
    }
    return _babyView;
}


@end
