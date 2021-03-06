// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: MEClassLive.proto

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

 #import "MeclassLive.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - MeclassLiveRoot

@implementation MeclassLiveRoot

// No extensions in the file and no imports, so no need to generate
// +extensionRegistry.

@end

#pragma mark - MeclassLiveRoot_FileDescriptor

static GPBFileDescriptor *MeclassLiveRoot_FileDescriptor(void) {
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

#pragma mark - MEPBClassLive

@implementation MEPBClassLive

@dynamic id_p;
@dynamic teacherId;
@dynamic classId;
@dynamic streamURL;
@dynamic status;
@dynamic videoURL;
@dynamic recorderListArray, recorderListArray_Count;
@dynamic title;
@dynamic coverImg;

typedef struct MEPBClassLive__storage_ {
  uint32_t _has_storage_[1];
  int32_t status;
  NSString *streamURL;
  NSString *videoURL;
  NSMutableArray *recorderListArray;
  NSString *title;
  NSString *coverImg;
  int64_t id_p;
  int64_t teacherId;
  int64_t classId;
} MEPBClassLive__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "id_p",
        .dataTypeSpecific.className = NULL,
        .number = MEPBClassLive_FieldNumber_Id_p,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(MEPBClassLive__storage_, id_p),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "teacherId",
        .dataTypeSpecific.className = NULL,
        .number = MEPBClassLive_FieldNumber_TeacherId,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(MEPBClassLive__storage_, teacherId),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "classId",
        .dataTypeSpecific.className = NULL,
        .number = MEPBClassLive_FieldNumber_ClassId,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(MEPBClassLive__storage_, classId),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "streamURL",
        .dataTypeSpecific.className = NULL,
        .number = MEPBClassLive_FieldNumber_StreamURL,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(MEPBClassLive__storage_, streamURL),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "status",
        .dataTypeSpecific.className = NULL,
        .number = MEPBClassLive_FieldNumber_Status,
        .hasIndex = 4,
        .offset = (uint32_t)offsetof(MEPBClassLive__storage_, status),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "videoURL",
        .dataTypeSpecific.className = NULL,
        .number = MEPBClassLive_FieldNumber_VideoURL,
        .hasIndex = 5,
        .offset = (uint32_t)offsetof(MEPBClassLive__storage_, videoURL),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "recorderListArray",
        .dataTypeSpecific.className = GPBStringifySymbol(MEPBClassLive),
        .number = MEPBClassLive_FieldNumber_RecorderListArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(MEPBClassLive__storage_, recorderListArray),
        .flags = (GPBFieldFlags)(GPBFieldRepeated | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
      {
        .name = "title",
        .dataTypeSpecific.className = NULL,
        .number = MEPBClassLive_FieldNumber_Title,
        .hasIndex = 6,
        .offset = (uint32_t)offsetof(MEPBClassLive__storage_, title),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "coverImg",
        .dataTypeSpecific.className = NULL,
        .number = MEPBClassLive_FieldNumber_CoverImg,
        .hasIndex = 7,
        .offset = (uint32_t)offsetof(MEPBClassLive__storage_, coverImg),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[MEPBClassLive class]
                                     rootClass:[MeclassLiveRoot class]
                                          file:MeclassLiveRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(MEPBClassLive__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\006\002\t\000\003\007\000\004\007!!\000\006\006!!\000\007\000recorderList\000\t\010\000";
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
