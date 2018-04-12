//
//  MEVerticalItem.h
//  fsc-ios
//
//  Created by nanhu on 2018/4/11.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEBaseScene.h"

@interface MEVerticalItem : MEBaseScene

/**
 item callback
 */
@property (nonatomic, copy) void(^MESubClassItemCallback)(NSUInteger tag);

+ (instancetype)itemWithTitle:(NSString *)title imageURL:(NSString *)urlString;

@end
