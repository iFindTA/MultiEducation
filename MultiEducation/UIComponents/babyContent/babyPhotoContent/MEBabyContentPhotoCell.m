//
//  MECollectionViewCell.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/13.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBabyContentPhotoCell.h"
#import "AppDelegate.h"
#import "Meuser.pbobjc.h"

@implementation MEBabyContentPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.floderNameLabel.hidden = YES;
}


- (void)setData:(ClassAlbumPb *)pb {
    if (pb.isParent) {
        self.floderNameLabel.hidden = NO;
        self.floderNameLabel.text = pb.fileName;
        [self setCoverImage: pb];
    } else {
        self.floderNameLabel.hidden = YES;
        self.floderNameLabel.text = @"";
        [self setCoverImage: pb];
    }
}

- (void)setCoverImage:(ClassAlbumPb *)pb {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    MEPBUser *user = delegate.curUser;
    if ([pb.fileType isEqualToString: @"mp4"]) {
        NSString *urlStr = [NSString stringWithFormat: @"%@/%@%@", user.bucketDomain, pb.filePath, QN_VIDEO_FIRST_FPS_URL];
        [self.photoIcon sd_setImageWithURL: [NSURL URLWithString: urlStr]];
    } else {
        NSString *urlStr = [NSString stringWithFormat: @"%@/%@", user.bucketDomain, pb.filePath];
        [self.photoIcon sd_setImageWithURL: [NSURL URLWithString: urlStr]];
    }
}

@end
