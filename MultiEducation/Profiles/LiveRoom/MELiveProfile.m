//
//  MELiveProfile.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/20.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEDoLiveVM.h"
#import "MELiveClassVM.h"
#import "MELiveProfile.h"
#import "MELiveMaskLayer.h"
#import <CRToast/CRToast.h>
#import "MELiveHeartBeatVM.h"
#import <libksygpulive/KSYTypeDef.h>
#import <libksygpulive/KSYStreamerBase.h>
#import <libksygpulive/KSYGPUStreamerKit.h>
#import <libksygpulive/KSYGPUBeautifyFilter.h>

#pragma mark --- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 班级选择panel

@interface MELiveClassChoosenPanel: MEBaseScene

@property (nonatomic, strong) NSArray<MEPBClass*>*multiClasses;
@property (nonatomic, strong) NSMutableArray<MEBaseButton *>*clsBtns;
@property (nonatomic, assign) NSUInteger currentClsIndex;

/**
 当前班级ID
 */
@property (nonatomic, assign) int64_t currentClsID;

@end

@implementation MELiveClassChoosenPanel

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _currentClsIndex = 0;
        self.layer.cornerRadius = ME_LAYOUT_CORNER_RADIUS;
        self.layer.masksToBounds = true;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [self configureLiveClassSubviews];
    }
    return self;
}

- (void)configureLiveClassSubviews {
    NSArray<MEPBClass*>*cls = [MEKits fetchCurrentUserMultiClasses];
    CGFloat itemSize = 50;
    CGFloat start_offset = ME_LAYOUT_BOUNDARY;
    CGFloat distance = 16;
    //标题
    MEBaseLabel *label = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = UIFontPingFangSCBold(METHEME_FONT_TITLE-1);
    label.textColor = [UIColor whiteColor];
    label.text = @"选择班级开启直播";
    [self addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(distance);
        make.left.equalTo(self).offset(start_offset);
    }];
    //按钮
    UIFont *font = UIFontPingFangSCMedium(METHEME_FONT_SUBTITLE-1);
    UIImage *normalIcon = [UIImage imageNamed:@"live_scene_normal"];
    UIImage *selectIcon = [UIImage imageNamed:@"live_scene_select"];
    MEBaseButton *lastBtn = nil;
    for (int i = 0;i < cls.count;i++) {
        MEPBClass *c = cls[i];UIImage *icon = (i==_currentClsIndex) ? selectIcon : normalIcon;
        MEBaseButton *btn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.titleLabel.font = font;
        btn.titleLabel.adjustsFontSizeToFitWidth = true;
        [btn setTitle:c.name forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:icon forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(userDidChoosenLiveClass:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom).offset(ME_LAYOUT_BOUNDARY);
            make.left.equalTo((lastBtn==nil)?self:lastBtn.mas_right).offset((lastBtn==nil)?start_offset:distance);
            make.width.height.equalTo(itemSize);
        }];
        //add reference
        [self.clsBtns addObject:btn];
        
        //flag
        lastBtn = btn;
    }
    self.multiClasses = [NSArray arrayWithArray:cls];
    _currentClsID = cls.firstObject.id_p;
}

#pragma mark --- lazy loading

- (NSMutableArray<MEBaseButton *>*)clsBtns {
    if (!_clsBtns) {
        _clsBtns = [NSMutableArray arrayWithCapacity:0];
    }
    return _clsBtns;
}

#pragma mark --- user interface actions

- (void)userDidChoosenLiveClass:(MEBaseButton *)btn {
    if (btn.tag == _currentClsIndex || btn.tag >= self.multiClasses.count) {
        return;
    }
    _currentClsIndex = btn.tag;
    UIImage *normalIcon = [UIImage imageNamed:@"live_scene_normal"];
    UIImage *selectIcon = [UIImage imageNamed:@"live_scene_select"];
    for (MEBaseButton *b in self.clsBtns) {
        UIImage *icon = (b.tag==_currentClsIndex) ? selectIcon : normalIcon;
        [b setBackgroundImage:icon forState:UIControlStateNormal];
    }
    MEPBClass *cls = self.multiClasses[_currentClsIndex];
    self.currentClsID = cls.id_p;
}

