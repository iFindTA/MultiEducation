//
//  MERePasswordVM.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/22.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEVM.h"
#import "MeuserData.pbobjc.h"

@interface MERePasswordVM : MEVM

+ (instancetype)vmWithModel:(FscUserPb *)usr;

@end
