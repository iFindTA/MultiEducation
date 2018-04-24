// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: MENewsInfo.proto

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

 #import "MenewsInfo.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - MenewsInfoRoot

@implementation MenewsInfoRoot

// No extensions in the file and no imports, so no need to generate
// +extensionRegistry.

@end

#pragma mark - MenewsInfoRoot_FileDescriptor

static GPBFileDescriptor *MenewsInfoRoot_FileDescriptor(void) {
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

#pragma mark - OsrInformationPbList

@implementation OsrInformationPbList

@dynamic osrInformationPbArray, osrInformationPbArray_Count;

typedef struct OsrInformationPbList__storage_ {
  uint32_t _has_storage_[1];
  NSMutableArray *osrInformationPbArray;
} OsrInformationPbList__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "osrInformationPbArray",
        .dataTypeSpecific.className = GPBStringifySymbol(OsrInformationPb),
        .number = OsrInformationPbList_FieldNumber_OsrInformationPbArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(OsrInformationPbList__storage_, osrInformationPbArray),
        .flags = (GPBFieldFlags)(GPBFieldRepeated | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[OsrInformationPbList class]
                                     rootClass:[MenewsInfoRoot class]
                                          file:MenewsInfoRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(OsrInformationPbList__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\001\001\000osrInformationPb\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - OsrInformationPb

@implementation OsrInformationPb

@dynamic id_p;
@dynamic title;
@dynamic content;
@dynamic intro;
@dynamic coverImg;

typedef struct OsrInformationPb__storage_ {
  uint32_t _has_storage_[1];
  NSString *title;
  NSString *content;
  NSString *intro;
  NSString *coverImg;
  int64_t id_p;
} OsrInformationPb__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "id_p",
        .dataTypeSpecific.className = NULL,
        .number = OsrInformationPb_FieldNumber_Id_p,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(OsrInformationPb__storage_, id_p),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "title",
        .dataTypeSpecific.className = NULL,
        .number = OsrInformationPb_FieldNumber_Title,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(OsrInformationPb__storage_, title),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "content",
        .dataTypeSpecific.className = NULL,
        .number = OsrInformationPb_FieldNumber_Content,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(OsrInformationPb__storage_, content),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "intro",
        .dataTypeSpecific.className = NULL,
        .number = OsrInformationPb_FieldNumber_Intro,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(OsrInformationPb__storage_, intro),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "coverImg",
        .dataTypeSpecific.className = NULL,
        .number = OsrInformationPb_FieldNumber_CoverImg,
        .hasIndex = 4,
        .offset = (uint32_t)offsetof(OsrInformationPb__storage_, coverImg),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[OsrInformationPb class]
                                     rootClass:[MenewsInfoRoot class]
                                          file:MenewsInfoRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(OsrInformationPb__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\001\005\010\000";
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
