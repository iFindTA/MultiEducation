// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: MENewsInfo.proto

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

@class OsrInformationPb;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - MenewsInfoRoot

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
@interface MenewsInfoRoot : GPBRootObject
@end

#pragma mark - OsrInformationPbList

typedef GPB_ENUM(OsrInformationPbList_FieldNumber) {
  OsrInformationPbList_FieldNumber_OsrInformationPbArray = 1,
};

@interface OsrInformationPbList : GPBMessage

@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<OsrInformationPb*> *osrInformationPbArray;
/** The number of items in @c osrInformationPbArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger osrInformationPbArray_Count;

@end

#pragma mark - OsrInformationPb

typedef GPB_ENUM(OsrInformationPb_FieldNumber) {
  OsrInformationPb_FieldNumber_Id_p = 1,
  OsrInformationPb_FieldNumber_Title = 2,
  OsrInformationPb_FieldNumber_Content = 3,
  OsrInformationPb_FieldNumber_Intro = 4,
  OsrInformationPb_FieldNumber_CoverImg = 5,
};

@interface OsrInformationPb : GPBMessage

@property(nonatomic, readwrite) int64_t id_p;

@property(nonatomic, readwrite, copy, null_resettable) NSString *title;

@property(nonatomic, readwrite, copy, null_resettable) NSString *content;

@property(nonatomic, readwrite, copy, null_resettable) NSString *intro;

@property(nonatomic, readwrite, copy, null_resettable) NSString *coverImg;

@end

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
