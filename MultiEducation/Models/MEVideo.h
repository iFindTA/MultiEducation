//
//  MEVideo.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/19.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MebabyAlbum.pbobjc.h"
#import "MEPhoto.h"
 
@interface MEVideo : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSData *video;
@property (nonatomic, strong) NSString *md5FileName;

@property (nonatomic, assign) UploadStatus status;
@property (nonatomic, assign) float progress;

@property (nonatomic, assign) ClassAlbumPb *albumPb;

@end
