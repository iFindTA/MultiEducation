//
//  MEKits.h
//  MultiEducation
//
//  Created by nanhu on 2018/4/5.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

/**
 公共基础类 主要类方法处理
 */
@interface MEKits : NSObject

+ (NSString *)sandboxPath;

/**
 获取文件大小
 */
+ (CGFloat)fileSizeWithPath:(NSString *)path;


/**
 压缩image到制定大小以下

 @param image original image
 @param maxLength maxLength that you can accept
 @return image after compress
 */
+ (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength;

@end
