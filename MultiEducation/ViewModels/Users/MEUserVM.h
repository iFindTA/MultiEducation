//
//  MEUserVM.h
//  MultiEducation
//
//  Created by nanhu on 2018/4/5.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEVM.h"
#import "Meuser.pbobjc.h"
#import "MesignIn.pbobjc.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEUserVM : MEVM

/**
 create instance
 */
+ (instancetype)vmWithModel:(MEPBUser *)usr;

/**
 create instance
 */
+ (instancetype)vmWithPB:(MEPBSignIn *)pb;

/**
 fetch user who signed-in latest
 */
+ (MEPBUser * _Nullable)fetchLatestSignedInUser;

/**
 whether there is exist a valid user who did signed-in, and its token is avaliable!
 */
+ (BOOL)whetherExistValidSignedInUser;

/**
 getter user role
 */
- (MEUserRole)userRole;

@end

NS_ASSUME_NONNULL_END
