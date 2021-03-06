// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: MEForwardEvaluate.proto

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

@class ForwardEvaluate;
@class Month;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - MeforwardEvaluateRoot

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
@interface MeforwardEvaluateRoot : GPBRootObject
@end

#pragma mark - Month

typedef GPB_ENUM(Month_FieldNumber) {
  Month_FieldNumber_Month = 1,
  Month_FieldNumber_Name = 2,
};

@interface Month : GPBMessage

/** 月份 */
@property(nonatomic, readwrite) int32_t month;

/** 月份名称 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *name;

@end

#pragma mark - ForwardEvaluate

typedef GPB_ENUM(ForwardEvaluate_FieldNumber) {
  ForwardEvaluate_FieldNumber_Id_p = 1,
  ForwardEvaluate_FieldNumber_GradeId = 2,
  ForwardEvaluate_FieldNumber_Semester = 3,
  ForwardEvaluate_FieldNumber_Name = 4,
  ForwardEvaluate_FieldNumber_MonthsArray = 5,
};

@interface ForwardEvaluate : GPBMessage

/** ID */
@property(nonatomic, readwrite) int64_t id_p;

/** 年级 */
@property(nonatomic, readwrite) int64_t gradeId;

/** 学期 */
@property(nonatomic, readwrite) int32_t semester;

/** 名称 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *name;

/** 月份 */
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<Month*> *monthsArray;
/** The number of items in @c monthsArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger monthsArray_Count;

@end

#pragma mark - ForwardEvaluateList

typedef GPB_ENUM(ForwardEvaluateList_FieldNumber) {
  ForwardEvaluateList_FieldNumber_ListArray = 1,
};

@interface ForwardEvaluateList : GPBMessage

/** 列表 */
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<ForwardEvaluate*> *listArray;
/** The number of items in @c listArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger listArray_Count;

@end

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
