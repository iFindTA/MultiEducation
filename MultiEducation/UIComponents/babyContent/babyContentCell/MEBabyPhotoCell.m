//
//  MEBabyPhotoCell.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/13.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBabyPhotoCell.h"
#import "MebabyAlbum.pbobjc.h"
#import "AppDelegate.h"

@implementation MEBabyPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
}


- (void)setData:(ClassAlbumPb *)pb {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    MEPBUser *user = delegate.curUser;
    
    NSString *urlStr = [NSString stringWithFormat: @"%@%@", user.bucketDomain, pb.filePath];
    if ([pb.fileType  isEqualToString: @"jpg"]) {
        [_babyPhotoImage sd_setImageWithURL: [NSURL URLWithString: urlStr] placeholderImage: [UIImage imageNamed: @"appicon_placeholder"]];
    }
    
    
}

@end
