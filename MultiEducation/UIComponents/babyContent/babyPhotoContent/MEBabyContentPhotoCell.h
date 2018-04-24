//
//  MECollectionViewCell.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/13.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseCollectionCell.h"
#import "MebabyAlbum.pbobjc.h"

@interface MEBabyContentPhotoCell : MEBaseCollectionCell

@property (weak, nonatomic) IBOutlet UIImageView *photoIcon;

@property (weak, nonatomic) IBOutlet MEBaseLabel *floderNameLabel;

- (void)setData:(ClassAlbumPb *)pb;

@end
