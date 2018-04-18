//
//  MEPhoto.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/17.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MWPhotoBrowser.h>

typedef enum : NSUInteger {
    UploadSucc,
    UploadFail,
    Uploading,
} UploadStatus;

@interface MEPhoto : NSObject

@property (nonatomic, strong) MWPhoto *photo;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, strong) NSString *urlStr;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *md5FileName;

@property (nonatomic, assign) UploadStatus status;
@property (nonatomic, assign) float progress;

@end
