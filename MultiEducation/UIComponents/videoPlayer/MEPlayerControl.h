//
//  MEPlayerControl.h
//  MultiEducation
//
//  Created by nanhu on 2018/4/7.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseScene.h"
#import "Meres.pbobjc.h"
#import "ZFPlayerControlView.h"
#import <MediaPlayer/MediaPlayer.h>

typedef NS_ENUM(NSUInteger, MEVideoPlayUserAction) {
    MEVideoPlayUserActionBack                               =   1   <<  0,  //返回
    MEVideoPlayUserActionLike                               =   1   <<  1,  //收藏
    MEVideoPlayUserActionShare                              =   1   <<  2,  //分享
    MEVideoPlayUserActionNextItem                           =   1   <<  3,  //用户点击下一个视频
};

@interface MEPlayerControl : ZFPlayerControlView

@property (nonatomic, strong, readonly) MPVolumeView *volume;

@property (nonatomic, strong, readonly) MEBaseButton *likeBtn;
@property (nonatomic, strong, readonly) MEBaseButton *shareBtn;

@property (nonatomic, strong, readonly) MEBaseImageView *audioMask;

/**
 user touch event
 */
@property (nonatomic, copy) void(^videoPlayControlCallback)(MEVideoPlayUserAction action);

/**
 update control mask for audio/video
 */
- (void)updatePlayControlMask4ResourceType:(MEPBResourceType)type;

/**
 whether show or display user action item
 */
- (void)updateUserActionItemState4Hidden:(BOOL)hide;

/**
 全屏时隐藏收藏&分享按钮
 */
- (void)updateVideoPlayerState:(BOOL)fullscreen;

/**
 user do like or not
 */
- (void)updateUserLikeItemState:(BOOL)like;

/**
 next play item when did end play
 */
- (void)showNextPlayItem:(NSString *)title;

- (void)closeNextRecommandItemEvent;

/**
 退出全屏模式
 */
- (void)exitFullscreenMode;

/**
 用户点击新的item
 */
- (void)clean;

@end
