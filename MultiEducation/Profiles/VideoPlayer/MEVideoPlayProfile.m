//
//  MEVideoPlayProfile.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/7.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "VKMsgSend.h"
#import "MEActivity.h"
#import "MEWatchItem.h"
#import "MEResFavorVM.h"
#import "MEVideoInfoVM.h"
#import "MEPlayerControl.h"
#import <ZFPlayer/ZFPlayer.h>
#import "MEVideoPlayProfile.h"
#import "MEIndexStoryItemCell.h"
#import "MEPlayInfoTitlePanel.h"
#import "MEPlayInfoSubTitlePanel.h"
#import <MediaPlayer/MediaPlayer.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

static CGFloat const ME_VIDEO_PLAYER_WIDTH_HEIGHT_SCALE                     =   16.f/9;

@interface MEVideoPlayProfile () <ZFPlayerDelegate, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

/**
 video info that received
 */
@property (nonatomic, strong) NSDictionary *params;

@property (nonatomic, strong) ZFPlayerView *player;
@property (nonatomic, strong) MEBaseScene *playerScene;
@property (nonatomic, strong) MEBaseScene *statusBarBg;
@property (nonatomic, strong) MEPlayerControl *playerControl;
@property (nonatomic, strong) MEPlayInfoTitlePanel *titlePanel;

/**
 返回按钮
 */
@property (nonatomic, strong) MEBaseButton *backBtn;

/**
 1,当前资源
 2,预览资源（点击推荐之后先清空当前资源并预览资源 其次加载当前资源）
 3,下一个播放的资源
 */
@property (nonatomic, strong) MEPBRes *currentRes, *previewRes, *nextRes;
@property (nonatomic, assign) BOOL whetherDidLoadData;
//推荐列表
@property (nonatomic, strong) UITableView *table;

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
        _params = [NSDictionary dictionaryWithDictionary:params];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self hiddenNavigationBar];
    self.sj_fadeAreaViews = @[self.playerScene];
    //init status bar background
    CGFloat offset = [UIDevice pb_isX]?[MEKits statusBarHeight]:0;
    [self.view addSubview:self.statusBarBg];
    [self.statusBarBg makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(offset);
    }];
    //init video player
    CGFloat height = MESCREEN_WIDTH / ME_VIDEO_PLAYER_WIDTH_HEIGHT_SCALE;
    [self.view addSubview:self.playerScene];
    [self.playerScene makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusBarBg.mas_bottom);
        make.left.right.equalTo(self.view);
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
    
    //返回按钮
    [self.view addSubview:self.backBtn];
    [self.backBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusBarBg.mas_bottom).offset(ME_LAYOUT_BOUNDARY);
        make.left.equalTo(self.view).offset(ME_LAYOUT_MARGIN*2);
        make.width.height.equalTo(ME_LAYOUT_ICON_HEIGHT);
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
    
    //下载视频相关信息
    self.whetherDidLoadData = false;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:true];
    if (!self.whetherDidLoadData) {
        [self loadVideoRelevantData];
    } else {
        [self.player play];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:false];
    [self.player pause];
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

// 是否支持自动转屏
- (BOOL)shouldAutorotate{
    return false;
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

- (MEBaseScene *)statusBarBg {
    if (!_statusBarBg) {
        _statusBarBg = [[MEBaseScene alloc] initWithFrame:CGRectZero];
        _statusBarBg.backgroundColor = [UIColor blackColor];
    }
    return _statusBarBg;
}

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
        //[_player playerControlView:self.playerControl playerModel:[self fetchPreviewModel]];
        [_player playerControlView:self.playerControl playerModel:[self fetchPreviewModel]];
    }
    return _player;
}

/**
 预加载model
 */
- (ZFPlayerModel *)fetchPreviewModel {
    NSString *title = [self.params pb_stringForKey:@"title"];
    NSString *coverImg = [self.params pb_stringForKey:@"coverImg"];
    ZFPlayerModel *model = [[ZFPlayerModel alloc] init];
    model.title = title;
    model.fatherView = self.playerScene;
    model.placeholderImageURLString = [MEKits imageFullPath:coverImg];
    
    return model;
}

