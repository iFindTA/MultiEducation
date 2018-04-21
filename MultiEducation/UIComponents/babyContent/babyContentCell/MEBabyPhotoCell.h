//
//  MEBabyPhotoCell.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/13.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseCollectionCell.h"
#import "MebabyAlbum.pbobjc.h"

@interface MEBabyPhotoCell : MEBaseCollectionCell

@property (weak, nonatomic) IBOutlet UIImageView *babyPhotoImage;

- (void)setData:(ClassAlbumPb *)pb;

@end
