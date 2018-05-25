//
//  MEBabyIntersetingSelectView.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/5/18.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseScene.h"
#import "MEStudentModel.h"

@interface MEBabyIntersetingSelectView : MEBaseScene

@property (nonatomic, copy) void(^didSelectStuCallback) (NSArray *stuArr);
@property (nonatomic, copy) void(^DidRemakeMasonry) (UIView *bottomView);

@property (nonatomic, assign) int64_t semester;
@property (nonatomic, assign) int64_t classId;
@property (nonatomic, assign) int64_t gradeId;

@property (nonatomic, strong) NSMutableArray <MEStudentModel *> *dataArr;

- (void)customSubviews;

- (NSArray <MEStudentModel *> *)getInterestingStuArr;

@end
 
