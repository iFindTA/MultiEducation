//
//  MEUserVM.h
//  MultiEducation
//
//  Created by nanhu on 2018/4/5.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEVM.h"

NS_ASSUME_NONNULL_BEGIN

@class MEUser;
@interface MEUserVM : MEVM

/**
 create instance
 */
+ (instancetype)vmWithModel:(MEUser *)usr;

/**
 fetch user who signed-in latest
 */
+ (MEUser * _Nullable)fetchLatestSignedInUser;

/**
 whether there is exist a valid user who did signed-in, and its token is avaliable!
 */
+ (BOOL)whetherExistValidSignedInUser;

@end

NS_ASSUME_NONNULL_END
