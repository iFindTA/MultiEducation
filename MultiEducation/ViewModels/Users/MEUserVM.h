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
#import "MephoneInfo.pbobjc.h"

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
 save user into local db
 */
+ (BOOL)saveUser:(MEPBUser *)user;

/**
 fetch device info
 */
+ (MEPBPhoneInfo *)getDeviceInfo;

/**
 getter user role
 */
- (MEUserRole)userRole;

@end

NS_ASSUME_NONNULL_END