@end

#pragma mark --- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 直播类

@interface MELiveProfile ()

@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) NSTimer *timer, *heartBeatTimer;
@property (nonatomic, assign) CGFloat animateCount;

@property (nonatomic, strong) MEBaseScene *liveScene;
@property (nonatomic, strong) MEBaseScene *layoutScene;
@property (nonatomic, strong) MELiveMaskLayer *maskLayer;

/**
 班级选择panel
 */
@property (nonatomic, strong) MELiveClassChoosenPanel *choosenPanel;

@property (nonatomic, strong) MEPBClassLive *liveItem;
@property (nonatomic, assign) int64_t choosenClsID;

/**
 直播推流相关
 */
@property (nonatomic, strong) KSYGPUStreamerKit *liveKit;
@property (nonatomic, strong) GPUImageOutput<GPUImageInput> *filter;//滤镜
@property (nonatomic, assign) BOOL userDidExist;

@end

@implementation MELiveProfile

- (void)dealloc {
    if (self.timer) {
        if ([self.timer isValid]) {
            [self.timer invalidate];
        }
        self.timer = nil;
    }
    if (self.heartBeatTimer) {
        if ([self.heartBeatTimer isValid]) {
            [self.heartBeatTimer invalidate];
        }
        self.heartBeatTimer = nil;
    }
    
    [self.liveKit stopPreview];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KSYStreamStateDidChangeNotification object:nil];
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
    
    //live scene
    [self.view addSubview:self.liveScene];
    [self.liveScene makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    //layout scene
    [self.view addSubview:self.layoutScene];
    [self.layoutScene makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    MELiveClassChoosenPanel *panel = [[MELiveClassChoosenPanel alloc] initWithFrame:CGRectZero];
    [self.layoutScene addSubview:panel];
    self.choosenPanel = panel;
    [panel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.layoutScene).offset(adoptValue(100));
        make.left.equalTo(self.layoutScene).offset(ME_LAYOUT_MARGIN*1.5);
        make.right.equalTo(self.layoutScene).offset(-ME_LAYOUT_MARGIN*1.5);
        make.height.equalTo(130);
    }];
    
    NSUInteger btnSize = adoptValue(36);
    /*camera switch
    UIImage *img = [UIImage pb_iconFont:nil withName:@"\U0000e608" withSize:20 withColor:[UIColor whiteColor]];
    MEBaseButton *btn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:img forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(exchangeCameraVideoRecordEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(topOffset);
        make.right.equalTo(self.view).offset(-ME_LAYOUT_MARGIN*2);
        make.width.height.equalTo(btnSize);
    }];//*/
    
    [self.view addSubview:self.maskLayer];
    [self.maskLayer makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    //play back
    UIImage * img = [UIImage imageNamed:@"live_scene_close"];
    MEBaseButton * btn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:img forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(defaultGoBackStack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-ME_LAYOUT_ICON_HEIGHT);
        make.size.equalTo(CGSizeMake(btnSize, btnSize));
    }];
    //开启直播
    MEBaseButton *startLiveBtn = [[MEBaseButton alloc] initWithFrame:CGRectZero];
    startLiveBtn.titleLabel.font = UIFontPingFangSCMedium(METHEME_FONT_TITLE+1);
    [startLiveBtn setTitle:@"开启直播" forState:UIControlStateNormal];
    [startLiveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    startLiveBtn.backgroundColor = UIColorFromRGB(0xE59037);
    startLiveBtn.layer.cornerRadius = ME_HEIGHT_NAVIGATIONBAR*0.5;
    startLiveBtn.layer.masksToBounds = true;
    [startLiveBtn addTarget:self action:@selector(createLiveRoomEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.layoutScene addSubview:startLiveBtn];
    [startLiveBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.layoutScene);
        make.bottom.equalTo(self.layoutScene).offset(-100);
        make.width.equalTo(self.layoutScene.mas_width).multipliedBy(0.75);
        make.height.equalTo(ME_HEIGHT_NAVIGATIONBAR);
    }];
    
    //observes
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doLiveStreamStateChangeEvent) name:KSYStreamStateDidChangeNotification object:nil];
    
    self.sj_DisableGestures = YES;
    //self.sj_fadeArea = @[self.view, self.layoutScene, self.liveScene];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:true];
    [self initializedLiveStreamKit];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startTimerForMaskAnimation];
    //[self createLiveRoomEvent];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:false];
    [self.liveKit stopPreview];
    [self stopHeartBeatTimer];
}

