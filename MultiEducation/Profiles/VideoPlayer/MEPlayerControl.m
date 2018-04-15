//
//  MEPlayerControl.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/7.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEPlayerControl.h"
#import <ZFPlayer/UIView+CustomControlView.h>

@interface MEPlayerControl ()<ZFPlayerControlViewDelagate>

@property (nonatomic, strong, readwrite) MPVolumeView *volume;

@property (nonatomic, strong, readwrite) MEBaseButton *likeBtn;
@property (nonatomic, strong, readwrite) MEBaseButton *shareBtn;

@property (nonatomic, strong) MEBaseScene *nextItemPanel;
@property (nonatomic, strong) MEBaseButton *nextItemBtn;

@property (nonatomic, assign) BOOL isFullScreen;

@end

@implementation MEPlayerControl

- (id)init {
    self = [super init];
    if (self) {
        //hide super control
        NSValue *hiddenValue = [NSNumber numberWithBool:true];
        [self setValue:hiddenValue forKeyPath:@"self.backBtn.hidden"];
        [self setValue:hiddenValue forKeyPath:@"self.titleLabel.hidden"];
        
        [self addSubview:self.likeBtn];
        [self addSubview:self.volume];
        [self addSubview:self.shareBtn];
        [self addSubview:self.nextItemPanel];
        
        self.isFullScreen = false;
        
        CGFloat scale = 1.5;
        [self.volume makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(ME_LAYOUT_BOUNDARY);
            make.right.equalTo(self).offset(-ME_LAYOUT_BOUNDARY);
            make.width.height.equalTo(ME_LAYOUT_BOUNDARY * scale);
        }];
        [self.shareBtn makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.volume);
            make.right.equalTo(self.volume.mas_left).offset(-ME_LAYOUT_MARGIN);
            make.width.equalTo(ME_LAYOUT_BOUNDARY * scale);
        }];
        [self.likeBtn makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.shareBtn);
            make.right.equalTo(self.shareBtn.mas_left).offset(-ME_LAYOUT_MARGIN);
            make.width.equalTo(ME_LAYOUT_BOUNDARY * scale);
        }];
//        [self.volume makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self).offset(ME_LAYOUT_BOUNDARY);
//            make.right.equalTo(self).offset(-ME_LAYOUT_MARGIN * 2-ME_LAYOUT_BOUNDARY * scale * 2-ME_LAYOUT_BOUNDARY);
//            make.width.height.equalTo(ME_LAYOUT_BOUNDARY * scale);
//        }];
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
            make.right.equalTo(self.nextItemPanel).offset(-ME_LAYOUT_BOUNDARY-ME_LAYOUT_MARGIN);
            make.left.equalTo(btn.mas_right).offset(ME_LAYOUT_MARGIN);
            make.height.equalTo(closeBtn.mas_width);
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
    if (!self.isFullScreen) {
        [self.likeBtn setHidden:hide];
        [self.shareBtn setHidden:hide];
    }
}

- (void)updateVideoPlayerState:(BOOL)fullscreen {
    self.isFullScreen = fullscreen;
    [self.likeBtn setHidden:fullscreen];
    [self.shareBtn setHidden:fullscreen];
    [self.volume setHidden:false];
}

- (void)showNextPlayItem:(NSString *)title {
    NSString * text = [NSString stringWithFormat:@"下一个：%@", title.copy];
    [self.nextItemBtn setTitle:text forState:UIControlStateNormal];
    self.nextItemPanel.hidden = false;
}

- (void)closeNextRecommandItemEvent {
    self.nextItemPanel.hidden = true;
}

- (void)userDidTouchNextItemEvent {
    if (self.videoPlayControlCallback) {
        self.videoPlayControlCallback(MEVideoPlayUserActionNextItem);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
