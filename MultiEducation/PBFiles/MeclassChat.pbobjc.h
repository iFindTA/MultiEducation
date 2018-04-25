// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: MEClassChat.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <Protobuf/GPBProtocolBuffers.h>
#else
 #import "GPBProtocolBuffers.h"
#endif

#if GOOGLE_PROTOBUF_OBJC_VERSION < 30002
#error This file was generated by a newer version of protoc which is incompatible with your Protocol Buffer library sources.
#endif
#if 30002 < GOOGLE_PROTOBUF_OBJC_MIN_SUPPORTED_VERSION
#error This file was generated by an older version of protoc which is incompatible with your Protocol Buffer library sources.
#endif

// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

CF_EXTERN_C_BEGIN

@class MECUser;
@class MESession;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - MeclassChatRoot

/**
 * Exposes the extension registry for this file.
 *
 * The base class provides:
 * @code
 *   + (GPBExtensionRegistry *)extensionRegistry;
 * @endcode
 * which is a @c GPBExtensionRegistry that includes all the extensions defined by
 * this file and all files that it depends on.
 **/
@interface MeclassChatRoot : GPBRootObject
@end

#pragma mark - MECUser

typedef GPB_ENUM(MECUser_FieldNumber) {
  MECUser_FieldNumber_SessionId = 1,
  MECUser_FieldNumber_UserId = 2,
  MECUser_FieldNumber_InviterId = 3,
  MECUser_FieldNumber_Status = 4,
  MECUser_FieldNumber_CreatedDate = 5,
  MECUser_FieldNumber_ModifiedDate = 6,
  MECUser_FieldNumber_Timestamp = 7,
};

@interface MECUser : GPBMessage

/** 群组id */
@property(nonatomic, readwrite) int64_t sessionId;

/** 用户id */
@property(nonatomic, readwrite) int64_t userId;

/** 邀请者id */
@property(nonatomic, readwrite) int64_t inviterId;

/** 状态 */
@property(nonatomic, readwrite) int32_t status;

/** 创建时间 */
@property(nonatomic, readwrite) int64_t createdDate;

/** 修改时间 */
@property(nonatomic, readwrite) int64_t modifiedDate;

/** 时间戳 */
@property(nonatomic, readwrite) int64_t timestamp;

@end

#pragma mark - MECSession

typedef GPB_ENUM(MECSession_FieldNumber) {
  MECSession_FieldNumber_Id_p = 1,
  MECSession_FieldNumber_Uuid = 2,
  MECSession_FieldNumber_Name = 3,
  MECSession_FieldNumber_ClassId = 4,
  MECSession_FieldNumber_CreatedDate = 5,
  MECSession_FieldNumber_Timestamp = 6,
  MECSession_FieldNumber_UserArray = 7,
  MECSession_FieldNumber_BaseSession = 8,
  MECSession_FieldNumber_SessionStatus = 9,
};

@interface MECSession : GPBMessage

/** session id */
@property(nonatomic, readwrite) int64_t id_p;

/** 会话id */
@property(nonatomic, readwrite, copy, null_resettable) NSString *uuid;

/** session名称 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *name;

/** 班级id */
@property(nonatomic, readwrite) int64_t classId;

/** 群主id */
@property(nonatomic, readwrite) int64_t createdDate;

/** 时间戳 */
@property(nonatomic, readwrite) int64_t timestamp;

/** 班级用户 */
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<MECUser*> *userArray;
/** The number of items in @c userArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger userArray_Count;

/** 继承的基类会话 */
@property(nonatomic, readwrite, strong, null_resettable) MESession *baseSession;
/** Test to see if @c baseSession has been set. */
@property(nonatomic, readwrite) BOOL hasBaseSession;

/** 会话状态1正常0禁言家长 */
@property(nonatomic, readwrite) int32_t sessionStatus;

@end

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)