#pragma mark --- lazy load

- (MEBaseScene *)liveScene {
    if (!_liveScene) {
        _liveScene = [[MEBaseScene alloc] initWithFrame:CGRectZero];
        _liveScene.backgroundColor = UIColorFromRGB(ME_THEME_COLOR_TEXT);
    }
    return _liveScene;
}

- (MEBaseScene *)layoutScene {
    if (!_layoutScene) {
        _layoutScene = [[MEBaseScene alloc] initWithFrame:CGRectZero];
        _layoutScene.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    }
    return _layoutScene;
}

- (MELiveMaskLayer *)maskLayer {
    if (!_maskLayer) {
        _maskLayer = [[MELiveMaskLayer alloc] initWithFrame:CGRectZero];
        _maskLayer.backgroundColor = UIColorFromRGB(ME_THEME_COLOR_TEXT);
        _maskLayer.tintColor = UIColorFromRGB(0xE15256);
    }
    return _maskLayer;
}

- (KSYGPUStreamerKit *)liveKit {
    if (!_liveKit) {
        _liveKit = [[KSYGPUStreamerKit alloc] init];
    }
    return _liveKit;
}

- (GPUImageOutput<GPUImageInput> *)filter {
    if (!_filter) {
        _filter = [[KSYGPUBeautifyExtFilter alloc] init];
    }
    return _filter;
}

#pragma mark --- live session methods

/**
 创建直播
 */
- (void)createLiveRoomEvent {
    if (self.liveItem) {
        return;
    }
    self.choosenClsID = self.choosenPanel.currentClsID;
    MEPBClassLive *live = [[MEPBClassLive alloc] init];
    [live setClassId:self.choosenClsID];
    MEDoLiveVM *doLive = [[MEDoLiveVM alloc] init];
    weakify(self)
    [doLive postData:[live data] hudEnable:true success:^(NSData * _Nullable resObj) {
        NSError *err;strongify(self)
        MEPBClassLive *liveKit = [MEPBClassLive parseFromData:resObj error:&err];
        if (err) {
            [MEKits handleError:err];
        } else {
            self.liveItem = liveKit;
            self.layoutScene.hidden = true;
            [self realStartPushStream4LiveAction];
        }
    } failure:^(NSError * _Nonnull error) {
        [MEKits handleError:error];
    }];
}

#pragma mark --- mask action

- (void)stopTimer {
    if (self.timer) {
        if ([self.timer isValid]) {
            [self.timer invalidate];
        }
        self.timer = nil;
    }
}

- (void)startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1/10 target:self selector:@selector(timerFired) userInfo:nil repeats:true];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

#define ME_LIVE_MASK_COUNT_MAX  50.f

- (void)timerFired {
    self.animateCount += 1;
    if (self.animateCount > ME_LIVE_MASK_COUNT_MAX) {
        [self stopTimer];
        CGFloat progress = 1.f;
        [self.maskLayer setProgress:progress];
        [self.maskLayer reveal];
        return;
    }
    CGFloat progress = self.animateCount/ME_LIVE_MASK_COUNT_MAX;
    [self.maskLayer setProgress:progress];
}

- (void)startTimerForMaskAnimation {
    self.animateCount = 0;
    [self startTimer];
}

#pragma mark --- live stream event

/**
 初始化采集
 */
