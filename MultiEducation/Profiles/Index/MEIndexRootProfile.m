//
//  MEIndexRootProfile.m
//  fsc-ios
//
//  Created by nanhu on 2018/4/9.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEIndexVM.h"
#import "MEIndexRootProfile.h"
#import "MEIndexSearchBar.h"
#import "MEIndexSearchScene.h"
//#import "MEIndexClassesScene.h"

#import "MEIndexBgScroller.h"
#import "MEIndexNavigationBar.h"

@interface MEIndexRootProfile ()

//@property (nonatomic, strong) MEIndexHeader *header;
//搜索控件
@property (nonatomic, strong) MEIndexSearchBar *searchBar;
@property (nonatomic, strong) MASConstraint *headerTopConstraint;
@property (nonatomic, strong) MASConstraint *searchHeightConstraint;
//控制searchBar显示隐藏
@property (nonatomic, strong) MASConstraint *searchTopConstraint;
@property (nonatomic, strong) MEIndexSearchScene *searchScene;
/**
 分类内容
 */
@property (nonatomic, strong) MEIndexNavigationBar *indexNavigationBar;
@property (nonatomic, strong) MEIndexBgScroller *bgScroller;

@end

@implementation MEIndexRootProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //隐藏导航条
    [self hiddenNavigationBar];
    
    /*加载头部
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"MEIndexHeader" owner:self options:nil];
    self.header = [nibs firstObject];
    [self.view addSubview:self.header];
    self.header.delegate = self;
    CGFloat offsetHeight = ceil(ME_HEIGHT_STATUSBAR+ME_LAYOUT_SUBBAR_HEIGHT);
    [self.header makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).priority(UILayoutPriorityDefaultHigh);
        if (!self.headerTopConstraint) {
            self.headerTopConstraint = make.top.equalTo(self.view).offset(-offsetHeight).priority(UILayoutPriorityRequired);
        }
        make.left.right.equalTo(self.view);
        make.height.equalTo(offsetHeight);
    }];
    [self.headerTopConstraint deactivate];
    //搜索 工具条
    CGFloat normalHeight = ME_LAYOUT_SUBBAR_HEIGHT; CGFloat activeHeight = normalHeight + ME_HEIGHT_STATUSBAR;
    nibs = [[NSBundle mainBundle] loadNibNamed:@"MEIndexSearchBar" owner:self options:nil];
    self.searchBar = nibs.firstObject;
    [self.view insertSubview:self.searchBar belowSubview:self.header];
    [self.searchBar makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.header.mas_bottom).priority(UILayoutPriorityDefaultHigh);
        if (!self.searchTopConstraint) {
            self.searchTopConstraint = make.top.equalTo(self.header.mas_bottom).offset(-normalHeight).priority(UILayoutPriorityRequired);
        }
        make.height.equalTo(normalHeight).priority(UILayoutPriorityDefaultHigh);
        if (!self.searchHeightConstraint) {
            self.searchHeightConstraint = make.height.equalTo(activeHeight).priority(UILayoutPriorityRequired);
        }
    }];
    weakify(self)
    self.searchBar.callback = ^(BOOL active){
        strongify(self)
        [self hideTabBar:active animated:true];
        active?[self.headerTopConstraint activate]:[self.headerTopConstraint deactivate];
        active?[self.searchHeightConstraint activate]:[self.searchHeightConstraint deactivate];
        self.searchScene.hidden = !active;
        [UIView animateWithDuration:ME_ANIMATION_DURATION animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    };
    [self.searchTopConstraint deactivate];
    [self.searchHeightConstraint deactivate];
    //搜索结果界面
    self.searchScene = [[MEIndexSearchScene alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.searchScene];
    self.searchScene.hidden = true;
    __weak MEIndexSearchBar * weakSearchBar = self.searchBar;
    self.searchScene.searchBar = weakSearchBar;
    [self.searchScene makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(self.searchBar.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
    
    weakify(self)
    //内容呈现
    __weak MEIndexHeader *weakHeader = self.header;
    self.classesScene = [MEIndexClassesScene classesSceneWithSubNavigationBar:weakHeader];
    [self.view addSubview:self.classesScene];
    //[self.view insertSubview:self.classesScene belowSubview:self.searchScene];
    [self.classesScene makeConstraints:^(MASConstraintMaker *make) {
        //make.top.equalTo(self.searchBar.mas_bottom);
        make.top.equalTo(self.header.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-ME_HEIGHT_TABBAR);
    }];
    self.classesScene.hideShowBarCallback = ^(BOOL hide){
        strongify(self)
        hide?[self.searchTopConstraint activate]:[self.searchTopConstraint deactivate];
        [UIView animateWithDuration:ME_ANIMATION_DURATION animations:^{
            [self.view layoutIfNeeded];
        }];
    };
    //游客模式 提示登录
    if (self.currentUser.userType == MEUserRoleVisitor) {
        //TODO://游客模式 引导登录
        //MEBaseButton *btn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
    }
    //*/
    
    //code layout
    //头部导航条 第一版先写死
    NSArray *items = @[@"精选", @"小班", @"中班", @"大班"];
    self.indexNavigationBar = [MEIndexNavigationBar indexNavigationBarWithTitles:items];
    [self.view addSubview:self.indexNavigationBar];
    [self.indexNavigationBar makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(ME_HEIGHT_STATUSBAR+ME_HEIGHT_NAVIGATIONBAR);
    }];
    //背景滚动scroller
    BOOL whetherTourist = self.currentUser.isTourist;
    self.bgScroller = [MEIndexBgScroller sceneWithSubNavigationBar:self.indexNavigationBar];
    [self.view addSubview:self.bgScroller];
    [self.bgScroller makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.indexNavigationBar.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset((whetherTourist?0:-ME_HEIGHT_TABBAR));
    }];
    //event
    weakify(self)
    self.indexNavigationBar.indexNavigationBarItemCallback = ^(NSUInteger index){
        strongify(self)
        [self.bgScroller changeNavigationClass4Page:index];
    };
    self.indexNavigationBar.indexNavigationBarOtherCallback = ^(MEIndexNavigationType type){
        strongify(self)
        if (type & MEIndexNavigationTypeHistory) {
            [self displayUserWarthingHistory];
        } else if (type & MEIndexNavigationTypeNotice) {
            [self displayUserNoticeProfile];
        }
    };
    //更新Cordova资源包
    [self updateOnlineCordovaResource];
    [self.appDelegate updateRongIMUnReadMessageCounts];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //显示默认加载
    [self.bgScroller displayDefaultClass];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    weakify(self)
    [MEKits refreshCurrentUserSessionTokenWithCompletion:^(NSError * _Nullable err) {
        strongify(self)
        [self.appDelegate startRongIMServivesOnBgThread];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- History & Notice

- (void)displayUserWarthingHistory {
    /*
    NSDictionary *params = @{@"id":@(2), @"title":@"科学探索"};
    NSURL *url = [MEDispatcher profileUrlWithClass:@"MEIndexSubClassProfile" initMethod:nil params:params instanceType:MEProfileTypeCODE];
    NSError *err = [MEDispatcher openURL:url withParams:params];
    [self handleTransitionError:err];
    //*/
    
    NSString *urlString = @"profile://root@MEWatchHistoryProfile/";
    NSError * err = [MEDispatcher openURL:[NSURL URLWithString:urlString] withParams:nil];
    [self handleTransitionError:err];
}

- (void)displayUserNoticeProfile {
    NSString *urlString = @"profile://root@METemplateProfile/__initWithParams:#code";
    NSURL * routeUrl = [NSURL URLWithString:urlString];
    NSDictionary *params = @{ME_CORDOVA_KEY_TITLE:@"园所公告", ME_CORDOVA_KEY_STARTPAGE:@"notice.html"};
    NSError * err = [MEDispatcher openURL:routeUrl withParams:params];
    [self handleTransitionError:err];
}

#pragma mark --- 更新Cordova资源包
/**
 更新Cordova在线资源
 */
- (void)updateOnlineCordovaResource {
    PBMAINDelay(ME_ANIMATION_DURATION * 10, ^{
        [MEKits updateCordovaResourcePacket];
    });
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
