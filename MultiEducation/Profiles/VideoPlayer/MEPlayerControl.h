//
//  MEPlayerControl.h
//  MultiEducation
//
//  Created by nanhu on 2018/4/7.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEUIBaseHeader.h"
#import "ZFPlayerControlView.h"
#import <MediaPlayer/MediaPlayer.h>

typedef NS_ENUM(NSUInteger, MEVideoPlayUserAction) {
    MEVideoPlayUserActionLike                               =   1   <<  0,  //
    MEVideoPlayUserActionShare                              =   1   <<  1
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

@end
