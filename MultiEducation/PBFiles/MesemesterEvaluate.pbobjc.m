// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: MESemesterEvaluate.proto

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

 #import "MesemesterEvaluate.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - MesemesterEvaluateRoot

@implementation MesemesterEvaluateRoot

// No extensions in the file and no imports, so no need to generate
// +extensionRegistry.

@end

#pragma mark - MesemesterEvaluateRoot_FileDescriptor

static GPBFileDescriptor *MesemesterEvaluateRoot_FileDescriptor(void) {
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

#pragma mark - SEEvaluateItem

@implementation SEEvaluateItem

@dynamic id_p;
@dynamic title;
@dynamic answer;

typedef struct SEEvaluateItem__storage_ {
  uint32_t _has_storage_[1];
  int32_t answer;
  NSString *title;
  int64_t id_p;
} SEEvaluateItem__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "id_p",
        .dataTypeSpecific.className = NULL,
        .number = SEEvaluateItem_FieldNumber_Id_p,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(SEEvaluateItem__storage_, id_p),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "title",
        .dataTypeSpecific.className = NULL,
        .number = SEEvaluateItem_FieldNumber_Title,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(SEEvaluateItem__storage_, title),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "answer",
        .dataTypeSpecific.className = NULL,
        .number = SEEvaluateItem_FieldNumber_Answer,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(SEEvaluateItem__storage_, answer),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt32,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[SEEvaluateItem class]
                                     rootClass:[MesemesterEvaluateRoot class]
                                          file:MesemesterEvaluateRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(SEEvaluateItem__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - SEEvaluateSubType

@implementation SEEvaluateSubType

@dynamic id_p;
@dynamic title;
@dynamic itemsArray, itemsArray_Count;

typedef struct SEEvaluateSubType__storage_ {
  uint32_t _has_storage_[1];
  NSString *title;
  NSMutableArray *itemsArray;
  int64_t id_p;
} SEEvaluateSubType__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "id_p",
        .dataTypeSpecific.className = NULL,
        .number = SEEvaluateSubType_FieldNumber_Id_p,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(SEEvaluateSubType__storage_, id_p),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "title",
        .dataTypeSpecific.className = NULL,
        .number = SEEvaluateSubType_FieldNumber_Title,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(SEEvaluateSubType__storage_, title),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "itemsArray",
        .dataTypeSpecific.className = GPBStringifySymbol(SEEvaluateItem),
        .number = SEEvaluateSubType_FieldNumber_ItemsArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(SEEvaluateSubType__storage_, itemsArray),
        .flags = GPBFieldRepeated,
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[SEEvaluateSubType class]
                                     rootClass:[MesemesterEvaluateRoot class]
                                          file:MesemesterEvaluateRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(SEEvaluateSubType__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - SEEvaluateType

@implementation SEEvaluateType

@dynamic id_p;
@dynamic title;
@dynamic subTypesArray, subTypesArray_Count;

typedef struct SEEvaluateType__storage_ {
  uint32_t _has_storage_[1];
  NSString *title;
  NSMutableArray *subTypesArray;
  int64_t id_p;
} SEEvaluateType__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "id_p",
        .dataTypeSpecific.className = NULL,
        .number = SEEvaluateType_FieldNumber_Id_p,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(SEEvaluateType__storage_, id_p),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "title",
        .dataTypeSpecific.className = NULL,
        .number = SEEvaluateType_FieldNumber_Title,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(SEEvaluateType__storage_, title),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "subTypesArray",
        .dataTypeSpecific.className = GPBStringifySymbol(SEEvaluateSubType),
        .number = SEEvaluateType_FieldNumber_SubTypesArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(SEEvaluateType__storage_, subTypesArray),
        .flags = (GPBFieldFlags)(GPBFieldRepeated | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[SEEvaluateType class]
                                     rootClass:[MesemesterEvaluateRoot class]
                                          file:MesemesterEvaluateRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(SEEvaluateType__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\001\003\000subTypes\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - SemesterEvaluate

@implementation SemesterEvaluate

@dynamic id_p;
@dynamic gradeId;
@dynamic semester;
@dynamic studentId;
@dynamic title;
@dynamic status;
@dynamic typesArray, typesArray_Count;
@dynamic quesItemsArray, quesItemsArray_Count;

typedef struct SemesterEvaluate__storage_ {
  uint32_t _has_storage_[1];
  int32_t status;
  NSString *title;
  NSMutableArray *typesArray;
  NSMutableArray *quesItemsArray;
  int64_t id_p;
  int64_t gradeId;
  int64_t semester;
  int64_t studentId;
} SemesterEvaluate__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "id_p",
        .dataTypeSpecific.className = NULL,
        .number = SemesterEvaluate_FieldNumber_Id_p,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(SemesterEvaluate__storage_, id_p),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "gradeId",
        .dataTypeSpecific.className = NULL,
        .number = SemesterEvaluate_FieldNumber_GradeId,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(SemesterEvaluate__storage_, gradeId),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "semester",
        .dataTypeSpecific.className = NULL,
        .number = SemesterEvaluate_FieldNumber_Semester,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(SemesterEvaluate__storage_, semester),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "studentId",
        .dataTypeSpecific.className = NULL,
        .number = SemesterEvaluate_FieldNumber_StudentId,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(SemesterEvaluate__storage_, studentId),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "title",
        .dataTypeSpecific.className = NULL,
        .number = SemesterEvaluate_FieldNumber_Title,
        .hasIndex = 4,
        .offset = (uint32_t)offsetof(SemesterEvaluate__storage_, title),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "status",
        .dataTypeSpecific.className = NULL,
        .number = SemesterEvaluate_FieldNumber_Status,
        .hasIndex = 5,
        .offset = (uint32_t)offsetof(SemesterEvaluate__storage_, status),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "typesArray",
        .dataTypeSpecific.className = GPBStringifySymbol(SEEvaluateType),
        .number = SemesterEvaluate_FieldNumber_TypesArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(SemesterEvaluate__storage_, typesArray),
        .flags = GPBFieldRepeated,
        .dataType = GPBDataTypeMessage,
      },
      {
        .name = "quesItemsArray",
        .dataTypeSpecific.className = GPBStringifySymbol(SEEvaluateItem),
        .number = SemesterEvaluate_FieldNumber_QuesItemsArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(SemesterEvaluate__storage_, quesItemsArray),
        .flags = (GPBFieldFlags)(GPBFieldRepeated | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[SemesterEvaluate class]
                                     rootClass:[MesemesterEvaluateRoot class]
                                          file:MesemesterEvaluateRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(SemesterEvaluate__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\003\002\007\000\004\t\000\010\000quesItems\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - SemesterEvaluateList

@implementation SemesterEvaluateList

@dynamic evaluatesArray, evaluatesArray_Count;

typedef struct SemesterEvaluateList__storage_ {
  uint32_t _has_storage_[1];
  NSMutableArray *evaluatesArray;
} SemesterEvaluateList__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "evaluatesArray",
        .dataTypeSpecific.className = GPBStringifySymbol(SemesterEvaluate),
        .number = SemesterEvaluateList_FieldNumber_EvaluatesArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(SemesterEvaluateList__storage_, evaluatesArray),
        .flags = GPBFieldRepeated,
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[SemesterEvaluateList class]
                                     rootClass:[MesemesterEvaluateRoot class]
                                          file:MesemesterEvaluateRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(SemesterEvaluateList__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end


#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
