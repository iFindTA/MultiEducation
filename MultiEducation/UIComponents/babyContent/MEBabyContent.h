//
//  MEChatContent.h
//  fsc-ios-wan
//
//  Created by 崔小舟 on 2018/4/10.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEBaseScene.h"
@class GuStudentArchivesPb;

/**
 scrollview scroll direction
 */
typedef NS_ENUM(NSUInteger, MEScrollViewDirection) {
    MEScrollViewDirectionUp                                    =   1   <<  0,//up direction
    MEScrollViewDirectionDown                                  =   1   <<  1,//down direction
    
};

/**
 类型定义
 */
typedef NS_ENUM(NSUInteger, MEBabyContentType) {
    MEBabyContentTypeGrowth                                      =   1   <<  0,     //宝宝档案
    MEBabyContentTypeEvaluate                                    =   1   <<  1,     //发展评价
    MEBabyContentTypeAnnounce                                    =   1   <<  2,     //园所公告
    MEBabyContentTypeSurvey                                      =   1   <<  3,     //问卷调查
    MEBabyContentTypeRecipes                                     =   1   <<  4,     //每周食谱
    MEBabyContentTypeLive                                        =   1   <<  5,     //直播课堂
    MEBabyContentTypeInterest                                    =   1   <<  6,     //趣事趣影
    MEBabyContentTypeTermEvaluate                                =   1   <<   7,     //学期评价
    MEBabyContentTypeHolidayAnnounce                             =   1   <<   8,     //假期通知
};

typedef void(^BabyContentScrollCallBack)(CGFloat contentOffsetY, MEScrollViewDirection direction);

typedef void(^BabyTabBarBadgeCallback)(NSInteger badge);

typedef void(^DidChangeSelectedBaby)(NSString *babyName, NSString *babyPortrait);

@interface MEBabyContent : MEBaseScene

@property (nonatomic, copy) BabyContentScrollCallBack babyContentScrollCallBack;
@property (nonatomic, copy) BabyTabBarBadgeCallback babyTabBarBadgeCallback;
@property (nonatomic, copy) DidChangeSelectedBaby didChangeSelectedBaby;

@property (nonatomic, copy) void((^DidSelectHandler)(NSInteger index, NSArray *photos));
@property (nonatomic, copy) void(^didUpdateBabyArchivesCallback) (GuStudentArchivesPb *pb);


- (void)removeNotiObserver;

- (void)viewWillAppear;

@end