- (UITableView *)table {
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _table.showsHorizontalScrollIndicator = false;
        _table.showsVerticalScrollIndicator = false;
        _table.delegate = self;
        _table.dataSource = self;
        _table.emptyDataSetSource = self;
        _table.emptyDataSetDelegate = self;
        _table.tableFooterView = [UIView new];
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _table;
}

- (MEBaseButton *)backBtn {
    if (!_backBtn) {
        UIImage *image = [UIImage imageNamed:@"video_play_back"];
        _backBtn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:image forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(userDidTouchVideoPlayBackEvent) forControlEvents:UIControlEventTouchUpInside];
        //_backBtn.backgroundColor = [UIColor redColor];
    }
    return _backBtn;
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

#pragma mark --- Load Relevant && User Interactive

- (MEPBRes * _Nullable)fetchNextRecommandResource {
     NSArray<MEPBRes*>*relevants = self.currentRes.relevantListArray.copy;
    //目前策略是 自动播放推荐列表中的第一个
    if (relevants.count > 0) {
        return relevants.firstObject;
    }
    return nil;
}

/**
 清空当前所有资源 预览下一个资源并加载当前资源
 */
- (void)resetAllUIResources4NextPlayItem {
    self.whetherDidLoadData = false;
    //prepare play model
    ZFPlayerModel *model;
    if (self.previewRes) {
        NSString *title = self.previewRes.title;
        NSString *coverImg = self.previewRes.coverImg;
        model = [[ZFPlayerModel alloc] init];
        model.title = title;
        model.fatherView = self.playerScene;
        model.placeholderImageURLString = [MEKits imageFullPath:coverImg];
    } else {
        NSString *coverImg = [self.params pb_stringForKey:@"coverImg"];
        model = [[ZFPlayerModel alloc] init];
        model.fatherView = self.playerScene;
        model.placeholderImageURLString = [MEKits imageFullPath:coverImg];
    }
    if (self.player.state == ZFPlayerStatePlaying || self.player.state == ZFPlayerStateBuffering) {
        [self.player pause];
    }
    [self.player resetToPlayNewVideo:model];
    //player mask clean
    [self.playerControl clean];
    //clean title and description
    [self.titlePanel clean];
    self.table.tableHeaderView = nil;
    self.currentRes = nil;
    [self.table reloadData];
    
    //load next play item resource
    [self loadVideoRelevantData];
}

- (int64_t)fetchResourceID {
    if (self.previewRes) {
        return (NSUInteger)self.previewRes.resId;
    }
    return [[self.params pb_numberForKey:@"vid"] unsignedIntegerValue];
}

- (int32_t)fetchResourceType {
    if (self.previewRes) {
        return self.previewRes.type;
    }
    return [[self.params pb_numberForKey:@"type"] unsignedIntValue];
}

/**
 加载视频相关资源
 */
- (void)loadVideoRelevantData {
    MEVideoInfoVM *vm = [[MEVideoInfoVM alloc] init];
    MEPBRes *res = [[MEPBRes alloc] init];
    ino64_t resId = [self fetchResourceID];
    int32_t resType = [self fetchResourceType];
    [res setResId:resId];
    [res setType:resType];
    weakify(self)
    [vm postData:[res data] hudEnable:true success:^(NSData * _Nullable resObj) {
        NSError *err;strongify(self)
        MEPBRes *resInfo = [MEPBRes parseFromData:resObj error:&err];
        if (err) {
            [MEKits handleError:err];
        } else {
            self.currentRes = resInfo;
        }
        [self rebuildVideoPlayScene];
    } failure:^(NSError * _Nonnull error) {
        strongify(self)
        [MEKits handleError:error];
        [self rebuildVideoPlayScene];
    }];
}

