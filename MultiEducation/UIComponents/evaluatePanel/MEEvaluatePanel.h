//
//  MEEvaluatePanel.h
//  MultiEducation
//
//  Created by nanhu on 2018/5/18.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseScene.h"
#import "MEStudentInfoVM.h"
#import "MEStudentListVM.h"

typedef NS_ENUM(NSUInteger, MEEvaluateType) {
    MEEvaluateTypeHome                                  =   0,//在家里的评价
    MEEvaluateTypeSchool                                =   1,//在学校的评价
};

typedef NS_ENUM(NSUInteger, MEQuestionType) {
    MEQuestionTypSingle                                 =   1,//单选
    MEQuestionTypeMulti                                 =   2,//多选
    MEQuestionTypeInput                                 =   3,//填空
};

NS_ASSUME_NONNULL_BEGIN

@interface MEEvaluatePanel : MEBaseScene

/**
 callback submit
 */
@property (nonatomic, copy) MEEvaluatePanelCallback callback;

/**
 切换学生去评估
 */
- (void)exchangedStudent2Evaluate:(GrowthEvaluate *)growth;

/**
 instance method
 */
- (id)initWithFrame:(CGRect)frame father:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
