//
//  MEBabyArchivesVM.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/6/4.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEVM.h"
@class GuStudentArchivesPb;

@interface MEBabyArchivesVM : MEVM

+ (instancetype)vmWithPb:(GuStudentArchivesPb *)pb cmdCode:(NSString *)cmdCode;


@end
 
