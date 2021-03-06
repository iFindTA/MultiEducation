// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: MEClass.proto

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

 #import "Meclass.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - MeclassRoot

@implementation MeclassRoot

// No extensions in the file and no imports, so no need to generate
// +extensionRegistry.

@end

#pragma mark - MeclassRoot_FileDescriptor

static GPBFileDescriptor *MeclassRoot_FileDescriptor(void) {
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

#pragma mark - MEPBClassList

@implementation MEPBClassList

@dynamic classPbArray, classPbArray_Count;

typedef struct MEPBClassList__storage_ {
  uint32_t _has_storage_[1];
  NSMutableArray *classPbArray;
} MEPBClassList__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "classPbArray",
        .dataTypeSpecific.className = GPBStringifySymbol(MEPBClass),
        .number = MEPBClassList_FieldNumber_ClassPbArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(MEPBClassList__storage_, classPbArray),
        .flags = (GPBFieldFlags)(GPBFieldRepeated | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[MEPBClassList class]
                                     rootClass:[MeclassRoot class]
                                          file:MeclassRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(MEPBClassList__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\001\001\000ClassPB\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - MEPBClass

@implementation MEPBClass

@dynamic id_p;
@dynamic name;
@dynamic gradeId;
@dynamic gradeName;
@dynamic monitorURL;
@dynamic year;
@dynamic semester;
@dynamic schoolId;

typedef struct MEPBClass__storage_ {
  uint32_t _has_storage_[1];
  int32_t semester;
  NSString *name;
  NSString *gradeName;
  NSString *monitorURL;
  int64_t id_p;
  int64_t gradeId;
  int64_t year;
  int64_t schoolId;
} MEPBClass__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "id_p",
        .dataTypeSpecific.className = NULL,
        .number = MEPBClass_FieldNumber_Id_p,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(MEPBClass__storage_, id_p),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "name",
        .dataTypeSpecific.className = NULL,
        .number = MEPBClass_FieldNumber_Name,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(MEPBClass__storage_, name),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "gradeId",
        .dataTypeSpecific.className = NULL,
        .number = MEPBClass_FieldNumber_GradeId,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(MEPBClass__storage_, gradeId),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "gradeName",
        .dataTypeSpecific.className = NULL,
        .number = MEPBClass_FieldNumber_GradeName,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(MEPBClass__storage_, gradeName),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "monitorURL",
        .dataTypeSpecific.className = NULL,
        .number = MEPBClass_FieldNumber_MonitorURL,
        .hasIndex = 4,
        .offset = (uint32_t)offsetof(MEPBClass__storage_, monitorURL),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "year",
        .dataTypeSpecific.className = NULL,
        .number = MEPBClass_FieldNumber_Year,
        .hasIndex = 5,
        .offset = (uint32_t)offsetof(MEPBClass__storage_, year),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "semester",
        .dataTypeSpecific.className = NULL,
        .number = MEPBClass_FieldNumber_Semester,
        .hasIndex = 6,
        .offset = (uint32_t)offsetof(MEPBClass__storage_, semester),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "schoolId",
        .dataTypeSpecific.className = NULL,
        .number = MEPBClass_FieldNumber_SchoolId,
        .hasIndex = 7,
        .offset = (uint32_t)offsetof(MEPBClass__storage_, schoolId),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt64,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[MEPBClass class]
                                     rootClass:[MeclassRoot class]
                                          file:MeclassRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(MEPBClass__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\004\003\007\000\004\t\000\005\010!!\000\010\010\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end


#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
