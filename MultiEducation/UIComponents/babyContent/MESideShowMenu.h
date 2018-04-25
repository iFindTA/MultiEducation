//
//  MESideShowMenu.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/25.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseScene.h"

typedef NS_ENUM(NSUInteger, MEUserTouchEventType) {
    MEUserTouchEventTypeUpload                 =   1   <<  0,//上传
    MEUserTouchEventTypeNewFolder              =   1   <<  1,//新建文件夹
    MEUserTouchEventTypeMove             =   1   <<  2,//移动文件
    MEUserTouchEventTypeDelete           =   1   <<  3//删除文件

};
@interface MESideShowMenu : MEBaseScene

- (instancetype)initWitHandler:(void(^)(MEUserTouchEventType type))handler;

@end
