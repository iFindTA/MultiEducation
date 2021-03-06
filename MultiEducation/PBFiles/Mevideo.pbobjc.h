// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: MEVideo.proto

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
@class MEPBCourseVideoLabel;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - MevideoRoot

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
@interface MevideoRoot : GPBRootObject
@end

#pragma mark - MEPBCourseVideoListPb

typedef GPB_ENUM(MEPBCourseVideoListPb_FieldNumber) {
  MEPBCourseVideoListPb_FieldNumber_CourseVideoPbArray = 1,
};

@interface MEPBCourseVideoListPb : GPBMessage

@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<MEPBCourseVideo*> *courseVideoPbArray;
/** The number of items in @c courseVideoPbArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger courseVideoPbArray_Count;

@end

#pragma mark - MEPBCourseVideo

typedef GPB_ENUM(MEPBCourseVideo_FieldNumber) {
  MEPBCourseVideo_FieldNumber_Id_p = 1,
  MEPBCourseVideo_FieldNumber_GradeId = 2,
  MEPBCourseVideo_FieldNumber_Semester = 3,
  MEPBCourseVideo_FieldNumber_TopicId = 4,
  MEPBCourseVideo_FieldNumber_TypeId = 5,
  MEPBCourseVideo_FieldNumber_Title = 6,
  MEPBCourseVideo_FieldNumber_CoverImg = 7,
  MEPBCourseVideo_FieldNumber_VideoPath = 8,
  MEPBCourseVideo_FieldNumber_Desc = 9,
  MEPBCourseVideo_FieldNumber_CourseVideoLabelPbArray = 11,
};

@interface MEPBCourseVideo : GPBMessage

/** 视频ID */
@property(nonatomic, readwrite) int64_t id_p;

/** 年级 */
@property(nonatomic, readwrite) int64_t gradeId;

/** 学期 */
@property(nonatomic, readwrite) int32_t semester;

/** 主题ID */
@property(nonatomic, readwrite) int64_t topicId;

/** 类型ID */
@property(nonatomic, readwrite) int64_t typeId;

/** 标题 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *title;

/** 封面图片 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *coverImg;

/** 视频地址 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *videoPath;

/** 视频描述 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *desc;

/** 视频标签 */
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<MEPBCourseVideoLabel*> *courseVideoLabelPbArray;
/** The number of items in @c courseVideoLabelPbArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger courseVideoLabelPbArray_Count;

@end

#pragma mark - MEPBCourseVideoClass

typedef GPB_ENUM(MEPBCourseVideoClass_FieldNumber) {
  MEPBCourseVideoClass_FieldNumber_Id_p = 1,
  MEPBCourseVideoClass_FieldNumber_CatName = 2,
  MEPBCourseVideoClass_FieldNumber_IconPath = 3,
  MEPBCourseVideoClass_FieldNumber_CourseVideoPbArray = 4,
};

@interface MEPBCourseVideoClass : GPBMessage

/** 类型ID */
@property(nonatomic, readwrite) int64_t id_p;

/** 类别名称 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *catName;

/** 类别icon */
@property(nonatomic, readwrite, copy, null_resettable) NSString *iconPath;

/** 类别视频列表 nullable */
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<MEPBCourseVideo*> *courseVideoPbArray;
/** The number of items in @c courseVideoPbArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger courseVideoPbArray_Count;

@end

#pragma mark - MEPBCourseVideoLabel

typedef GPB_ENUM(MEPBCourseVideoLabel_FieldNumber) {
  MEPBCourseVideoLabel_FieldNumber_Id_p = 1,
  MEPBCourseVideoLabel_FieldNumber_Title = 2,
};

@interface MEPBCourseVideoLabel : GPBMessage

/** 标签ID */
@property(nonatomic, readwrite) int64_t id_p;

/** 标签名称 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *title;

@end

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
