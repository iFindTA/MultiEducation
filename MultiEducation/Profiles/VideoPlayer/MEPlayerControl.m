//
//  MEPlayerControl.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/7.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEPlayerControl.h"
#import <Masonry/Masonry.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MEPlayerControl ()

@property (nonatomic, strong) MPVolumeView *volume;

@end

@implementation MEPlayerControl

- (id)init {
    self = [super init];
    if (self) {
        MPVolumeView *volume = [[MPVolumeView alloc] initWithFrame:CGRectZero];
        volume.showsVolumeSlider = false;
        [self addSubview:volume];
        self.volume = volume;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.volume makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-10);
        make.width.height.equalTo(20);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
