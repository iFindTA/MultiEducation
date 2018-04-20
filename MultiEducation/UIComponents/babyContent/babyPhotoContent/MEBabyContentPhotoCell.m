//
//  MECollectionViewCell.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/13.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBabyContentPhotoCell.h"

@implementation MEBabyContentPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.floderNameLabel.hidden = YES;
}

- (void)setData:(MEPhoto *)photo {
    

    self.floderNameLabel.text = photo.albumPb.fileName;
    if (photo.albumPb.isParent) {
        self.floderNameLabel.hidden = NO;
    } else {
        self.floderNameLabel.hidden = YES;
    }
    
    if ([photo.albumPb.fileType isEqualToString: @"mp4"]) {
        self.photoIcon.image = photo.image;
    } else {
       [self.photoIcon sd_setImageWithURL: [NSURL URLWithString: photo.urlStr]];
    }
}

@end
