//
//  MEBabyGrowthVM.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/20.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEVM.h"
#import "Meuser.pbobjc.h"

@interface MEStudentVM : MEVM

+ (instancetype)vmWithPb:(StudentPb *)pb;

@end
