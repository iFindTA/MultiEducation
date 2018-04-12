//
//  MEGardenRootProfile.h
//  fsc-ios
//
//  Created by nanhu on 2018/4/9.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEBaseProfile.h"

/**
 类型定义
 */
typedef NS_ENUM(NSUInteger, METableViewScrollDirection) {
    METableViewScrollDirectionUp                                    =   1   <<  0,//up direction
    METableViewScrollDirectionDown                                  =   1   <<  1,//down direction

};

@interface MEGardenRootProfile : MEBaseProfile

@end