- (void)rebuildVideoPlayScene {
    self.whetherDidLoadData = true;
    
    //reset for empty set
    [self.table reloadEmptyDataSet];
    //title panel
    NSString *title = self.currentRes.title.copy;
    NSArray <MEPBResLabel*>*tags = self.currentRes.resLabelPbArray.copy;
    NSMutableArray *labels = [NSMutableArray arrayWithCapacity:0];
    [tags enumerateObjectsUsingBlock:^(MEPBResLabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.labelName.length > 0) {
            [labels addObject:obj.labelName];
        }
    }];
    NSDictionary *titleParams = @{@"title":PBAvailableString(title), @"tags":labels.copy};
    [self.titlePanel updatePlayInfoTitlePanel4Info:titleParams];
    
    //collection action
    BOOL isFavor = self.currentRes.isFavor;
    [self.playerControl updateUserLikeItemState:isFavor];
    
    //sub description panel
    NSString *desc = self.currentRes.desc.copy;
    MEPlayInfoSubTitlePanel *subDescPanel = [MEPlayInfoSubTitlePanel configreInfoSubTitleDescriptionPanelWithInfo:desc];
    self.table.tableHeaderView = subDescPanel;
    
    //table data
    NSArray<MEPBRes*>*relevants = self.currentRes.relevantListArray.copy;
    NSLog(@"此视频相关资源个数:%zd", relevants.count);
    [self.table reloadData];
    
    //prepare query for network type
    if ([PBService shared].netState != PBNetStateViaWiFi) {
        //[SVProgressHUD showInfoWithStatus:@"您当前处于非Wi-Fi环境，播放视频将会消耗流量！"];
    }
    //play current item
    NSString *coverImg = self.currentRes.coverImg;
    NSString *placeholderString = [MEKits imageFullPath:coverImg];
    //player control mask for audio
    [self.playerControl.audioMask sd_setImageWithURL:[NSURL URLWithString:placeholderString]];
    [self.playerControl updatePlayControlMask4ResourceType:self.currentRes.type];
    NSString *videoUrlString = [MEKits mediaFullPath:self.currentRes.filePath];
    //videoUrlString = @"http://other.web.rh01.sycdn.kuwo.cn/resource/n3/21/19/3413654131.mp3";
    ZFPlayerModel *model = [[ZFPlayerModel alloc] init];
    model.fatherView = self.playerScene;
    model.placeholderImageURLString = placeholderString;
    model.videoURL = [NSURL URLWithString:videoUrlString];
    [self.player resetToPlayNewVideo:model];
    [self.player autoPlayTheVideo];
    //clear preview item
    self.previewRes = nil;
}

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

#pragma mark --- DZNEmpty DataSource & Deleagte

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return self.currentRes == nil && self.whetherDidLoadData;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    UIColor *imgColor =UIColorFromRGB(ME_THEME_COLOR_TEXT_GRAY);
    UIImage *image = [UIImage pb_iconFont:nil withName:ME_ICONFONT_EMPTY_HOLDER withSize:ME_LAYOUT_ICON_HEIGHT withColor:imgColor];
    return image;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = ME_EMPTY_PROMPT_TITLE;
    NSDictionary *attributes = @{NSFontAttributeName: UIFontPingFangSCBold(METHEME_FONT_TITLE),
                                 NSForegroundColorAttributeName: UIColorFromRGB(ME_THEME_COLOR_TEXT_GRAY)};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = ME_EMPTY_PROMPT_DESC;
    if ([[PBService shared] netState] == PBNetStateUnavaliable) {
        text = ME_EMPTY_PROMPT_NETWORK;
    }
    NSDictionary *attributes = @{NSFontAttributeName: UIFontPingFangSC(METHEME_FONT_SUBTITLE),
                                 NSForegroundColorAttributeName: UIColorFromRGB(ME_THEME_COLOR_TEXT_GRAY)};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -ME_LAYOUT_BOUNDARY;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return true;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self loadVideoRelevantData];
}

