//
//  MEPlayerControl.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/7.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import <AVKit/AVKit.h>
#import "MEPlayerControl.h"
#import <ZFPlayer/UIView+CustomControlView.h>

#define ME_COUNTDOWN_MAX_SECONDS                5
#define ME_PLAY_CONTROL_SHOW_BACKITEM           0

@interface MEPlayerControl ()<ZFPlayerControlViewDelagate>

@property (nonatomic, strong, readwrite) MPVolumeView *volume;

@property (nonatomic, strong, readwrite) UIView *airplayScene;

@property (nonatomic, strong, readwrite) MEBaseButton *likeBtn;
@property (nonatomic, strong, readwrite) MEBaseButton *shareBtn;
#if ME_PLAY_CONTROL_SHOW_BACKITEM
@property (nonatomic, strong, readwrite) MEBaseButton *backItem;
#endif

@property (nonatomic, strong) MEBaseScene *nextItemPanel;
@property (nonatomic, strong) MEBaseButton *nextItemBtn;

@property (nonatomic, assign) BOOL isFullScreen;

@property (nonatomic, strong) UIProgressView *progress;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat floatValue;

/**
 播放音频时的封面
 */
@property (nonatomic, strong, readwrite) MEBaseImageView *audioMask;

@end

@implementation MEPlayerControl

- (void)dealloc {
    if (self.timer) {
        if ([self.timer isValid]) {
            [self.timer invalidate];
        }
        _timer = nil;
    }
}

- (id)init {
    self = [super init];
    if (self) {
        //hide super control
        NSValue *hiddenValue = [NSNumber numberWithBool:true];
        [self setValue:hiddenValue forKeyPath:@"self.backBtn.hidden"];
        [self setValue:hiddenValue forKeyPath:@"self.titleLabel.hidden"];
        
        [self addSubview:self.audioMask];
#if ME_PLAY_CONTROL_SHOW_BACKITEM
        [self addSubview:self.backItem];
#endif
        if (@available(iOS 11.0, *)) {
            AVRoutePickerView *airplay = [[AVRoutePickerView alloc] initWithFrame:CGRectZero];
            airplay.tintColor = [UIColor whiteColor];
            [self addSubview:airplay];
            self.airplayScene = airplay;
        } else {
            [self addSubview:self.volume];
            self.airplayScene = self.volume;
        }
        [self addSubview:self.likeBtn];
        [self addSubview:self.shareBtn];
        [self addSubview:self.nextItemPanel];
        
        self.isFullScreen = false;
        [self.audioMask makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        CGFloat scale = 1.5;
        [self.airplayScene makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(ME_LAYOUT_BOUNDARY);
            make.right.equalTo(self).offset(-ME_LAYOUT_MARGIN*2);
            make.width.height.equalTo(ME_LAYOUT_BOUNDARY * scale);
        }];
#if ME_PLAY_CONTROL_SHOW_BACKITEM
        [self.backItem makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(ME_LAYOUT_BOUNDARY);
            make.left.equalTo(self).offset(ME_LAYOUT_MARGIN*2);
            make.width.height.equalTo(ME_LAYOUT_BOUNDARY * scale);
        }];
#endif
        [self.shareBtn makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.airplayScene);
            make.right.equalTo(self.airplayScene.mas_left).offset(-ME_LAYOUT_MARGIN);
            make.width.equalTo(ME_LAYOUT_BOUNDARY * scale);
        }];
        [self.likeBtn makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.shareBtn);
            make.right.equalTo(self.shareBtn.mas_left).offset(-ME_LAYOUT_MARGIN);
            make.width.equalTo(ME_LAYOUT_BOUNDARY * scale);
        }];
        
        //next recommand
        [self.nextItemPanel makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(ME_LAYOUT_SUBBAR_HEIGHT);
        }];
        UIColor *textColor = [UIColor colorWithWhite:0.8 alpha:0.8];
        MEBaseButton *btn = [[MEBaseButton alloc] initWithFrame:CGRectZero];
        btn.titleLabel.font = UIFontPingFangSC(METHEME_FONT_SUBTITLE);
        [btn setTitleColor:textColor forState:UIControlStateNormal];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn addTarget:self action:@selector(userDidTouchNextItemEvent) forControlEvents:UIControlEventTouchUpInside];
        [self.nextItemPanel addSubview:btn];
        self.nextItemBtn = btn;
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.nextItemPanel).insets(UIEdgeInsetsMake(0, ME_LAYOUT_BOUNDARY, 0, ME_HEIGHT_TABBAR));
        }];
        UIImage *closeImg = [UIImage pb_iconFont:nil withName:@"\U0000e633" withSize:ME_LAYOUT_SUBBAR_HEIGHT withColor:textColor];
        MEBaseButton *closeBtn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setImage:closeImg forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeNextRecommandItemEvent) forControlEvents:UIControlEventTouchUpInside];
        [self.nextItemPanel addSubview:closeBtn];
        [closeBtn makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(btn.mas_centerY);
            make.right.equalTo(self.nextItemPanel).offset(-ME_LAYOUT_MARGIN * 2);
            make.left.equalTo(btn.mas_right).offset(ME_LAYOUT_MARGIN);
            make.height.equalTo(closeBtn.mas_width);
        }];
        UIProgressView *progress = [[UIProgressView alloc] initWithFrame:CGRectZero];
        progress.tintColor = UIColorFromRGB(0xE15256);
        [self.nextItemPanel addSubview:progress];
        self.progress = progress;
        [progress makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.nextItemPanel);
            make.height.equalTo(ME_LAYOUT_LINE_HEIGHT * 2);
        }];
        
        [self updateUserActionItemState4Hidden:true];
        
        __weak typeof (&*self) weakSelf = self;
        self.delegate = weakSelf;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark --- lazy load

