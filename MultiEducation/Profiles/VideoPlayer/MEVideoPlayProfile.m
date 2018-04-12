//
//  MEVideoPlayProfile.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/7.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEVideoPlayProfile.h"
#import "MEPlayerLike.h"
#import "MEPlayerControl.h"
#import "MEVideoRelateVM.h"
#import <ZFPlayer/ZFPlayer.h>
#import <MediaPlayer/MediaPlayer.h>

static CGFloat const ME_VIDEO_PLAYER_WIDTH_HEIGHT_SCALE                     =   16.f/9;

@interface MEVideoPlayProfile () <ZFPlayerDelegate, UITableViewDelegate>

@property (nonatomic, strong) ZFPlayerView *player;
@property (nonatomic, strong) MEBaseScene *playerScene;
@property (nonatomic, strong) MEPlayerControl *playerControl;
//点赞面板
@property (nonatomic, strong) MEPlayerLike *likeScene;
//推荐列表
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) MEVideoRelateVM *tableVM;

@end

@implementation MEVideoPlayProfile

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
    //点赞
    [self.view addSubview:self.likeScene];
    [self.likeScene makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.playerScene.mas_bottom);
        make.left.right.equalTo(self.view);
    }];
    //self.likeScene.backgroundColor = [UIColor pb_randomColor];
    self.likeScene.titleLab.text = @"小蝌蚪找妈妈";
    CGFloat imgSize = 20/MESCREEN_SCALE;UIColor *imgColor = pbColorMake(0x666666);
    UIImage *img = [UIImage pb_iconFont:nil withName:@"\U0000eed2" withSize:imgSize withColor:imgColor];
    img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.likeScene.likeBtn setTitle:nil forState:UIControlStateNormal];
    [self.likeScene.likeBtn setImage:img forState:UIControlStateNormal];
    img = [UIImage pb_iconFont:nil withName:@"\U0000e617" withSize:imgSize withColor:imgColor];
    img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.likeScene.dislikeBtn setTitle:nil forState:UIControlStateNormal];
    [self.likeScene.dislikeBtn setImage:img forState:UIControlStateNormal];
    self.likeScene.likeLab.textColor = self.likeScene.dislikeLab.textColor = imgColor;
    
    //推荐列表
    [self.view addSubview:self.table];
    [self.table makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.likeScene.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.player autoPlayTheVideo];
    //下载相关视频列表
    [self.tableVM loadRelateVideos];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
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
    }
    return _playerControl;
}

- (void)handleDeviceOrientationDidChange:(NSNotification *)notification {
    NSLog(@"oritention");
}

- (ZFPlayerView *)player {
    if (!_player) {
        _player = [[ZFPlayerView alloc] initWithFrame:CGRectZero];
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
    //model.videoURL = [NSURL URLWithString:@"http://120.25.226.186:32812/resources/videos/minion_01.mp4"];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"tenggeer" ofType:@"mp4"];
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    model.videoURL = fileUrl;
    
    return model;
}

- (MEPlayerLike *)likeScene {
    if (!_likeScene) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"MEPlayerLike" owner:self options:nil];
        _likeScene = [nibs firstObject];
    }
    return _likeScene;
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
        //_table.dataSource = self.tableVM;
        _table.delegate = self;
    }
    return _table;
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
