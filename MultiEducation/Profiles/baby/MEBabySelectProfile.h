//
//  MEBabySelectProfile.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/20.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseProfile.h"
 
typedef void(^SelectBabyCallBack)(StudentPb *studenPb);
 
@interface MEBabySelectProfile : MEBaseProfile

@property (nonatomic, copy) SelectBabyCallBack selectBabyCallBack;

@end
