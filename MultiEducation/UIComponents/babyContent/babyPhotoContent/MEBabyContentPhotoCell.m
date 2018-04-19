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
    
    [self.photoIcon sd_setImageWithURL: [NSURL URLWithString: photo.urlStr]];
    self.floderNameLabel.text = photo.albumPb.fileName;
    if (photo.albumPb.isParent) {
        self.floderNameLabel.hidden = NO;
    } else {
        self.floderNameLabel.hidden = YES;
    }
    
}

@end
