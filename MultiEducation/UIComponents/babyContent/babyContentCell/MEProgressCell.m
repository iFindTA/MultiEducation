//
//  MEProgressCell.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/16.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEProgressCell.h"
#import "AppDelegate.h"

@implementation MEProgressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(ClassAlbumPb *)pb {
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    MEPBUser *user = delegate.curUser;
    
    UIImage *img = [UIImage imageWithContentsOfFile: [NSString stringWithFormat: @"%@/%@", [MEKits currentUserDownloadPath], pb.filePath]];
    
    if ([pb.fileType isEqualToString: @"mp4"]) {
        NSString *urlStr = [NSString stringWithFormat: @"%@/%@%@", user.bucketDomain, pb.filePath, QN_VIDEO_FIRST_FPS_URL];
        [self.image sd_setImageWithURL: [NSURL URLWithString: urlStr]];
    } else {
        self.image.image = img;
    }
    
    if (pb.uploadStatu == MEUploadStatus_Waiting) {
        self.statusLabel.text = @"等待中...";
    } else if (pb.uploadStatu == MEUploadStatus_Success) {
        self.statusLabel.text = @"上传成功";
    } else if (pb.uploadStatu == MEUploadStatus_Failure) {
        self.statusLabel.text = @"上传失败";
    } else if(pb.uploadStatu == MEUploadStatus_Uploading) {
        self.statusLabel.text = [NSString stringWithFormat: @"正在上传   %d%%", pb.upPercent * 100];
    } else {
        self.statusLabel.text = @"已存在";
    }
    
    self.progress.progress = pb.upPercent;  
}

@end
