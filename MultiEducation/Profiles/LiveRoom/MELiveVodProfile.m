//
//  MELiveVodProfile.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/20.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MELiveVodProfile.h"
#import <libksygpulive/KSYMoviePlayerController.h>

@interface MELiveVodProfile ()

@property (nonatomic, strong) NSDictionary *params;

@property (nonatomic, strong) MEBaseScene *liveVodScene;
@property (nonatomic, strong) KSYMoviePlayerController *playProfile;

@end

@implementation MELiveVodProfile

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
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
    
    //play scene
    [self.view addSubview:self.liveVodScene];
    [self.liveVodScene makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
    
    //play back
    NSUInteger btnSize = ME_LAYOUT_ICON_HEIGHT;
    CGFloat topOffset = ME_LAYOUT_BOUNDARY+ME_LAYOUT_MARGIN*2;
    UIImage *image = [UIImage pb_iconFont:nil withName:@"\U0000e6e2" withSize:btnSize withColor:[UIColor whiteColor]];
    MEBaseButton *btn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(defaultGoBackStack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(topOffset);
        make.left.equalTo(self.view).offset(ME_LAYOUT_MARGIN*2);
        make.size.equalTo(CGSizeMake(btnSize, btnSize));
    }];
    
    self.sj_fadeAreaViews = @[self.view];
    
    //observe
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playProfileDidFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self startPlayVodVideoEvent];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [self.playProfile stop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- lazy load

- (MEBaseScene *)liveVodScene {
    if (!_liveVodScene) {
        _liveVodScene = [[MEBaseScene alloc] initWithFrame:CGRectZero];
        _liveVodScene.autoresizesSubviews = true;
    }
    return _liveVodScene;
}

- (KSYMoviePlayerController *)playProfile {
    if (!_playProfile) {
        NSString *urlString = PBAvailableString(self.params[@"url"]);
        urlString = @"rtmp://live.hkstv.hk.lxdns.com/live/hks";
        //urlString = self.dataLive.videoURL;
        NSURL *url = [NSURL URLWithString:urlString];
        _playProfile = [[KSYMoviePlayerController alloc] initWithContentURL:url];
        _playProfile.controlStyle = 0;
        _playProfile.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _playProfile.shouldAutoplay = TRUE;
        _playProfile.shouldEnableVideoPostProcessing = TRUE;
        _playProfile.scalingMode = 1;
        _playProfile.videoDecoderMode = MPMovieVideoDecoderMode_AUTO;
        _playProfile.shouldLoop = NO;
        _playProfile.bufferTimeMax = 5;
        [_playProfile setTimeout:5 readTimeout:30];
        [_playProfile prepareToPlay];
    }
    return _playProfile;
}

#pragma mark --- start play

- (void)startPlayVodVideoEvent {
    //reset current play item
    [self.playProfile.view setFrame:self.liveVodScene.bounds];
    [self.liveVodScene addSubview:self.playProfile.view];
}

- (void)playProfileDidFinished:(NSNotification *)notify {
    [self defaultGoBackStack];
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
