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
}

- (void)setData:(MEPhoto *)photo {
    if ([photo.fileType  isEqualToString: @"jpg"]) {
        [_babyPhotoImage sd_setImageWithURL: [NSURL URLWithString: photo.urlStr] placeholderImage: [UIImage imageNamed: @"appicon_placeholder"]];
    } else {
        _babyPhotoImage.image = photo.image;
    }
}

@end
