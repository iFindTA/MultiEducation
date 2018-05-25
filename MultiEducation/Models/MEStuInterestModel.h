//
//  MEStuInterestModel.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/5/24.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEM.h"
#import "Meuser.pbobjc.h"

@interface MEStuInterestModel : MEM

/**
 userId
 */
@property (nonatomic, assign) int64_t uId;

/**
 用户角色
 */
@property (nonatomic, assign) MEPBUserRole role;

/**
 标题
 */
@property (nonatomic, strong) NSString *title;

/**
 内容
 */
@property (nonatomic, strong) NSString *context;

/**
 图片
 */
@property (nonatomic, strong) NSArray *images;

/**
 选中的孩子
 */
@property (nonatomic, strong) NSArray *stuArr;


+ (void)saveOrUpdateStudentInterestModel:(MEStuInterestModel *)model;

+ (MEStuInterestModel *)fetchStudentInterestModel;

+ (void)deleteStudentInterestModel;





@end
