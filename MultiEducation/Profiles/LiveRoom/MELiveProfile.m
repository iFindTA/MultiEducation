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

@interface MELiveProfile ()

@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) NSTimer *timer, *heartBeatTimer;
@property (nonatomic, assign) CGFloat animateCount;

@property (nonatomic, strong) MEBaseScene *liveScene;
@property (nonatomic, strong) MELiveMaskLayer *maskLayer;

@property (nonatomic, strong) MEPBClassLive *liveItem;

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
    
    NSUInteger btnSize = ME_LAYOUT_ICON_HEIGHT;
    CGFloat topOffset = ME_LAYOUT_BOUNDARY+ME_LAYOUT_MARGIN*2;
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
    
    [self.liveScene addSubview:self.maskLayer];
    [self.maskLayer makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.liveScene);
    }];
    
    //play back
    UIImage * img = [UIImage pb_iconFont:nil withName:@"\U0000e6e2" withSize:btnSize withColor:[UIColor whiteColor]];
    MEBaseButton * btn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:img forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(defaultGoBackStack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(topOffset);
        make.left.equalTo(self.view).offset(ME_LAYOUT_MARGIN*2);
        make.size.equalTo(CGSizeMake(btnSize, btnSize));
    }];
    
    //observes
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doLiveStreamStateChangeEvent) name:KSYStreamStateDidChangeNotification object:nil];
    
    self.sj_fadeArea = @[self.liveScene];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:true];
    PBMAINDelay(ME_ANIMATION_DURATION, ^{
        [self initializedLiveStreamKit];
        [self createLiveRoomEvent];
    });
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
    if (!self.params) {
        [SVProgressHUD showErrorWithStatus:@"直播创建失败！"];
        return;
    }
    if (self.liveItem) {
        return;
    }
    NSNumber *classID = [self.params pb_numberForKey:@"classID"];
    MEPBClassLive *live = [[MEPBClassLive alloc] init];
    [live setClassId:classID.longLongValue];
    MEDoLiveVM *doLive = [[MEDoLiveVM alloc] init];
    weakify(self)
    [doLive postData:[live data] hudEnable:true success:^(NSData * _Nullable resObj) {
        NSError *err;strongify(self)
        MEPBClassLive *liveKit = [MEPBClassLive parseFromData:resObj error:&err];
        if (err) {
            [MEKits handleError:err];
        } else {
            self.liveItem = liveKit;
            [self startTimerForMaskAnimation];
        }
    } failure:^(NSError * _Nonnull error) {
        strongify(self)
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
        [self realStartPushStream4LiveAction];
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
        [SVProgressHUD showErrorWithStatus:@"直播内部错误！"];
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
    NSNumber *classID = [self.params pb_numberForKey:@"classID"];
    MEPBClassLive *live = [[MEPBClassLive alloc] init];
    [live setClassId:classID.longLongValue];
    MELiveHeartBeatVM *liveHeartBeat = [[MELiveHeartBeatVM alloc] init];
    weakify(self)
    [liveHeartBeat postData:[live data] hudEnable:false success:^(NSData * _Nullable resObj) {
//        NSError *err;strongify(self)
//        MEPBClassLive *liveKit = [MEPBClassLive parseFromData:resObj error:&err];
//        if (err) {
//            [MEKits handleError:err];
//        }
    } failure:^(NSError * _Nonnull error) {
        strongify(self)
        [MEKits handleError:error];
    }];
}

#pragma mark --- user interface actions

- (void)defaultGoBackStack {
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
