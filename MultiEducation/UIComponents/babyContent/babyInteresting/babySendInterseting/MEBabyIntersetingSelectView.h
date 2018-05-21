//
//  MEBabyIntersetingSelectView.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/5/18.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseScene.h"
@class MEStudentModel;

@interface MEBabyIntersetingSelectView : MEBaseScene

@property (nonatomic, copy) void(^DidRemakeMasonry) (UIView *bottomView);

@property (nonatomic, assign) int64_t semester;
@property (nonatomic, assign) int64_t classId;
@property (nonatomic, assign) int64_t gradeId;

- (void)customSubviews;

- (NSArray <MEStudentModel *> *)getInterestingStuArr;

@end
 
