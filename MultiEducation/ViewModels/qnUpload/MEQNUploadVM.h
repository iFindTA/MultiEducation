//
//  MEQNUploadVM.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/17.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEVM.h"
#import "MebabyAlbum.pbobjc.h"


@interface MEQNUploadVM : MEVM

+ (instancetype)vmWithPb:(ClassAlbumListPb *)qnPb;

@end
