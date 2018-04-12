//
//  MEVideoPreview.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/9.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEVideoPreview.h"
#import <PBKits/PBKits.h>
#import <AVFoundation/AVFoundation.h>

static NSUInteger ME_PREVIEW_ITEM_SIZE                      =   60;

@interface MEVideoPreview ()

@property (nonatomic, strong) UIButton *recallBtn;
@property (nonatomic, strong) UIButton *ensureBtn;

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@end

@implementation MEVideoPreview

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //撤回
        NSUInteger size = ME_PREVIEW_ITEM_SIZE/MESCREEN_SCALE;UIColor *color = [UIColor whiteColor];
        UIImage *img = [UIImage pb_iconFont:nil withName:@"\U0000e76b" withSize:size withColor:color];
        self.recallBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.recallBtn setImage:img forState:UIControlStateNormal];
        [self.recallBtn addTarget:self action:@selector(recallTouchEvent) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.recallBtn];
        
        //确认
        img = [UIImage pb_iconFont:nil withName:@"\U0000e611" withSize:size withColor:color];
        self.ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.ensureBtn setImage:img forState:UIControlStateNormal];
        [self.ensureBtn addTarget:self action:@selector(ensureTouchEvent) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.ensureBtn];
        
        //*player
        self.player = [AVPlayer playerWithPlayerItem:nil];
        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:nil];
        playerLayer.frame = self.bounds;
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        [self.layer insertSublayer:playerLayer atIndex:0];
        self.playerLayer = playerLayer;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
        //*/
        self.backgroundColor = [UIColor blackColor];
        
        [self setNeedsLayout];
        [self setNeedsDisplay];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSUInteger size = ME_PREVIEW_ITEM_SIZE;
    CGFloat recall_scale = 0.4;CGFloat ensure_scale = 2-recall_scale;
    [self.recallBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).multipliedBy(recall_scale);
        make.bottom.equalTo(self).offset(-20);
        make.width.height.equalTo(size);
    }];
    [self.ensureBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).multipliedBy(ensure_scale);
        make.bottom.equalTo(self).offset(-20);
        make.width.height.equalTo(size);
    }];
}

- (void)recallTouchEvent {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchRecallWithPreview:)]) {
        [self.delegate didTouchRecallWithPreview:self];
    }
}

- (void)ensureTouchEvent {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchEnsureWithPreview:)]) {
        [self.delegate didTouchEnsureWithPreview:self];
    }
}

- (void)autoPlayWithVideoPath:(NSString *)path {
    NSAssert(path.length != 0, @"video preview player got an empty path!");
    sleep(0.08);
    //*
    NSURL *sourceMovieURL = [NSURL fileURLWithPath:path];
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:sourceMovieURL options:nil];
    AVPlayerItem * playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    self.player = [AVPlayer playerWithPlayerItem:playerItem];
    //player layer
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.frame = self.bounds;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.layer insertSublayer:playerLayer atIndex:0];
    self.playerLayer = playerLayer;
    
    //*/
    /*
    NSURL *sourceMovieURL = [NSURL fileURLWithPath:path];
    self.player = [AVPlayer playerWithURL:sourceMovieURL];
    [self.playerLayer setPlayer:self.player];
    sleep(0.08);
    [self.player play];
    //*/
    
    /*
    NSURL *sourceMovieURL = [NSURL fileURLWithPath:path];
    ZFPlayerModel *model = [[ZFPlayerModel alloc] init];
    model.fatherView = self.playerScene;
    model.videoURL = sourceMovieURL;
    [self.player playerControlView:nil playerModel:model];
    [self.player autoPlayTheVideo];
    //*/
}

- (void)autoPlay {
    [self.player play];
}

- (void)playbackFinished:(NSNotification *)notif {
    [self.player seekToTime:CMTimeMake(0, 1)];
    [self.player play];
}

- (void)resetVideoPreview {
    [self.player pause];
    [self.playerLayer removeFromSuperlayer];
    _playerLayer = nil; _player = nil;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
