// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: MERes.proto

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

@class MEPBRes;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - MeresRoot

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
@interface MeresRoot : GPBRootObject
@end

#pragma mark - MEPBRes

typedef GPB_ENUM(MEPBRes_FieldNumber) {
  MEPBRes_FieldNumber_ResId = 1,
  MEPBRes_FieldNumber_Title = 2,
  MEPBRes_FieldNumber_CoverImg = 3,
  MEPBRes_FieldNumber_Type = 4,
  MEPBRes_FieldNumber_Intro = 5,
  MEPBRes_FieldNumber_Desc = 6,
  MEPBRes_FieldNumber_FilePath = 7,
};

@interface MEPBRes : GPBMessage

/** 资源ID */
@property(nonatomic, readwrite) int64_t resId;

/** 资源标题 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *title;

/** 资源封面 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *coverImg;

/** 资源地址 */
@property(nonatomic, readwrite) int32_t type;

/** 资源简介 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *intro;

/** 资源描述 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *desc;

/** 资源路径 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *filePath;

@end

#pragma mark - MEPBResType

typedef GPB_ENUM(MEPBResType_FieldNumber) {
  MEPBResType_FieldNumber_Id_p = 1,
  MEPBResType_FieldNumber_Title = 2,
  MEPBResType_FieldNumber_IconPath = 3,
  MEPBResType_FieldNumber_ResPbArray = 4,
};

@interface MEPBResType : GPBMessage

/** 类型ID */
@property(nonatomic, readwrite) int64_t id_p;

/** 类型标题 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *title;

/** 类型图标 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *iconPath;

/** 类型相关推荐列表 */
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<MEPBRes*> *resPbArray;
/** The number of items in @c resPbArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger resPbArray_Count;

@end

#pragma mark - MEPBResList

typedef GPB_ENUM(MEPBResList_FieldNumber) {
  MEPBResList_FieldNumber_ResPbArray = 1,
};

@interface MEPBResList : GPBMessage

/** 列表类型 */
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<MEPBRes*> *resPbArray;
/** The number of items in @c resPbArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger resPbArray_Count;

@end

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
