//
//  MEStudentVM.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/20.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEVM.h"
#import "Meuser.pbobjc.h"
#import <WHC_ModelSqlite.h>

@interface MEStudentVM : MEVM
 
+ (instancetype)vmWithPb:(StudentPb *)pb;

+ (void)saveSelectBaby:(StudentPb *)student;



@end
