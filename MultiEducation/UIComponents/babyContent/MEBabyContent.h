//
//  MEChatContent.h
//  fsc-ios-wan
//
//  Created by 崔小舟 on 2018/4/10.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEBaseScene.h"

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

@interface MEBabyContent : MEBaseScene

@end