#pragma mark --- UITableView Delegate && DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger counts = self.currentRes.relevantListArray.count;
    NSUInteger rows = counts / ME_INDEX_STORY_ITEM_NUMBER_PER_LINE;
    if (counts % ME_INDEX_STORY_ITEM_NUMBER_PER_LINE != 0) {
        rows += 1;
    }
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger __row = [indexPath row];
    CGFloat row_height = ME_INDEX_STORY_ITEM_HEIGHT;
    if (__row == 0) {
        row_height = ME_INDEX_CSTORY_ITEM_TITLE_HEIGHT;
    }
    return adoptValue(row_height);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"index_content_story_item_cell";
    MEIndexStoryItemCell *cell = (MEIndexStoryItemCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MEIndexStoryItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSUInteger __row = [indexPath row];
    NSUInteger allCounts = self.currentRes.relevantListArray.count;
    [cell configureStoryItem4RowIndex:__row];
    //item
    NSUInteger numPerLine = ME_INDEX_STORY_ITEM_NUMBER_PER_LINE;
    for (int i = 0; i < numPerLine; i ++) {
        NSUInteger real_item_index = __row * numPerLine + i;
        if (real_item_index < allCounts) {
            MEPBRes *res = self.currentRes.relevantListArray[real_item_index];
            NSString *title = res.title.copy;
            (i % numPerLine == 0)?[cell.leftItemLabel setText:title]:[cell.rightItemLabel setText:title];
            (i % numPerLine == 0)?[cell.leftItemScene setTag:real_item_index]:[cell.rightItemScene setTag:real_item_index];
            
            NSString *imgUrl = [MEKits imageFullPath:res.coverImg];
            UIImage *image = [UIImage imageNamed:@"index_content_placeholder"];
            if (i % numPerLine == 0) {
                [cell.leftItemImage setImageWithURL:[NSURL URLWithString:imgUrl] placeholder:image];
            } else {
                [cell.rightItemImage setImageWithURL:[NSURL URLWithString:imgUrl] placeholder:image];
            }
        } else {
            cell.rightItemScene.hidden = true;
        }
    }
    //callback
    weakify(self)
    cell.indexContentItemCallback = ^(NSUInteger section, NSUInteger index){
        strongify(self)
        [self videoPlaySceneDidTouchRowIndex:index];
    };
    
    return cell;
}

- (void)videoPlaySceneDidTouchRowIndex:(NSUInteger)row {
    NSArray<MEPBRes*>*resources = self.currentRes.relevantListArray.copy;
    if (row >= resources.count) {
        return;
    }
    MEPBRes *res = resources[row];
    self.previewRes = res;
    [self resetAllUIResources4NextPlayItem];
}

#pragma mark --- Observes Events

- (void)__applicationDidEnterBackground {
    [self disablePlayer];
}

- (void)__applicationDidEnterForeground {
    [self enablePlayer];
}

- (void)disablePlayer {
    [self.player pause];
}

- (void)enablePlayer {
    if (self.player.state != ZFPlayerStateStopped && self.player.state != ZFPlayerStateFailed && !self.player.isPauseByUser) {
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
            //退出全屏
            [self.playerControl exitFullscreenMode];
            //自动提示播放下一个视频
            MEPBRes *nextItem = [self fetchNextRecommandResource];
            if (nextItem) {
                self.nextRes = nextItem;
                [self.playerControl showNextPlayItem:nextItem.title];
            }
        } else {
            [self.playerControl closeNextRecommandItemEvent];
            if (state == ZFPlayerStatePlaying) {
                //正在播放 则将视频信息存入数据库 用户观看历史 confidure:目前后台保存
                //[self saveCurrentPlayItemIntoUserWatchHistory];
            }
        }
        
    }
}

#pragma mark --- 保存观看历史

- (void)saveCurrentPlayItemIntoUserWatchHistory {
//    MEPBRes *res = self.currentRes;
//    if (res) {
//        PBBACK( ^{
//            MEWatchItem *item = [[MEWatchItem alloc] init];
//            item.userID = self.currentUser.uid;
//            item.resId = res.resId;
//            item.type = res.type;
//            item.resTypeId = res.resTypeId;
//            item.watchTimestamp = [MEKits currentTimeInterval];
//            item.title = res.title.copy;
//            item.desc = res.desc.copy;
//            item.intro = res.intro.copy;
//            item.coverImg = res.coverImg.copy;
//            item.filePath = res.filePath.copy;
//            //查询原有的
//            NSString *sql = PBFormat(@"userID = %lld and resId = %lld", item.userID, item.resId);
//            NSArray<MEWatchItem*>*items = [WHCSqlite query:[MEWatchItem class] where:sql];
//            if (items.count) {
//
//            }
//            [WHCSqlite insert:item];
//        });
//    }
}

#pragma mark --- user touch action

/**
 点击返回
 */
- (void)userDidTouchVideoPlayBackEvent {
    [self defaultGoBackStack];
}