- (void)initializedLiveStreamKit {
    //stream kit
    self.liveKit.cameraPosition = AVCaptureDevicePositionBack;
    self.liveKit.capturePixelFormat = kCVPixelFormatType_32BGRA;//采集
    self.liveKit.gpuOutputPixelFormat = kCVPixelFormatType_32BGRA;//输出
    self.liveKit.videoOrientation = [[UIApplication sharedApplication] statusBarOrientation];//视频方向
    //滤镜
    [self.liveKit setupFilter:self.filter];
    //预览
    [self.liveKit startPreview:self.liveScene];
    
    self.userDidExist = false;
}

- (void)doLiveStreamStateChangeEvent {
    KSYStreamState state = self.liveKit.streamerBase.streamState;
    NSString *alertString = nil;
    switch (state) {
        case KSYStreamStateConnected:
        {
            alertString = PBFormat(@"直播已建立，开始直播！");
        }
            break;
        case KSYStreamStateDisconnecting:
        {
            alertString = PBFormat(@"直播已断开，请检查网络！");
        }
            break;
        case KSYStreamStateError:
        {
            alertString = PBFormat(@"直播建立错误，请稍后重试！");
        }
            break;
            
        default:
            break;
    }
    if (alertString.length > 0 && !self.userDidExist) {
        NSDictionary *options = @{
                                  kCRToastTextKey : alertString,
                                  kCRToastFontKey : UIFontPingFangSCMedium(METHEME_FONT_TITLE),
                                  kCRToastTextColorKey : UIColorFromRGB(ME_THEME_COLOR_TEXT),
                                  kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                  kCRToastBackgroundColorKey : [UIColor whiteColor],
                                  kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                  kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                  kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar),
                                  kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                                  kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop)
                                  };
        [CRToastManager showNotificationWithOptions:options
                                    completionBlock:^{
                                        NSLog(@"Completed");
                                    }];
    }
}

/**
 真正开始直播推流
 */
- (void)realStartPushStream4LiveAction {
    if (!self.liveItem) {
        [self makeToast:@"直播内部错误！"];
        return;
    }
    NSString *streamUrl = self.liveItem.streamURL;
    [self.liveKit.streamerBase startStream:[NSURL URLWithString:streamUrl]];
    //貌似开启了一个直播心跳
    [self stopHeartBeatTimer];
    [self startHeartBeatTimer];
}

- (void)stopHeartBeatTimer {
    if (_heartBeatTimer) {
        if ([_heartBeatTimer isValid]) {
            [_heartBeatTimer invalidate];
        }
        _heartBeatTimer = nil;
    }
}

- (void)startHeartBeatTimer {
    _heartBeatTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(doLiveHeartBeatAction) userInfo:nil repeats:true];
    [[NSRunLoop currentRunLoop] addTimer:_heartBeatTimer forMode:NSRunLoopCommonModes];
}

- (void)doLiveHeartBeatAction {
    NSLog(@"do live heart beat...");
    //NSNumber *classID = [self.params pb_numberForKey:@"classID"];
    MEPBClassLive *live = [[MEPBClassLive alloc] init];
    [live setClassId:self.choosenClsID];
    MELiveHeartBeatVM *liveHeartBeat = [[MELiveHeartBeatVM alloc] init];
    [liveHeartBeat postData:[live data] hudEnable:false success:^(NSData * _Nullable resObj) {
//        NSError *err;strongify(self)
//        MEPBClassLive *liveKit = [MEPBClassLive parseFromData:resObj error:&err];
//        if (err) {
//            [MEKits handleError:err];
//        }
    } failure:^(NSError * _Nonnull error) {
        [MEKits handleError:error];
    }];
}

#pragma mark --- user interface actions

- (void)defaultGoBackStack {
    if (self.liveKit.streamerBase.streamState != KSYStreamStateConnected) {
        [super defaultGoBackStack];
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                             message:@"确定退出直播吗？"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    weakify(self)
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        strongify(self)
        self.userDidExist = true;
        [super defaultGoBackStack];
    }];
    [alertController addAction:action];
    action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:true completion:^{
        
    }];
}

- (void)exchangeCameraVideoRecordEvent {
    
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
