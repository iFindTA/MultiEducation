//
//  MEVideoPlayProfile.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/7.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEVideoPlayProfile.h"
#import "MEPlayerControl.h"
#import "MEVideoRelateVM.h"
#import <ZFPlayer/ZFPlayer.h>
#import "MEPlayerInfoScene.h"
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
//点赞面板
//@property (nonatomic, strong) MEPlayerLike *likeScene;
//推荐列表
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) MEVideoRelateVM *tableVM;

@end

@implementation MEVideoPlayProfile

- (instancetype)__initWithParams:(NSDictionary *)params {
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
    
    //推荐列表
    [self.view addSubview:self.table];
    [self.table makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.player.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
    //table header
    MEPlayerInfoScene *infoHeader = [MEPlayerInfoScene configreInfoDescriptionPanelWithInfo:self.videoInfo];
    self.table.tableHeaderView = infoHeader;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.player autoPlayTheVideo];
    //下载相关视频列表
    [self.tableVM loadRelateVideos];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.player pause];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (BOOL)shouldAutorotate {
    return false;
}

- (BOOL)prefersStatusBarHidden {
    return ZFPlayerShared.isStatusBarHidden;
    //return true;
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
        _playerControl.videoPlayControlCallback = ^(MEVideoPlayUserAction action) {
            NSLog(@"action :%zd", action);
        };
    }
    return _playerControl;
}

- (void)handleDeviceOrientationDidChange:(NSNotification *)notification {
    NSLog(@"oritention");
}

- (ZFPlayerView *)player {
    if (!_player) {
        _player = [[ZFPlayerView alloc] initWithFrame:CGRectZero];
        _player.delegate = self;
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
    model.videoURL = [NSURL URLWithString:@"http://120.25.226.186:32812/resources/videos/minion_01.mp4"];
    
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
        _table.delegate = self;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
