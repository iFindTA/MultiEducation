//
//  MENewsInfoVM.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/24.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEVM.h"
#import "MenewsInfo.pbobjc.h"

@interface MENewsInfoVM : MEVM

+ (instancetype)vmWithPb:(OsrInformationPb *)pb;

@end