/**
 收藏 & 分享
 */
- (void)userVideoPlayerInterfaceActionType:(MEVideoPlayUserAction)action {
    if (action & MEVideoPlayUserActionBack) {
        [self defaultGoBackStack];
    } else if (action & MEVideoPlayUserActionLike) {
        //收藏callback
        //MEPBUserRole role = self.currentUser.userType;
        weakify(self)//资源原来收藏状态
        BOOL initFavorState = self.currentRes.isFavor;
        MEPBRes *res = [[MEPBRes alloc] init];
        [res setType:self.currentRes.type];
        [res setResId:self.currentRes.resId];
        void(^likeCallback)(void) = ^(){
            strongify(self)
            MEResFavorVM *vm = [[MEResFavorVM alloc] init];
            weakify(self)
            [vm postData:[res data] hudEnable:true success:^(NSData * _Nullable resObj) {
                strongify(self)
                [SVProgressHUD showSuccessWithStatus:initFavorState?@"取消收藏成功！":@"收藏成功！"];
                //update ui
                if (self) {//登录之后如果释放对象 则不再执行以下逻辑
                    self.currentRes.isFavor = !initFavorState;
                    [self.playerControl updateUserLikeItemState:!initFavorState];
                }
            } failure:^(NSError * _Nonnull error) {
                [MEKits handleError:error];
            }];
            
        };
        if (self.currentUser.isTourist) {
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
            [params setObject:[likeCallback copy] forKey:ME_DISPATCH_KEY_CALLBACK];
            [params setObject:[NSNumber numberWithBool:false] forKey:ME_SIGNIN_DID_SHOW_VISITOR_FUNC];
            NSString *routeUrlString = PBFormat(@"profile://root@%@/__initWithParams:", ME_USER_SIGNIN_PROFILE);
            NSError *err = [MEDispatcher openURL:[NSURL URLWithString:routeUrlString] withParams:params];
            [MEKits handleError:err];
            return;
        } else {
            //收藏动作
            if (likeCallback) {
                likeCallback();
            }
        }
    } else if (action & MEVideoPlayUserActionShare) {
        [self disablePlayer];
        NSString *title = [NSBundle pb_displayName];
        NSString *textIntro = PBAvailableString(self.currentRes.intro);
        NSString *textToShare = PBFormat(@"【%@】-- %@", PBAvailableString(title), textIntro);
        UIImage *imageToShare = [UIImage imageNamed:@"AppIcon"];
        NSString *urlString = [MEKits shareResourceUri:self.currentRes.resId type:self.currentRes.type];
        NSURL *urlToShare = [NSURL URLWithString:urlString];
        NSArray *activityItems = @[urlToShare,textToShare,imageToShare];
        //自定义 customActivity继承于UIActivity,创建自定义的Activity加在数组Activities中。
//        MEActivity *active = [[MEActivity alloc] initWithTitie:title withActivityImage:imageToShare withUrl:urlToShare withType:@"MEActivity" withShareContext:activityItems];
//        NSArray *activities = @[active];
        UIActivityViewController *shareProfile = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        weakify(self)
        shareProfile.completionWithItemsHandler = ^(NSString *activityType,BOOL completed,NSArray *returnedItems,NSError *activityError) {
            strongify(self)
            [self enablePlayer];
        };
        //关闭系统的一些activity类型
        shareProfile.excludedActivityTypes = @[UIActivityTypePostToTwitter,
                                               UIActivityTypeMessage,
                                               UIActivityTypeMail,
                                               UIActivityTypePrint,
                                               UIActivityTypeCopyToPasteboard,
                                               UIActivityTypeAssignToContact,
                                               UIActivityTypeSaveToCameraRoll,
                                               UIActivityTypeAddToReadingList,
                                               UIActivityTypePostToFlickr,
                                               UIActivityTypePostToVimeo,
                                               UIActivityTypePostToTencentWeibo,
                                               UIActivityTypeAirDrop];
        [self presentViewController:shareProfile animated:true completion:nil];
    } else if (action & MEVideoPlayUserActionNextItem) {
        self.previewRes = self.nextRes;
        _nextRes = nil;
        [self resetAllUIResources4NextPlayItem];
    }
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
