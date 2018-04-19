//
//  MEWatchItem.h
//  MultiEducation
//
//  Created by nanhu on 2018/4/19.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEM.h"

/**
 用户观看资源 用以存到本地数据库
 */
@interface MEWatchItem : MEM

/**
 资源ID
 */
@property (nonatomic, assign) NSUInteger resId;

/**
 资源类型ID
 */
@property (nonatomic, assign) NSUInteger resTypeId;

/**
 资源类型 数据类型 如课程视频 绘本音频 其他视频等
 */
@property (nonatomic, assign) NSUInteger type;

/**
 观看时长
 */
@property (nonatomic, assign) NSTimeInterval watchInterval;

/**
 年月日 时分秒
 */
@property (nonatomic, assign) NSTimeInterval watchTimestamp;

/**
 资源标题
 */
@property (nonatomic, copy, nullable) NSString *title;

/**
 资源描述
 */
@property (nonatomic, copy, nullable) NSString *desc;

/**
 资源简介
 */
@property (nonatomic, copy, nullable) NSString *intro;

/**
 资源封面
 */
@property (nonatomic, copy, nullable) NSString *coverImg;

/**
 资源路径
 */
@property (nonatomic, copy, nullable) NSString *filePath;

@end
