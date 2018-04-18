//
//  MEBabyAlbumVM.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/18.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEVM.h"
#import "MebabyAlbum.pbobjc.h"
#import <WHC_ModelSqlite.h>

@interface MEBabyAlbumVM : MEVM
 
+ (instancetype)vmWithPb:(ClassAlbumPb *)qnPb;

@end
