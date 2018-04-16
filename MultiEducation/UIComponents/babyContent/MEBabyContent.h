//
//  MEChatContent.h
//  fsc-ios-wan
//
//  Created by 崔小舟 on 2018/4/10.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEBaseScene.h"

/**
 scrollview scroll direction
 */
typedef NS_ENUM(NSUInteger, MEScrollViewDirection) {
    MEScrollViewDirectionnUp                                    =   1   <<  0,//up direction
    MEScrollViewDirectionDown                                  =   1   <<  1,//down direction
    
};

/**
 类型定义
 */
typedef NS_ENUM(NSUInteger, MEBabyContentType) {
    MEBabyContentTypeGrowth                                      =   1   <<  0,//成长档案
    MEBabyContentTypeEvaluate                                    =   1   <<  1,//发展评价
    MEBabyContentTypeAnnounce                                    =   1   <<  2,//园所公告
    MEBabyContentTypeSurvey                                      =   1   <<  3,//问卷调查
    MEBabyContentTypeRecipes                                     =   1   <<  4,//每周食谱
    MEBabyContentTypeLive                                        =   1   <<  5,//直播课堂
};

typedef void(^BabyContentScrollCallBack)(CGFloat contentOffsetY, MEScrollViewDirection direction);

@interface MEBabyContent : MEBaseScene

@property (nonatomic, copy) BabyContentScrollCallBack babyContentScrollCallBack;

@end