- (MPVolumeView *)volume {
    if (!_volume) {
        _volume = [[MPVolumeView alloc] initWithFrame:CGRectZero];
        _volume.showsVolumeSlider = false;
        UIImage *img = [UIImage imageNamed:@"video_play_airplay"];
        [_volume setRouteButtonImage:img forState:UIControlStateNormal];
    }
    return _volume;
}

- (AVRoutePickerView *)airplay  API_AVAILABLE(ios(11.0)){
    AVRoutePickerView *airplay = [[AVRoutePickerView alloc] initWithFrame:CGRectZero];
    airplay.tintColor = [UIColor whiteColor];
    return airplay;
}

- (MEBaseImageView *)audioMask {
    if (!_audioMask) {
        _audioMask = [[MEBaseImageView alloc] initWithFrame:CGRectZero];
        //_audioMask.backgroundColor = [UIColor pb_randomColor];
    }
    return _audioMask;
}
#if ME_PLAY_CONTROL_SHOW_BACKITEM
- (MEBaseButton *)backItem {
    if (!_backItem) {
        UIImage *image = [UIImage imageNamed:@"video_play_back"];
        _backItem = [MEBaseButton buttonWithType:UIButtonTypeCustom];
        [_backItem setImage:image forState:UIControlStateNormal];
        [_backItem addTarget:self action:@selector(userDidTouchVideoBackEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backItem;
}
#endif

- (MEBaseButton *)likeBtn {
    if (!_likeBtn) {
        UIImage *image = [UIImage imageNamed:@"video_play_like"];
        _likeBtn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
        [_likeBtn setImage:image forState:UIControlStateNormal];
        [_likeBtn addTarget:self action:@selector(userDidTouchVideoLikeEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likeBtn;
}

- (MEBaseButton *)shareBtn {
    if (!_shareBtn) {
        UIImage *image = [UIImage imageNamed:@"video_play_share"];
        _shareBtn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setImage:image forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(userDidTouchVideoShareEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}

- (MEBaseScene *)nextItemPanel {
    if (!_nextItemPanel) {
        _nextItemPanel = [[MEBaseScene alloc] initWithFrame:CGRectZero];
        _nextItemPanel.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
        _nextItemPanel.hidden = true;
    }
    return _nextItemPanel;
}

#pragma mark --- controlView Delegate

//- (void)zf_playerPlayEnd {
//    NSLog(@"did play end");
//}
//
//- (void)zf_controlView:(UIView *)controlView fullScreenAction:(UIButton *)sender {
//    NSLog(@"did touch full button");
//}

#pragma mark --- Touch Event

- (void)userDidTouchVideoBackEvent {
    if (self.videoPlayControlCallback) {
        self.videoPlayControlCallback(MEVideoPlayUserActionBack);
    }
}

- (void)userDidTouchVideoLikeEvent {
    if (self.videoPlayControlCallback) {
        self.videoPlayControlCallback(MEVideoPlayUserActionLike);
    }
}

- (void)userDidTouchVideoShareEvent {
    if (self.videoPlayControlCallback) {
        self.videoPlayControlCallback(MEVideoPlayUserActionShare);
    }
}

#pragma mark --- extern event

- (void)updatePlayControlMask4ResourceType:(MEPBResourceType)type {
    self.audioMask.hidden = (type != MEPBResourceType_MepbresourceTypebookAudio);
}

- (void)updateUserActionItemState4Hidden:(BOOL)hide {
    [self.airplayScene setHidden:hide];
#if ME_PLAY_CONTROL_SHOW_BACKITEM
    [self.backItem setHidden:hide];
#endif
    if (!self.isFullScreen) {
        [self.likeBtn setHidden:hide];
        [self.shareBtn setHidden:hide];
    }
}

- (void)updateVideoPlayerState:(BOOL)fullscreen {
    self.isFullScreen = fullscreen;
    [self.likeBtn setHidden:fullscreen];
    [self.shareBtn setHidden:fullscreen];
    [self.airplayScene setHidden:false];
}

- (void)updateUserLikeItemState:(BOOL)like {
    UIImage *image = [UIImage imageNamed:like?@"video_play_dolike":@"video_play_like"];
    [self.likeBtn setImage:image forState:UIControlStateNormal];
}

- (void)showNextPlayItem:(NSString *)title {
    NSString * text = [NSString stringWithFormat:@"%d秒后自动播放下一个：%@", ME_COUNTDOWN_MAX_SECONDS, title.copy];
    [self.nextItemBtn setTitle:text forState:UIControlStateNormal];
    self.nextItemPanel.hidden = false;
    [self startTimer];
}

- (void)closeNextRecommandItemEvent {
    self.nextItemPanel.hidden = true;
    if (self.timer) {
        if ([self.timer isValid]) {
            [self.timer invalidate];
        }
        _timer = nil;
    }
    [self stopTimer];
}

- (void)userDidTouchNextItemEvent {
    [self stopTimer];
    if (self.videoPlayControlCallback) {
        self.videoPlayControlCallback(MEVideoPlayUserActionNextItem);
    }
}

- (void)startTimer {
    self.floatValue = 0.f;self.progress.progress = 0.f;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(timeFired) userInfo:nil repeats:true];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)timeFired {
    self.floatValue += 1.f/ME_COUNTDOWN_MAX_SECONDS;
    if (self.floatValue >= 1.f) {
        self.progress.progress = 1.f;
        [self.timer invalidate];
        _timer = nil;
        
        if (self.videoPlayControlCallback) {
            self.videoPlayControlCallback(MEVideoPlayUserActionNextItem);
        }
        return;
    }
    self.progress.progress = self.floatValue;
}

- (void)stopTimer {
    if (self.timer) {
        if ([self.timer isValid]) {
            [self.timer invalidate];
        }
        _timer = nil;
    }
}

- (void)clean {
    [self stopTimer];
    self.floatValue = 0.f;self.progress.progress = 0.f;
    [self updateUserLikeItemState:false];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
