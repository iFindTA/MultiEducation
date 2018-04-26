//
//  MEFolderPatch.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/26.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEVM.h"
#import "MebabyAlbum.pbobjc.h"


@interface MEFolderPatchVM : MEVM
 
+ (instancetype)vmWithPb:(ClassAlbumListPb *)pb;

@end
