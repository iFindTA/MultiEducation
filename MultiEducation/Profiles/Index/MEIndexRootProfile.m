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

/**
 首页数据源
 */
@property (nonatomic, strong) MEPBIndexClass *indexDataSource;

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
    
    //更新Cordova资源包
    [self updateOnlineCordovaResource];
    [self.appDelegate updateRongIMUnReadMessageCounts];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.indexDataSource == nil) {
        [self fetchIndexRemoteData];
    } else {
        //默认加载
        [self.bgScroller displayDefaultClass];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //*
    weakify(self)
    [MEKits refreshCurrentUserSessionTokenWithCompletion:^(NSError * _Nullable err) {
        strongify(self)
        [self.appDelegate startIMServivesOnBgThread];
    }];
    //*/
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.indexNavigationBar endSearchAction];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- fetch Index Datas

#define ME_INDEX_TAB_CACHE_PATH             @"cache/index"

- (NSString *)storageFileName {
    return @"index_sub_bar.bat";
}

- (NSData *_Nullable)fetchIndexCacheLocalStorage {
    NSString *rootPath = [MEKits sandboxPath];
    NSString *fileName = [self storageFileName];
    NSString *dir = [rootPath stringByAppendingPathComponent:ME_INDEX_TAB_CACHE_PATH];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [dir stringByAppendingPathComponent:fileName];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        return data;
    }
    return nil;
}

- (BOOL)saveIndexCacheData2LocalStorage:(NSData *)data {
    if (!data) {
        NSLog(@"got an empty data!");
        return false;
    }
    NSString *rootPath = [MEKits sandboxPath];
    NSString *dir = [rootPath stringByAppendingPathComponent:ME_INDEX_TAB_CACHE_PATH];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dir]) {
        [fileManager createDirectoryAtPath:dir withIntermediateDirectories:true attributes:nil error:nil];
    }
    NSString *fileName = [self storageFileName];
    NSString *filePath = [dir stringByAppendingPathComponent:fileName];
    if ([fileManager fileExistsAtPath:filePath]) {
        [fileManager removeItemAtPath:filePath error:nil];
    }
    
    return [data writeToFile:filePath atomically:true];
}

- (void)fetchIndexRemoteData {
    MEIndexVM *vm = [[MEIndexVM alloc] init];
    weakify(self)
    [vm postData:[NSData data] hudEnable:true success:^(NSData * _Nullable resObj) {
        NSError *err;strongify(self)
        MEPBIndexClass *index = [MEPBIndexClass parseFromData:resObj error:&err];
        if (err != nil) {
            [MEKits handleError:err];
            [self displayDefaultIndexTab];
            return;
        }
        self.indexDataSource = index;
        //save to local storage
        [self saveIndexCacheData2LocalStorage:resObj];
        //reload ui
        [self renderIndexSubviewsUI];
    } failure:^(NSError * _Nonnull error) {
        [MEKits handleError:error];
        [self displayDefaultIndexTab];
    }];
}

/**
 数据加载错误 则显示bundle资源
 */
- (void)displayDefaultIndexTab {
    NSData *local = [self fetchIndexCacheLocalStorage];
    if (local == nil) {
        //load bundle data
        NSString *file = [[NSBundle mainBundle] pathForResource:@"index_sub_bar" ofType:@"bat"];
        local = [NSData dataWithContentsOfFile:file];
    }
    NSError *err;
    MEPBIndexClass *index = [MEPBIndexClass parseFromData:local error:&err];
    if (err != nil) {
        [MEKits handleError:err];
        return;
    }
    self.indexDataSource = index;
    //reload ui
    [self renderIndexSubviewsUI];
}

- (void)renderIndexSubviewsUI {
    //prepare sub bar data
    NSMutableArray *datas = [NSMutableArray arrayWithCapacity:0];
    NSArray<MEPBIndexItem*> *cats = self.indexDataSource.catsArray.copy;
    for (MEPBIndexItem *item in cats) {
        NSString *title = PBAvailableString(item.title);
        NSString *code = PBAvailableString(item.code);
        NSDictionary *map = NSDictionaryOfVariableBindings(title, code);
        [datas addObject:map];
    }
    //头部导航条
    NSUInteger statusBarHeight = [MEKits statusBarHeight];
    NSArray *items = datas.copy;
    self.indexNavigationBar = [MEIndexNavigationBar indexNavigationBarWithTitles:items];
    [self.view addSubview:self.indexNavigationBar];
    [self.indexNavigationBar makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(statusBarHeight+ME_HEIGHT_NAVIGATIONBAR+ME_LAYOUT_SUBBAR_HEIGHT);
    }];
    //背景滚动scroller
    BOOL whetherTourist = self.currentUser.isTourist;CGFloat height = [MEKits tabBarHeight];
    self.bgScroller = [MEIndexBgScroller sceneWithSubBar:self.indexNavigationBar];
    [self.view addSubview:self.bgScroller];
    [self.bgScroller makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.indexNavigationBar.mas_bottom).offset(ME_LAYOUT_MARGIN);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset((whetherTourist?0: - height));
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
    //游客模式 添加引导登录按钮
    if (self.currentUser.isTourist) {
        CGFloat itemSize = ME_HEIGHT_TABBAR;
        MEBaseButton *btn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
        //btn.backgroundColor = [UIColor pb_randomColor];
        btn.titleLabel.font = [UIFont fontWithName:@"iconfont" size:itemSize];
        [btn setTitle:@"\U0000e621" forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(ME_THEME_COLOR_VALUE) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(guideTouristGotoSignTouchEvent) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view).offset(-ME_LAYOUT_BOUNDARY);
            make.bottom.equalTo(self.view).offset(-ME_LAYOUT_BOUNDARY*1.5);
            make.size.equalTo(CGSizeMake(itemSize, itemSize));
        }];
    }
    //默认搜索
    [self.indexNavigationBar updatePlaceholder:self.indexDataSource.keyword];
    //默认加载
    [self.bgScroller displayDefaultClass];
}

#pragma mark --- History & Notice

- (void)displayUserWarthingHistory {
    /*
    NSDictionary *params = @{@"id":@(2), @"title":@"科学探索"};
    NSURL *url = [MEDispatcher profileUrlWithClass:@"MEIndexSubClassProfile" initMethod:nil params:params instanceType:MEProfileTypeCODE];
    NSError *err = [MEDispatcher openURL:url withParams:params];
    [MEKits handleError:err];
    //*/
    
    NSString *urlString = @"profile://root@MEWatchHistoryProfile/";
    NSError * err = [MEDispatcher openURL:[NSURL URLWithString:urlString] withParams:nil];
    [MEKits handleError:err];
}

- (void)displayUserNoticeProfile {
    NSString *urlString = @"profile://root@METemplateProfile/__initWithParams:#code";
    NSURL * routeUrl = [NSURL URLWithString:urlString];
    NSDictionary *params = @{ME_CORDOVA_KEY_TITLE:@"园所公告", ME_CORDOVA_KEY_STARTPAGE:@"notice.html"};
    NSError * err = [MEDispatcher openURL:routeUrl withParams:params];
    [MEKits handleError:err];
}

#pragma mark --- 游客模式 点击登录

- (void)guideTouristGotoSignTouchEvent {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:[NSNumber numberWithBool:false] forKey:ME_SIGNIN_DID_SHOW_VISITOR_FUNC];
    NSString *routeUrlString = PBFormat(@"profile://root@%@/__initWithParams:", ME_USER_SIGNIN_PROFILE);
    NSError *err = [MEDispatcher openURL:[NSURL URLWithString:routeUrlString] withParams:params];
    [MEKits handleError:err];
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
