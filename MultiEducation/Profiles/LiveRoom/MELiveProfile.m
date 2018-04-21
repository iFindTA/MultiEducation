//
//  MELiveProfile.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/20.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MELiveProfile.h"
#import "MELiveMaskLayer.h"
#import <libksygpulive/KSYTypeDef.h>
#import <libksygpulive/KSYStreamerBase.h>
#import <libksygpulive/KSYGPUStreamerKit.h>
#import <libksygpulive/KSYGPUBeautifyFilter.h>

@interface MELiveProfile ()

@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) MELiveMaskLayer *maskLayer;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat animateCount;

/**
 直播推流相关
 */
@property (nonatomic, strong) KSYGPUStreamerKit *liveKit;

@end

@implementation MELiveProfile

- (void)dealloc {
    if (self.timer) {
        if ([self.timer isValid]) {
            [self.timer invalidate];
        }
        self.timer = nil;
    }
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
    
    [self.view addSubview:self.maskLayer];
    [self.maskLayer makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startTimerForMaskAnimation];
}

#pragma mark --- lazy load

- (MELiveMaskLayer *)maskLayer {
    if (!_maskLayer) {
        _maskLayer = [[MELiveMaskLayer alloc] initWithFrame:CGRectZero];
        _maskLayer.backgroundColor = UIColorFromRGB(ME_THEME_COLOR_TEXT_GRAY);
    }
    return _maskLayer;
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
}

#define ME_LIVE_MASK_COUNT_MAX  20.f

- (void)timerFired {
    self.animateCount += 1;
    if (self.animateCount > ME_LIVE_MASK_COUNT_MAX) {
        [self stopTimer];
        CGFloat progress = 1.f;
        [self.maskLayer setProgress:progress];
        return;
    }
    CGFloat progress = self.animateCount/ME_LIVE_MASK_COUNT_MAX;
    [self.maskLayer setProgress:progress];
}

- (void)startTimerForMaskAnimation {
    self.animateCount = 0;
    [self startTimer];
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
