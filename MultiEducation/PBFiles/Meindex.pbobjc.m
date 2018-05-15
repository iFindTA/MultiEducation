// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: MEIndex.proto

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

 #import "Meindex.pbobjc.h"
 #import "Meres.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - MeindexRoot

@implementation MeindexRoot

// No extensions in the file and none of the imports (direct or indirect)
// defined extensions, so no need to generate +extensionRegistry.

@end

#pragma mark - MeindexRoot_FileDescriptor

static GPBFileDescriptor *MeindexRoot_FileDescriptor(void) {
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

#pragma mark - MEPBIndexItem

@implementation MEPBIndexItem

@dynamic topListArray, topListArray_Count;
@dynamic resTypeListArray, resTypeListArray_Count;
@dynamic recommendTypeListArray, recommendTypeListArray_Count;
@dynamic title;
@dynamic code;
@dynamic tmpType;

typedef struct MEPBIndexItem__storage_ {
  uint32_t _has_storage_[1];
  NSMutableArray *topListArray;
  NSMutableArray *resTypeListArray;
  NSMutableArray *recommendTypeListArray;
  NSString *title;
  NSString *code;
  NSString *tmpType;
} MEPBIndexItem__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "topListArray",
        .dataTypeSpecific.className = GPBStringifySymbol(MEPBRes),
        .number = MEPBIndexItem_FieldNumber_TopListArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(MEPBIndexItem__storage_, topListArray),
        .flags = (GPBFieldFlags)(GPBFieldRepeated | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
      {
        .name = "resTypeListArray",
        .dataTypeSpecific.className = GPBStringifySymbol(MEPBResType),
        .number = MEPBIndexItem_FieldNumber_ResTypeListArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(MEPBIndexItem__storage_, resTypeListArray),
        .flags = (GPBFieldFlags)(GPBFieldRepeated | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
      {
        .name = "recommendTypeListArray",
        .dataTypeSpecific.className = GPBStringifySymbol(MEPBResType),
        .number = MEPBIndexItem_FieldNumber_RecommendTypeListArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(MEPBIndexItem__storage_, recommendTypeListArray),
        .flags = (GPBFieldFlags)(GPBFieldRepeated | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
      {
        .name = "title",
        .dataTypeSpecific.className = NULL,
        .number = MEPBIndexItem_FieldNumber_Title,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(MEPBIndexItem__storage_, title),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "code",
        .dataTypeSpecific.className = NULL,
        .number = MEPBIndexItem_FieldNumber_Code,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(MEPBIndexItem__storage_, code),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "tmpType",
        .dataTypeSpecific.className = NULL,
        .number = MEPBIndexItem_FieldNumber_TmpType,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(MEPBIndexItem__storage_, tmpType),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[MEPBIndexItem class]
                                     rootClass:[MeindexRoot class]
                                          file:MeindexRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(MEPBIndexItem__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\004\001\000topList\000\002\000resTypeList\000\003\000recommendType"
        "List\000\006\007\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - MEPBIndexClass

@implementation MEPBIndexClass

@dynamic catsArray, catsArray_Count;
@dynamic keyword;

typedef struct MEPBIndexClass__storage_ {
  uint32_t _has_storage_[1];
  NSMutableArray *catsArray;
  NSString *keyword;
} MEPBIndexClass__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "catsArray",
        .dataTypeSpecific.className = GPBStringifySymbol(MEPBIndexItem),
        .number = MEPBIndexClass_FieldNumber_CatsArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(MEPBIndexClass__storage_, catsArray),
        .flags = GPBFieldRepeated,
        .dataType = GPBDataTypeMessage,
      },
      {
        .name = "keyword",
        .dataTypeSpecific.className = NULL,
        .number = MEPBIndexClass_FieldNumber_Keyword,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(MEPBIndexClass__storage_, keyword),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[MEPBIndexClass class]
                                     rootClass:[MeindexRoot class]
                                          file:MeindexRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(MEPBIndexClass__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end


#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
