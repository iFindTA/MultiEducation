// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: MERes.proto

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

 #import "Meres.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - MeresRoot

@implementation MeresRoot

// No extensions in the file and no imports, so no need to generate
// +extensionRegistry.

@end

#pragma mark - MeresRoot_FileDescriptor

static GPBFileDescriptor *MeresRoot_FileDescriptor(void) {
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

#pragma mark - MEPBRes

@implementation MEPBRes

@dynamic resId;
@dynamic title;
@dynamic coverImg;
@dynamic type;
@dynamic intro;
@dynamic desc;
@dynamic filePath;
@dynamic resLabelPbArray, resLabelPbArray_Count;
@dynamic relevantListArray, relevantListArray_Count;
@dynamic resTypeId;

typedef struct MEPBRes__storage_ {
  uint32_t _has_storage_[1];
  int32_t type;
  NSString *title;
  NSString *coverImg;
  NSString *intro;
  NSString *desc;
  NSString *filePath;
  NSMutableArray *resLabelPbArray;
  NSMutableArray *relevantListArray;
  int64_t resId;
  int64_t resTypeId;
} MEPBRes__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "resId",
        .dataTypeSpecific.className = NULL,
        .number = MEPBRes_FieldNumber_ResId,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(MEPBRes__storage_, resId),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "title",
        .dataTypeSpecific.className = NULL,
        .number = MEPBRes_FieldNumber_Title,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(MEPBRes__storage_, title),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "coverImg",
        .dataTypeSpecific.className = NULL,
        .number = MEPBRes_FieldNumber_CoverImg,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(MEPBRes__storage_, coverImg),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "type",
        .dataTypeSpecific.className = NULL,
        .number = MEPBRes_FieldNumber_Type,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(MEPBRes__storage_, type),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "intro",
        .dataTypeSpecific.className = NULL,
        .number = MEPBRes_FieldNumber_Intro,
        .hasIndex = 4,
        .offset = (uint32_t)offsetof(MEPBRes__storage_, intro),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "desc",
        .dataTypeSpecific.className = NULL,
        .number = MEPBRes_FieldNumber_Desc,
        .hasIndex = 5,
        .offset = (uint32_t)offsetof(MEPBRes__storage_, desc),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "filePath",
        .dataTypeSpecific.className = NULL,
        .number = MEPBRes_FieldNumber_FilePath,
        .hasIndex = 6,
        .offset = (uint32_t)offsetof(MEPBRes__storage_, filePath),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "resLabelPbArray",
        .dataTypeSpecific.className = GPBStringifySymbol(MEPBResLabel),
        .number = MEPBRes_FieldNumber_ResLabelPbArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(MEPBRes__storage_, resLabelPbArray),
        .flags = (GPBFieldFlags)(GPBFieldRepeated | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
      {
        .name = "relevantListArray",
        .dataTypeSpecific.className = GPBStringifySymbol(MEPBRes),
        .number = MEPBRes_FieldNumber_RelevantListArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(MEPBRes__storage_, relevantListArray),
        .flags = (GPBFieldFlags)(GPBFieldRepeated | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
      {
        .name = "resTypeId",
        .dataTypeSpecific.className = NULL,
        .number = MEPBRes_FieldNumber_ResTypeId,
        .hasIndex = 7,
        .offset = (uint32_t)offsetof(MEPBRes__storage_, resTypeId),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt64,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[MEPBRes class]
                                     rootClass:[MeresRoot class]
                                          file:MeresRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(MEPBRes__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\006\001\005\000\003\010\000\007\010\000\010\000resLabelPb\000\t\000relevantList\000\n\t"
        "\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - MEPBResType

@implementation MEPBResType

@dynamic id_p;
@dynamic title;
@dynamic iconPath;
@dynamic resPbArray, resPbArray_Count;

typedef struct MEPBResType__storage_ {
  uint32_t _has_storage_[1];
  NSString *title;
  NSString *iconPath;
  NSMutableArray *resPbArray;
  int64_t id_p;
} MEPBResType__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "id_p",
        .dataTypeSpecific.className = NULL,
        .number = MEPBResType_FieldNumber_Id_p,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(MEPBResType__storage_, id_p),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "title",
        .dataTypeSpecific.className = NULL,
        .number = MEPBResType_FieldNumber_Title,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(MEPBResType__storage_, title),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "iconPath",
        .dataTypeSpecific.className = NULL,
        .number = MEPBResType_FieldNumber_IconPath,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(MEPBResType__storage_, iconPath),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "resPbArray",
        .dataTypeSpecific.className = GPBStringifySymbol(MEPBRes),
        .number = MEPBResType_FieldNumber_ResPbArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(MEPBResType__storage_, resPbArray),
        .flags = (GPBFieldFlags)(GPBFieldRepeated | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[MEPBResType class]
                                     rootClass:[MeresRoot class]
                                          file:MeresRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(MEPBResType__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\002\003\010\000\004\000resPb\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - MEPBResList

@implementation MEPBResList

@dynamic resPbArray, resPbArray_Count;

typedef struct MEPBResList__storage_ {
  uint32_t _has_storage_[1];
  NSMutableArray *resPbArray;
} MEPBResList__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "resPbArray",
        .dataTypeSpecific.className = GPBStringifySymbol(MEPBRes),
        .number = MEPBResList_FieldNumber_ResPbArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(MEPBResList__storage_, resPbArray),
        .flags = (GPBFieldFlags)(GPBFieldRepeated | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[MEPBResList class]
                                     rootClass:[MeresRoot class]
                                          file:MeresRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(MEPBResList__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\001\001\000resPb\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - MEPBResLabel

@implementation MEPBResLabel

@dynamic id_p;
@dynamic labelName;

typedef struct MEPBResLabel__storage_ {
  uint32_t _has_storage_[1];
  NSString *labelName;
  int64_t id_p;
} MEPBResLabel__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "id_p",
        .dataTypeSpecific.className = NULL,
        .number = MEPBResLabel_FieldNumber_Id_p,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(MEPBResLabel__storage_, id_p),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "labelName",
        .dataTypeSpecific.className = NULL,
        .number = MEPBResLabel_FieldNumber_LabelName,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(MEPBResLabel__storage_, labelName),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[MEPBResLabel class]
                                     rootClass:[MeresRoot class]
                                          file:MeresRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(MEPBResLabel__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\001\002\t\000";
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
