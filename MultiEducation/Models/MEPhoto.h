//
//  MEPhoto.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/17.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MWPhotoBrowser.h>
#import "MebabyAlbum.pbobjc.h"

typedef enum : NSUInteger {
    UploadSucc,
    UploadFail,
    Uploading,
} UploadStatus;

@interface MEPhoto : NSObject

@property (nonatomic, strong) MWPhoto *photo;
/**
 bucketDomain + md5FileName
 */
@property (nonatomic, strong) NSString *urlStr;

/**
 image
 */
@property (nonatomic, strong) UIImage *image;
/**
 七牛 key   通过bucketDomain + md5FileName 获取文件
 */
@property (nonatomic, strong) NSString *md5FileName;
/**
 文件大小
 */
@property (nonatomic, assign) u_int64_t fileSize;

/**
 上传状态
 */
@property (nonatomic, assign) UploadStatus status;

/**
 上传进度
 */
@property (nonatomic, assign) float progress;

/**
 yyyy-MM
 */
@property (nonatomic, strong) NSString *dateStr;

/**
  jpg   mp4
 */
@property (nonatomic, strong) NSString *fileType;
/**
 对应的pb 文件
 */
@property (nonatomic, assign) ClassAlbumPb *albumPb;

@end
