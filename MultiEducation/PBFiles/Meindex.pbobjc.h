// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: MEIndex.proto

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

@class MEPBCourseVideo;
@class MEPBCourseVideoClass;
@class MEPBIndexItem;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - MeindexRoot

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
@interface MeindexRoot : GPBRootObject
@end

#pragma mark - MEPBIndexItem

typedef GPB_ENUM(MEPBIndexItem_FieldNumber) {
  MEPBIndexItem_FieldNumber_TopListArray = 1,
  MEPBIndexItem_FieldNumber_CourseVideoCatPbArray = 2,
  MEPBIndexItem_FieldNumber_RecommendCatArray = 3,
};

@interface MEPBIndexItem : GPBMessage

/** 首页轮播视频 */
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<MEPBCourseVideo*> *topListArray;
/** The number of items in @c topListArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger topListArray_Count;

/** 子分类 */
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<MEPBCourseVideoClass*> *courseVideoCatPbArray;
/** The number of items in @c courseVideoCatPbArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger courseVideoCatPbArray_Count;

/** 推荐列表 */
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<MEPBCourseVideoClass*> *recommendCatArray;
/** The number of items in @c recommendCatArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger recommendCatArray_Count;

@end

#pragma mark - MEPBIndexClass

typedef GPB_ENUM(MEPBIndexClass_FieldNumber) {
  MEPBIndexClass_FieldNumber_CatsArray = 1,
};

@interface MEPBIndexClass : GPBMessage

/** 类别 */
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<MEPBIndexItem*> *catsArray;
/** The number of items in @c catsArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger catsArray_Count;

@end

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
