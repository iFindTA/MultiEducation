//
//  MEPlayerControl.h
//  MultiEducation
//
//  Created by nanhu on 2018/4/7.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseScene.h"
#import "ZFPlayerControlView.h"
#import <MediaPlayer/MediaPlayer.h>

typedef NS_ENUM(NSUInteger, MEVideoPlayUserAction) {
    MEVideoPlayUserActionLike                               =   1   <<  0,  //收藏
    MEVideoPlayUserActionShare                              =   1   <<  1,  //分享
    MEVideoPlayUserActionNextItem                           =   1   <<  2,  //用户点击下一个视频
};

@interface MEPlayerControl : ZFPlayerControlView

@property (nonatomic, strong, readonly) MPVolumeView *volume;

@property (nonatomic, strong, readonly) MEBaseButton *likeBtn;
@property (nonatomic, strong, readonly) MEBaseButton *shareBtn;

/**
 user touch event
 */
@property (nonatomic, copy) void(^videoPlayControlCallback)(MEVideoPlayUserAction action);

/**
 whether show or display user action item
 */
- (void)updateUserActionItemState4Hidden:(BOOL)hide;

/**
 全屏时隐藏收藏&分享按钮
 */
- (void)updateVideoPlayerState:(BOOL)fullscreen;

/**
 next play item when did end play
 */
- (void)showNextPlayItem:(NSString *)title;

- (void)closeNextRecommandItemEvent;

@end
