//
//  MEEvaluatePanel.h
//  MultiEducation
//
//  Created by nanhu on 2018/5/18.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseScene.h"
#import "MEStudentInfoVM.h"

typedef NS_ENUM(NSUInteger, MEEvaluateType) {
    MEEvaluateTypeHome                                  =   0,//在家里的评价
    MEEvaluateTypeSchool                                =   1,//在学校的评价
};

NS_ASSUME_NONNULL_BEGIN

@protocol MEEvaluateDelegate, MEEvaluateDataSource;
@interface MEEvaluatePanel : MEBaseScene

/**
 delegate
 */
@property (nonatomic, weak) id<MEEvaluateDelegate> delegate;

/**
 datasource
 */
@property (nonatomic, weak) id<MEEvaluateDataSource> dataSource;

/**
 user did exchanged to student
 */
- (void)didChanged2Student4ID:(int64_t)sid;

/**
 切换学生去评估
 */
- (void)exchangedStudent2Evaluate:(GrowthEvaluate *)growth;

/**
 instance method
 */
- (id)initWithFrame:(CGRect)frame father:(UIView *)view;

@end

/**
 Evaluate DataSource
 */
@protocol MEEvaluateDataSource <NSObject>

/**
 评价的标题 eg.在家里/在学校
 */
- (NSArray * _Nullable)titlesForEvaluate;

/**
 在学校/在家里 tab是否可以编辑
 */
- (BOOL)editableForEvaluateType:(MEEvaluateType)type;

@end

/**
 Evaluate Delegate
 */
@protocol MEEvaluateDelegate <NSObject>

@end

NS_ASSUME_NONNULL_END
