//
//  MEVideoPlayProfile.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/7.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEActivity.h"
#import "MEVideoPlayProfile.h"
#import "MEPlayerControl.h"
#import "MEVideoRelateVM.h"
#import <ZFPlayer/ZFPlayer.h>
#import "MEPlayInfoTitlePanel.h"
#import <MediaPlayer/MediaPlayer.h>

static CGFloat const ME_VIDEO_PLAYER_WIDTH_HEIGHT_SCALE                     =   16.f/9;

@interface MEVideoPlayProfile () <ZFPlayerDelegate, UITableViewDelegate>

/**
 video info that received
 */
@property (nonatomic, strong) NSDictionary *videoInfo;

@property (nonatomic, strong) ZFPlayerView *player;
@property (nonatomic, strong) MEBaseScene *playerScene;
@property (nonatomic, strong) MEPlayerControl *playerControl;
@property (nonatomic, strong) MEPlayInfoTitlePanel *titlePanel;
//点赞面板
//@property (nonatomic, strong) MEPlayerLike *likeScene;
//推荐列表
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) MEVideoRelateVM *tableVM;

@end

@implementation MEVideoPlayProfile

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [self.player removeObserver:self forKeyPath:@"state"];
    [self.player removeObserver:self forKeyPath:@"isFullScreen"];
}

