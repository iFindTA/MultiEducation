//
//  MEStudentVM.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/20.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEVM.h"
#import "Meuser.pbobjc.h"
#import "Meuser.pbobjc.h"

@interface MEStudentVM : MEVM
 
+ (instancetype)vmWithPb:(StudentPb *)pb cmdCode:(NSString*)cmdCode;


/**
 为当前用户 save 选中的宝宝

 */
+ (void)saveSelectBaby:(StudentPb *)baby;


/**
 获取当前用户保存的  选中的宝宝
 */
+ (StudentPb *)fetchSelectBaby;



@end
