//
//  MERePasswordVM.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/22.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEVM.h"
#import "Meuser.pbobjc.h"

@interface MERePasswordVM : MEVM

+ (instancetype)vmWithModel:(MEPBUser *)usr;

@end
