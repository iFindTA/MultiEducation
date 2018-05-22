//
//  MESendIntersetingProfile.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/5/18.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseProfile.h"

@interface MESendIntersetingProfile : MEBaseProfile

@property (nonatomic, copy) void (^didSubmitStuInterestCallback) (void);

@end
 
