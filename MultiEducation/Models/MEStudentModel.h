//
//  MEStudentModel.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/5/19.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEM.h"

typedef NS_ENUM(NSUInteger, SelectStatus) {
    Selected         =                                                  1 <<                               0, //已选中
    Unselected       =                                                  1 <<                               1, //未选中
    CantSelect       =                                                  1 <<        2  //不可选
};

@interface MEStudentModel : MEM

/**
 学生id
 */
@property (nonatomic, assign) int64_t stuId;
/**
 所在班级id
 */
@property (nonatomic, assign) int64_t classId;
/**
 性别
 */
@property (nonatomic, assign) int32_t gender;
/**
 姓的首字母
 */
@property (nonatomic, strong) NSString *letter;
/**
 头像urlString
 */
@property (nonatomic, strong) NSString *portrait;
/**
 姓名
 */
@property (nonatomic, strong) NSString *name;
/**
 选中状态  已选中  未选中   不可选
 */
@property (nonatomic, assign) SelectStatus status;



@end