- (id)__initWithParams:(NSDictionary *)params {
    self = [super init];
    if (self) {
        self.videoInfo = params;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self hiddenNavigationBar];
    self.sj_fadeAreaViews = @[self.playerScene];
    
    //init video player
    [self.view addSubview:self.playerScene];
    CGFloat height = MESCREEN_WIDTH / ME_VIDEO_PLAYER_WIDTH_HEIGHT_SCALE;
    [self.playerScene makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(height);
    }];
    //title panel
    [self.view addSubview:self.titlePanel];
    [self.titlePanel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.playerScene.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(ME_HEIGHT_TABBAR);
    }];
    
    //推荐列表
    [self.view addSubview:self.table];
    [self.table makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titlePanel.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
    
    //observes
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(__applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(__applicationDidEnterForeground) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [self.player addObserver:self forKeyPath:@"isFullScreen" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self.player addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    /*
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
    //*/
    
    //[self.player autoPlayTheVideo];
    
    //下载相关视频列表
    [self.tableVM loadRelateVideos];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self.player isPauseByUser]) {
        PBMAINDelay(ME_ANIMATION_DURATION, ^{
            [self.player play];
        });
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.player pause];
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

// 是否支持自动转屏
- (BOOL)shouldAutorotate{
    return false;
    //return !ZFPlayerShared.isLockScreen;
}


- (BOOL)prefersStatusBarHidden {
    //return false;
    return ZFPlayerShared.isStatusBarHidden;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- Getter for lazy load mode

- (MEBaseScene *)playerScene {
    if (!_playerScene) {
        _playerScene = [[MEBaseScene alloc] initWithFrame:CGRectZero];
    }
    return _playerScene;
}

- (MEPlayerControl *)playerControl {
    if (!_playerControl) {
        _playerControl = [[MEPlayerControl alloc] init];
        weakify(self)
        _playerControl.videoPlayControlCallback = ^(MEVideoPlayUserAction action) {
            strongify(self)
            [self userVideoPlayerInterfaceActionType:action];
        };
    }
    return _playerControl;
}

- (MEPlayInfoTitlePanel *)titlePanel {
    if (!_titlePanel) {
        _titlePanel = [[MEPlayInfoTitlePanel alloc] initWithFrame:CGRectZero];
        _titlePanel.backgroundColor = [UIColor whiteColor];
    }
    return _titlePanel;
}

- (ZFPlayerView *)player {
    if (!_player) {
        _player = [[ZFPlayerView alloc] initWithFrame:CGRectZero];
        _player.delegate = self;
        _player.fullScreenPlay = false;
        //[_player playerControlView:self.playerControlScene playerModel:[self fetchPlayModel]];
        [_player playerControlView:self.playerControl playerModel:[self fetchPlayModel]];
        
    }
    return _player;
}

- (ZFPlayerModel *)fetchPlayModel {
    ZFPlayerModel *model = [[ZFPlayerModel alloc] init];
    model.title = @"小黄人大战";
    model.fatherView = self.playerScene;
    model.placeholderImage = [UIImage imageNamed:@"playerBg"];
    model.videoURL = [NSURL URLWithString:@"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
    
    return model;
}

- (MEVideoRelateVM *)tableVM {
    if (!_tableVM) {
        NSString *currentVideoID = @"";
        _tableVM = [MEVideoRelateVM vmWithRelateVideoID:currentVideoID table:self.table];
    }
    return _tableVM;
}

- (UITableView *)table {
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _table.showsHorizontalScrollIndicator = false;
        _table.showsVerticalScrollIndicator = false;
        //_table.delegate = self;
        //_table.backgroundColor = [UIColor blueColor];
    }
    return _table;
}

#pragma mark --- ZFPlayer Delegate

- (void)zf_playerBackAction {
    [self defaultGoBackStack];
}

- (void)zf_playerControlViewWillShow:(UIView *)controlView isFullscreen:(BOOL)fullscreen {
    [self.playerControl updateUserActionItemState4Hidden:false];
}

- (void)zf_playerControlViewWillHidden:(UIView *)controlView isFullscreen:(BOOL)fullscreen {
    [self.playerControl updateUserActionItemState4Hidden:true];
}

#pragma mark --- Observes

- (void)__applicationDidEnterBackground {
    [self.player pause];
}

- (void)__applicationDidEnterForeground {
    if (self.player.state != ZFPlayerStateStopped && self.player.state != ZFPlayerStateFailed) {
        [self.player play];
    }
}

- (void)onDeviceOrientationChange {
    BOOL fullValue = [[self.player valueForKeyPath:@"isFullScreen"] boolValue];
    if (fullValue) {
        NSLog(@"2 full");
    } else {
        NSLog(@"exit full");
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"isFullScreen"]) {
        BOOL isFullScreen = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
        NSLog(@"变成%@", isFullScreen?@"全屏":@"小屏");
        [self.playerControl updateVideoPlayerState:isFullScreen];
        
        [self.view layoutIfNeeded];
    } else if ([keyPath isEqualToString:@"state"]) {
        NSInteger state = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        if (state == ZFPlayerStateStopped) {
            //如果有下一个视频
            [self.playerControl showNextPlayItem:@"大头儿子小头爸爸"];
        } else {
            [self.playerControl closeNextRecommandItemEvent];
        }
        
    }
}

#pragma mark --- user touch action

/**
 收藏 & 分享
 */
- (void)userVideoPlayerInterfaceActionType:(MEVideoPlayUserAction)action {
    if (action & MEVideoPlayUserActionLike) {
        //收藏callback
        weakify(self)
        void(^likeCallback)(void) = ^(){
            NSString *uid = @"fetch user's id";
            
            //收藏动作
            //NSLog(@"sigin after excute block with user:%@", uid);
            
            PBMAINDelay(ME_ANIMATION_DURATION, ^{
                strongify(self)
                [self defaultGoBackStack];
                [SVProgressHUD showSuccessWithStatus:@"收藏成功！"];
                [self.playerControl updateUserLikeItemState:true];
            });
        };
        if (![self userDidSignIn]) {
//            NSString *urlString = @"profile://root@MESignInProfile/__initCallback:#code";
//            NSError *err = [MEDispatcher openURL:[NSURL URLWithString:urlString] withCallback:Block_copy(likeCallback)];
//            [self handleTransitionError:err];
//            return;
            
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
//            NSDictionary *params =@{ME_DISPATCH_KEY_CALLBACK:[likeCallback copy]};
            [params setObject:[likeCallback copy] forKey:ME_DISPATCH_KEY_CALLBACK];
            NSURL *signInUrl = [MEDispatcher profileUrlWithClass:@"MESignInProfile" initMethod:nil params:params.copy instanceType:MEProfileTypeCODE];
            NSError *err = [MEDispatcher openURL:signInUrl withParams:params];
            [self handleTransitionError:err];
            return;
        }
        //收藏动作
        if (likeCallback) {
            likeCallback();
        }
    } else if (action & MEVideoPlayUserActionShare) {
        NSString *textToShare = @"多元幼教_V2.0新版从火星回来了！";
        UIImage *imageToShare = [UIImage imageNamed:@"playerBg"];
        NSURL *urlToShare = [NSURL URLWithString:@"https://github.com/iFindTA"];
        NSArray *activityItems = @[urlToShare,textToShare,imageToShare];
        //自定义 customActivity继承于UIActivity,创建自定义的Activity加在数组Activities中。
        MEActivity *active = [[MEActivity alloc] initWithTitie:@"多元幼教V2.0" withActivityImage:[UIImage imageNamed:@"AppIcon"] withUrl:urlToShare withType:@"MEActivity" withShareContext:activityItems];
        NSArray *activities = @[active];
        UIActivityViewController *shareProfile = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:activities];
        shareProfile.completionWithItemsHandler = ^(NSString *activityType,BOOL completed,NSArray *returnedItems,NSError *activityError) {
            NSLog(@"activityType :%@", activityType);
            if (completed) {
                NSLog(@"completed");
            } else {
                NSLog(@"cancel");
            }
        };
        //关闭系统的一些activity类型
        shareProfile.excludedActivityTypes = @[];
        [self presentViewController:shareProfile animated:true completion:nil];
    } else if (action & MEVideoPlayUserActionNextItem) {
        
    }
    UIAlertController *sheet  = [UIAlertController alertControllerWithTitle:@"标题二" message:@"这里是要显示的信息" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [sheet addAction:cancel];
}

#pragma mark --- Network & User Interactive

- (NSArray *)generateTestData {
    NSUInteger count = 9;
    NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < count; i++) {
        NSString *str = [NSString stringWithFormat:@"捉泥鳅---:%d", i];
        NSString *image = @"http://img01.taopic.com/180205/267831-1P20523202431.jpg";
        NSDictionary *item = @{@"title":str, @"image":image};
        [tmp addObject:item];
    }
    return tmp.copy;
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
