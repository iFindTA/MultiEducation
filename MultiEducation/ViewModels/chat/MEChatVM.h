//
//  MEChatVM.h
//  MultiEducation
//
//  Created by mac on 2018/4/20.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEVM.h"

@interface MEChatVM : MEVM

/**
 截取视频中特定时间的截图
 
 @param videoURL 本地视频地址
 @param time 时间节点
 @return image截图
 
 */
+ (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;

/**
 按指定宽高比压缩
 
 @param sourceImage 被压缩图片
 @param size 预计尺寸
 @return 压缩后图片
 */
+ (UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;

/**
 图片转base64
 
 @param image 图片
 @return base64编码
 */
+ (NSString *)imageToBase64:(UIImage *)image;

/**
 base64转图片
 
 @param string base64编码
 @return 图片
 */
+ (UIImage *)base64ToUIImage:(NSString *)string;

@end
