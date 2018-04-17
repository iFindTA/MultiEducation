//
//  MEPhotoSelectProfile.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/16.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MWPhotoBrowser.h"

typedef void(^UploadImagesHandler)(void);

@interface MEPhotoSelectProfile : MWPhotoBrowser

@property (nonatomic, copy) UploadImagesHandler uploadImagesHandler;

@end
