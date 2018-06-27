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
@class MEPBClass;

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
 update user gender
 */
+ (BOOL)updateUserGender:(int32_t)gender uid:(int64_t)uid;

/**
 update user avatar
 */
+ (BOOL)updateUserAvatar:(NSString *)avatar uid:(int64_t)uid;

/**
 update user's nick
 */
+ (BOOL)updateUserNick:(NSString *)nick uid:(int64_t)uid;


/**
 when userRole == MEPBUserRole_Parent, update user's ParentPb
 */
+ (BOOL)updateUserStuent:(ParentsPb *)parentsPb uid:(int64_t)uid;

@end

NS_ASSUME_NONNULL_END
