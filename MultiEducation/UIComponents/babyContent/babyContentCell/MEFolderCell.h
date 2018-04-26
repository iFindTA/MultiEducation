//
//  MEFolderCell.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/26.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseCell.h"
#import "MebabyAlbum.pbobjc.h"

@interface MEFolderCell : MEBaseCell

@property (weak, nonatomic) IBOutlet MEBaseLabel *folderNameLab;

- (void)setData:(ClassAlbumPb *)pb;

@end
