// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: MECarrier.proto

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

NS_ASSUME_NONNULL_BEGIN

#pragma mark - MecarrierRoot

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
@interface MecarrierRoot : GPBRootObject
@end

#pragma mark - CmdSignPb

typedef GPB_ENUM(CmdSignPb_FieldNumber) {
  CmdSignPb_FieldNumber_CmdCode = 1,
  CmdSignPb_FieldNumber_ReqCode = 2,
  CmdSignPb_FieldNumber_RespCode = 3,
  CmdSignPb_FieldNumber_Msg = 4,
  CmdSignPb_FieldNumber_Source = 5,
  CmdSignPb_FieldNumber_Token = 6,
  CmdSignPb_FieldNumber_OpenTransaction = 7,
  CmdSignPb_FieldNumber_IsAcross = 8,
  CmdSignPb_FieldNumber_CmdVersion = 9,
  CmdSignPb_FieldNumber_SessionToken = 10,
};

@interface CmdSignPb : GPBMessage

/** 命令code */
@property(nonatomic, readwrite, copy, null_resettable) NSString *cmdCode;

/** 请求code */
@property(nonatomic, readwrite, copy, null_resettable) NSString *reqCode;

/** 响应code */
@property(nonatomic, readwrite, copy, null_resettable) NSString *respCode;

/** 消息 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *msg;

/** 二进制数据 */
@property(nonatomic, readwrite, copy, null_resettable) NSData *source;

/** token */
@property(nonatomic, readwrite, copy, null_resettable) NSString *token;

/** 是否开启事务 */
@property(nonatomic, readwrite) BOOL openTransaction;

/** 是否跨节点请求 */
@property(nonatomic, readwrite) BOOL isAcross;

/** 命令版本 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *cmdVersion;

/** 会话token */
@property(nonatomic, readwrite, copy, null_resettable) NSString *sessionToken;

@end

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)