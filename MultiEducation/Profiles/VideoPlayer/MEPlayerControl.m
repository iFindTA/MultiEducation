//
//  MEPlayerControl.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/7.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEPlayerControl.h"

@interface MEPlayerControl ()

@property (nonatomic, strong, readwrite) MPVolumeView *volume;

@property (nonatomic, strong, readwrite) MEBaseButton *likeBtn;
@property (nonatomic, strong, readwrite) MEBaseButton *shareBtn;

@end

@implementation MEPlayerControl

- (id)init {
    self = [super init];
    if (self) {
        [self addSubview:self.likeBtn];
        [self addSubview:self.volume];
        [self addSubview:self.shareBtn];
        
        [self updateUserActionItemState4Hidden:true];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat scale = 1.5;
    [self.shareBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(ME_LAYOUT_BOUNDARY);
        make.right.equalTo(self).offset(-ME_LAYOUT_BOUNDARY);
        make.width.height.equalTo(ME_LAYOUT_BOUNDARY * scale);
    }];
    [self.likeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.shareBtn);
        make.right.equalTo(self.shareBtn.mas_left).offset(-ME_LAYOUT_MARGIN);
        make.width.equalTo(ME_LAYOUT_BOUNDARY * scale);
    }];
    [self.volume makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.likeBtn);
        make.right.equalTo(self.likeBtn.mas_left).offset(-ME_LAYOUT_MARGIN);
        make.width.equalTo(ME_LAYOUT_BOUNDARY * scale);
    }];
    
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

#pragma mark --- Touch Event

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

- (void)updateUserActionItemState4Hidden:(BOOL)hide {
    [self.volume setHidden:hide];
    [self.likeBtn setHidden:hide];
    [self.shareBtn setHidden:hide];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
