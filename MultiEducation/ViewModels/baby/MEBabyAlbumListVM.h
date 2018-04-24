//
//  MEBabyAlbumVM.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/18.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEVM.h"
#import "MebabyAlbum.pbobjc.h"
 
@interface MEBabyAlbumListVM : MEVM
 
+ (instancetype)vmWithPb:(ClassAlbumPb *)pb;

/**
 保存请求到的album
 
 */
+ (BOOL)saveAlbum:(ClassAlbumPb *)album;


/**
 获取当前用户所在班级所有照片信息
 */
+ (NSArray *)fetchUserAllAlbum;



/**
 根据classId查询数据库中数据

 @param classId  classid
 @return classAlbumsArray
 */
+ (NSArray *)fetchAlbmsWithClassId:(int64_t)classId;




@end
