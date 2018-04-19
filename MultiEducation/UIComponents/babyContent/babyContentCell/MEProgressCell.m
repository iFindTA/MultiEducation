//
//  MEProgressCell.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/16.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEProgressCell.h"

@implementation MEProgressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.retryLabel.hidden = YES;
}

- (void)setImageData:(MEPhoto *)photo {
    self.image.image = photo.image;
    self.nameLabel.text = @"图片";
    self.progress.progress = photo.progress;
    if (photo.status != UploadFail) {
        self.retryLabel.hidden = YES;
    } else {
        self.retryLabel.hidden = NO;
    }
}

- (void)setVideoData:(MEVideo *)video {
    self.image.image = video.image;
    self.nameLabel.text = @"图片";
    self.progress.progress = video.progress;
    if (video.status != UploadFail) {
        self.retryLabel.hidden = YES;
    } else {
        self.retryLabel.hidden = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
