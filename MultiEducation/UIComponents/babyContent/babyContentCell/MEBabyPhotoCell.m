//
//  MEBabyPhotoCell.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/13.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBabyPhotoCell.h"
#import "AppDelegate.h"

@implementation MEBabyPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.babyPhotoImage.contentMode = UIViewContentModeScaleAspectFill;
    self.babyPhotoImage.clipsToBounds = true;
}

- (void)setData:(ClassAlbumPb *)pb {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    MEPBUser *user = delegate.curUser;
    if ([pb.fileType isEqualToString: @"mp4"]) {
        NSString *urlStr = [NSString stringWithFormat: @"%@/%@%@", user.bucketDomain, pb.filePath, QN_VIDEO_FIRST_FPS_URL];
        [self.babyPhotoImage sd_setImageWithURL: [NSURL URLWithString: urlStr] placeholderImage: [UIImage imageNamed: @"baby_content_photo_placeholder"]];
    } else {
        NSString *urlStr = [NSString stringWithFormat: @"%@/%@", user.bucketDomain, pb.filePath];
        [self.babyPhotoImage sd_setImageWithURL: [NSURL URLWithString: urlStr] placeholderImage: [UIImage imageNamed: @"baby_content_photo_placeholder"]];
    }
}

@end
