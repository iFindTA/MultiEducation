//
//  MEShowBaby.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/20.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEM.h"

@interface MEShowBaby : MEM
 

/**
 userId   query ...where userId == self.currentUser.id
 */
@property (nonatomic, assign) int64_t userId;


/**
 where userId == userId 
 */
@property (nonatomic, assign) int64_t studentId;

@end
