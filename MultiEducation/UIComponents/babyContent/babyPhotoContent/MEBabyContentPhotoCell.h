//
//  MECollectionViewCell.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/13.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseCollectionCell.h"
#import "MebabyAlbum.pbobjc.h"

typedef void(^BabyPhotoSelectHandler)(ClassAlbumPb *pb);

@interface MEBabyContentPhotoCell : MEBaseCollectionCell

@property (weak, nonatomic) IBOutlet UIImageView *photoIcon;

@property (weak, nonatomic) IBOutlet MEBaseLabel *floderNameLabel;

@property (weak, nonatomic) IBOutlet MEBaseButton *selectBtn;

@property (weak, nonatomic) IBOutlet MEBaseLabel *countLab;

@property (nonatomic, copy) BabyPhotoSelectHandler handler;

- (void)setData:(ClassAlbumPb *)pb;

@end
