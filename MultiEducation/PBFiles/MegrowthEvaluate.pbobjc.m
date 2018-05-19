// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: MEGrowthEvaluate.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <Protobuf/GPBProtocolBuffers_RuntimeSupport.h>
#else
 #import "GPBProtocolBuffers_RuntimeSupport.h"
#endif

 #import "MegrowthEvaluate.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - MegrowthEvaluateRoot

@implementation MegrowthEvaluateRoot

// No extensions in the file and no imports, so no need to generate
// +extensionRegistry.

@end

#pragma mark - MegrowthEvaluateRoot_FileDescriptor

static GPBFileDescriptor *MegrowthEvaluateRoot_FileDescriptor(void) {
  // This is called by +initialize so there is no need to worry
  // about thread safety of the singleton.
  static GPBFileDescriptor *descriptor = NULL;
  if (!descriptor) {
    GPB_DEBUG_CHECK_RUNTIME_VERSIONS();
    descriptor = [[GPBFileDescriptor alloc] initWithPackage:@""
                                                     syntax:GPBFileSyntaxProto3];
  }
  return descriptor;
}

#pragma mark - EvaluateItem

@implementation EvaluateItem

@dynamic id_p;
@dynamic title;
@dynamic checked;

typedef struct EvaluateItem__storage_ {
  uint32_t _has_storage_[1];
  NSString *title;
  int64_t id_p;
} EvaluateItem__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "id_p",
        .dataTypeSpecific.className = NULL,
        .number = EvaluateItem_FieldNumber_Id_p,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(EvaluateItem__storage_, id_p),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "title",
        .dataTypeSpecific.className = NULL,
        .number = EvaluateItem_FieldNumber_Title,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(EvaluateItem__storage_, title),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "checked",
        .dataTypeSpecific.className = NULL,
        .number = EvaluateItem_FieldNumber_Checked,
        .hasIndex = 2,
        .offset = 3,  // Stored in _has_storage_ to save space.
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeBool,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[EvaluateItem class]
                                     rootClass:[MegrowthEvaluateRoot class]
                                          file:MegrowthEvaluateRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(EvaluateItem__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - EvaluateQuestion

@implementation EvaluateQuestion

@dynamic id_p;
@dynamic evaluateId;
@dynamic title;
@dynamic type;
@dynamic checkType;
@dynamic itemsArray, itemsArray_Count;
@dynamic placeholder;
@dynamic maxLength;

typedef struct EvaluateQuestion__storage_ {
  uint32_t _has_storage_[1];
  int32_t type;
  int32_t checkType;
  int32_t maxLength;
  NSString *title;
  NSMutableArray *itemsArray;
  NSString *placeholder;
  int64_t id_p;
  int64_t evaluateId;
} EvaluateQuestion__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "id_p",
        .dataTypeSpecific.className = NULL,
        .number = EvaluateQuestion_FieldNumber_Id_p,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(EvaluateQuestion__storage_, id_p),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "evaluateId",
        .dataTypeSpecific.className = NULL,
        .number = EvaluateQuestion_FieldNumber_EvaluateId,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(EvaluateQuestion__storage_, evaluateId),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "title",
        .dataTypeSpecific.className = NULL,
        .number = EvaluateQuestion_FieldNumber_Title,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(EvaluateQuestion__storage_, title),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "type",
        .dataTypeSpecific.className = NULL,
        .number = EvaluateQuestion_FieldNumber_Type,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(EvaluateQuestion__storage_, type),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "checkType",
        .dataTypeSpecific.className = NULL,
        .number = EvaluateQuestion_FieldNumber_CheckType,
        .hasIndex = 4,
        .offset = (uint32_t)offsetof(EvaluateQuestion__storage_, checkType),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "itemsArray",
        .dataTypeSpecific.className = GPBStringifySymbol(EvaluateItem),
        .number = EvaluateQuestion_FieldNumber_ItemsArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(EvaluateQuestion__storage_, itemsArray),
        .flags = GPBFieldRepeated,
        .dataType = GPBDataTypeMessage,
      },
      {
        .name = "placeholder",
        .dataTypeSpecific.className = NULL,
        .number = EvaluateQuestion_FieldNumber_Placeholder,
        .hasIndex = 5,
        .offset = (uint32_t)offsetof(EvaluateQuestion__storage_, placeholder),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "maxLength",
        .dataTypeSpecific.className = NULL,
        .number = EvaluateQuestion_FieldNumber_MaxLength,
        .hasIndex = 6,
        .offset = (uint32_t)offsetof(EvaluateQuestion__storage_, maxLength),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt32,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[EvaluateQuestion class]
                                     rootClass:[MegrowthEvaluateRoot class]
                                          file:MegrowthEvaluateRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(EvaluateQuestion__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\003\002\n\000\005\t\000\010\t\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - GrowthEvaluate

@implementation GrowthEvaluate

@dynamic id_p;
@dynamic gradeId;
@dynamic semester;
@dynamic studentId;
@dynamic month;
@dynamic title;
@dynamic status;
@dynamic schoolQuestionsArray, schoolQuestionsArray_Count;
@dynamic homeQuestionsArray, homeQuestionsArray_Count;

typedef struct GrowthEvaluate__storage_ {
  uint32_t _has_storage_[1];
  int32_t month;
  int32_t status;
  NSString *title;
  NSMutableArray *schoolQuestionsArray;
  NSMutableArray *homeQuestionsArray;
  int64_t id_p;
  int64_t gradeId;
  int64_t semester;
  int64_t studentId;
} GrowthEvaluate__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "id_p",
        .dataTypeSpecific.className = NULL,
        .number = GrowthEvaluate_FieldNumber_Id_p,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(GrowthEvaluate__storage_, id_p),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "gradeId",
        .dataTypeSpecific.className = NULL,
        .number = GrowthEvaluate_FieldNumber_GradeId,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(GrowthEvaluate__storage_, gradeId),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "semester",
        .dataTypeSpecific.className = NULL,
        .number = GrowthEvaluate_FieldNumber_Semester,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(GrowthEvaluate__storage_, semester),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "studentId",
        .dataTypeSpecific.className = NULL,
        .number = GrowthEvaluate_FieldNumber_StudentId,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(GrowthEvaluate__storage_, studentId),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "month",
        .dataTypeSpecific.className = NULL,
        .number = GrowthEvaluate_FieldNumber_Month,
        .hasIndex = 4,
        .offset = (uint32_t)offsetof(GrowthEvaluate__storage_, month),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "title",
        .dataTypeSpecific.className = NULL,
        .number = GrowthEvaluate_FieldNumber_Title,
        .hasIndex = 5,
        .offset = (uint32_t)offsetof(GrowthEvaluate__storage_, title),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "status",
        .dataTypeSpecific.className = NULL,
        .number = GrowthEvaluate_FieldNumber_Status,
        .hasIndex = 6,
        .offset = (uint32_t)offsetof(GrowthEvaluate__storage_, status),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "schoolQuestionsArray",
        .dataTypeSpecific.className = GPBStringifySymbol(EvaluateQuestion),
        .number = GrowthEvaluate_FieldNumber_SchoolQuestionsArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(GrowthEvaluate__storage_, schoolQuestionsArray),
        .flags = (GPBFieldFlags)(GPBFieldRepeated | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
      {
        .name = "homeQuestionsArray",
        .dataTypeSpecific.className = GPBStringifySymbol(EvaluateQuestion),
        .number = GrowthEvaluate_FieldNumber_HomeQuestionsArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(GrowthEvaluate__storage_, homeQuestionsArray),
        .flags = (GPBFieldFlags)(GPBFieldRepeated | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[GrowthEvaluate class]
                                     rootClass:[MegrowthEvaluateRoot class]
                                          file:MegrowthEvaluateRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(GrowthEvaluate__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\004\002\007\000\004\t\000\010\000schoolQuestions\000\t\000homeQuestions"
        "\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - GrowthEvaluateList

@implementation GrowthEvaluateList

@dynamic evaluatesArray, evaluatesArray_Count;

typedef struct GrowthEvaluateList__storage_ {
  uint32_t _has_storage_[1];
  NSMutableArray *evaluatesArray;
} GrowthEvaluateList__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "evaluatesArray",
        .dataTypeSpecific.className = GPBStringifySymbol(GrowthEvaluate),
        .number = GrowthEvaluateList_FieldNumber_EvaluatesArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(GrowthEvaluateList__storage_, evaluatesArray),
        .flags = GPBFieldRepeated,
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[GrowthEvaluateList class]
                                     rootClass:[MegrowthEvaluateRoot class]
                                          file:MegrowthEvaluateRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(GrowthEvaluateList__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end


#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
