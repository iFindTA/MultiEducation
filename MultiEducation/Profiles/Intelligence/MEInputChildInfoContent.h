//
//  MEInputChildInfoContent_ Intelligence.h
//  MultiEducation
//
//  Created by cxz on 2018/6/25.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseScene.h"
@class StudentPb;

@interface MEInputChildInfoContent : MEBaseScene

@property (nonatomic, strong) StudentPb *inputStu;  //当前正在录入信息的孩子

@property (nonatomic, copy) void(^didAddChildSuccessCallback) (void);
@property (nonatomic, copy) void(^didSkipAddChildCallback) (void);

@end
