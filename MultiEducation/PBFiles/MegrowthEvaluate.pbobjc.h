// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: MEGrowthEvaluate.proto

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

@class EvaluateItem;
@class EvaluateQuestion;
@class GrowthEvaluate;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - MegrowthEvaluateRoot

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
@interface MegrowthEvaluateRoot : GPBRootObject
@end

#pragma mark - EvaluateItem

typedef GPB_ENUM(EvaluateItem_FieldNumber) {
  EvaluateItem_FieldNumber_Id_p = 1,
  EvaluateItem_FieldNumber_Title = 2,
  EvaluateItem_FieldNumber_Checked = 3,
};

@interface EvaluateItem : GPBMessage

/** item id */
@property(nonatomic, readwrite) int64_t id_p;

/** item title */
@property(nonatomic, readwrite, copy, null_resettable) NSString *title;

/** 是否选中 */
@property(nonatomic, readwrite) BOOL checked;

@end

#pragma mark - EvaluateQuestion

typedef GPB_ENUM(EvaluateQuestion_FieldNumber) {
  EvaluateQuestion_FieldNumber_Id_p = 1,
  EvaluateQuestion_FieldNumber_EvaluateId = 2,
  EvaluateQuestion_FieldNumber_Title = 3,
  EvaluateQuestion_FieldNumber_Type = 4,
  EvaluateQuestion_FieldNumber_CheckType = 5,
  EvaluateQuestion_FieldNumber_ItemsArray = 6,
  EvaluateQuestion_FieldNumber_Answer = 7,
  EvaluateQuestion_FieldNumber_Placeholder = 8,
  EvaluateQuestion_FieldNumber_MaxLength = 9,
};

@interface EvaluateQuestion : GPBMessage

/** question id */
@property(nonatomic, readwrite) int64_t id_p;

/** ? */
@property(nonatomic, readwrite) int64_t evaluateId;

/** 问题标题 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *title;

/** 类型（1:在幼儿园 2:在家里） */
@property(nonatomic, readwrite) int32_t type;

/** 1:单选题 2:多选题 3:填空题 */
@property(nonatomic, readwrite) int32_t checkType;

/** 题目选项 */
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<EvaluateItem*> *itemsArray;
/** The number of items in @c itemsArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger itemsArray_Count;

/** 填空题时的 文字答案 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *answer;

/** 填空题的占位文字描述 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *placeholder;

/** 用户最多输入长度 */
@property(nonatomic, readwrite) int32_t maxLength;

@end

#pragma mark - GrowthEvaluate

typedef GPB_ENUM(GrowthEvaluate_FieldNumber) {
  GrowthEvaluate_FieldNumber_Id_p = 1,
  GrowthEvaluate_FieldNumber_GradeId = 2,
  GrowthEvaluate_FieldNumber_Semester = 3,
  GrowthEvaluate_FieldNumber_StudentId = 4,
  GrowthEvaluate_FieldNumber_Month = 5,
  GrowthEvaluate_FieldNumber_Title = 6,
  GrowthEvaluate_FieldNumber_Status = 7,
  GrowthEvaluate_FieldNumber_SchoolQuestionsArray = 8,
  GrowthEvaluate_FieldNumber_HomeQuestionsArray = 9,
};

@interface GrowthEvaluate : GPBMessage

/** ? */
@property(nonatomic, readwrite) int64_t id_p;

/** 年级 */
@property(nonatomic, readwrite) int64_t gradeId;

/** 学期 */
@property(nonatomic, readwrite) int64_t semester;

/** 学生ID */
@property(nonatomic, readwrite) int64_t studentId;

/** 月份 */
@property(nonatomic, readwrite) int32_t month;

/** 标题 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *title;

/** 状态 1已完成 0未填写 2已暂存 */
@property(nonatomic, readwrite) int32_t status;

/** 在学校题目 */
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<EvaluateQuestion*> *schoolQuestionsArray;
/** The number of items in @c schoolQuestionsArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger schoolQuestionsArray_Count;

/** 在家里题目 */
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<EvaluateQuestion*> *homeQuestionsArray;
/** The number of items in @c homeQuestionsArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger homeQuestionsArray_Count;

@end

#pragma mark - GrowthEvaluateList

typedef GPB_ENUM(GrowthEvaluateList_FieldNumber) {
  GrowthEvaluateList_FieldNumber_EvaluatesArray = 1,
};

@interface GrowthEvaluateList : GPBMessage

/** 列表 */
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<GrowthEvaluate*> *evaluatesArray;
/** The number of items in @c evaluatesArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger evaluatesArray_Count;

@end

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
