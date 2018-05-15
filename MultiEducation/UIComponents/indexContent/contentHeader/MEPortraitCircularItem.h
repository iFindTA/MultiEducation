//
//  MEPortraitCircularItem.h
//  MultiEducation
//
//  Created by nanhu on 2018/5/15.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseScene.h"

@interface MEPortraitCircularItem : MEBaseScene

/**
 item callback
 */
@property (nonatomic, copy) void(^callback)(NSUInteger tag);

+ (instancetype)itemWithTitle:(NSString *)title imageURL:(NSString *)urlString;

@end
