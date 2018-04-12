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
    MEBabyContentTypeBabyPhoto                                   =   1   <<  0,//宝宝相册
    MEBabyContentTypeBeautyDay                                   =   1   <<  1,//一日精彩
    MEBabyContentTypeGrowth                                      =   1   <<  2,//成长档案
    MEBabyContentTypeEvaluate                                    =   1   <<  3,//发展评价
    MEBabyContentTypeInvite                                      =   1   <<  4,//邀请家人
};

@protocol MEBabyContentDelegate <NSObject>
@optional

- (void)didTouchBabyContentType:(MEBabyContentType)type;

@end

@interface MEBabyContent : MEBaseScene

@property (nonatomic, weak) id <MEBabyContentDelegate> delegate;

@end
