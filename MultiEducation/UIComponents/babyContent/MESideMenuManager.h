//
//  MEMenuManager.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/25.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MEBaseScene.h"
#import "MESideShowMenu.h"

typedef NS_ENUM(NSUInteger, MEUSERTouchMenuType) {
    MEUSERTouchMenuTypeHideMenu                        =   1   <<  0,//点击“操作列表”
    MEUSERTouchMenuTypeShowMenu                        =   1   <<  1,//点击具体操作列表
};

@interface MESideMenuManager : NSObject

- (instancetype)initWithMenuSuperView:(UIView *)view sideMenuCallback:(void(^)(MEUserTouchEventType type))sideMenuCallback operationMenuCallback:(void(^)(void))operationMenuCallback;
@end
