// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: MEVideo.proto

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

 #import "Mevideo.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - MevideoRoot

@implementation MevideoRoot

// No extensions in the file and no imports, so no need to generate
// +extensionRegistry.

@end

#pragma mark - MevideoRoot_FileDescriptor

static GPBFileDescriptor *MevideoRoot_FileDescriptor(void) {
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

#pragma mark - MEPBCourseVideoListPb

@implementation MEPBCourseVideoListPb

@dynamic courseVideoPbArray, courseVideoPbArray_Count;

typedef struct MEPBCourseVideoListPb__storage_ {
  uint32_t _has_storage_[1];
  NSMutableArray *courseVideoPbArray;
} MEPBCourseVideoListPb__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "courseVideoPbArray",
        .dataTypeSpecific.className = GPBStringifySymbol(MEPBCourseVideo),
        .number = MEPBCourseVideoListPb_FieldNumber_CourseVideoPbArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(MEPBCourseVideoListPb__storage_, courseVideoPbArray),
        .flags = (GPBFieldFlags)(GPBFieldRepeated | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[MEPBCourseVideoListPb class]
                                     rootClass:[MevideoRoot class]
                                          file:MevideoRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(MEPBCourseVideoListPb__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\001\001\000courseVideoPb\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - MEPBCourseVideo

@implementation MEPBCourseVideo

@dynamic id_p;
@dynamic gradeId;
@dynamic semester;
@dynamic topicId;
@dynamic typeId;
@dynamic title;
@dynamic coverImg;
@dynamic videoPath;
@dynamic desc;
@dynamic courseVideoLabelPbArray, courseVideoLabelPbArray_Count;

typedef struct MEPBCourseVideo__storage_ {
  uint32_t _has_storage_[1];
  int32_t semester;
  NSString *title;
  NSString *coverImg;
  NSString *videoPath;
  NSString *desc;
  NSMutableArray *courseVideoLabelPbArray;
  int64_t id_p;
  int64_t gradeId;
  int64_t topicId;
  int64_t typeId;
} MEPBCourseVideo__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "id_p",
        .dataTypeSpecific.className = NULL,
        .number = MEPBCourseVideo_FieldNumber_Id_p,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(MEPBCourseVideo__storage_, id_p),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "gradeId",
        .dataTypeSpecific.className = NULL,
        .number = MEPBCourseVideo_FieldNumber_GradeId,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(MEPBCourseVideo__storage_, gradeId),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "semester",
        .dataTypeSpecific.className = NULL,
        .number = MEPBCourseVideo_FieldNumber_Semester,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(MEPBCourseVideo__storage_, semester),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "topicId",
        .dataTypeSpecific.className = NULL,
        .number = MEPBCourseVideo_FieldNumber_TopicId,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(MEPBCourseVideo__storage_, topicId),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "typeId",
        .dataTypeSpecific.className = NULL,
        .number = MEPBCourseVideo_FieldNumber_TypeId,
        .hasIndex = 4,
        .offset = (uint32_t)offsetof(MEPBCourseVideo__storage_, typeId),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "title",
        .dataTypeSpecific.className = NULL,
        .number = MEPBCourseVideo_FieldNumber_Title,
        .hasIndex = 5,
        .offset = (uint32_t)offsetof(MEPBCourseVideo__storage_, title),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "coverImg",
        .dataTypeSpecific.className = NULL,
        .number = MEPBCourseVideo_FieldNumber_CoverImg,
        .hasIndex = 6,
        .offset = (uint32_t)offsetof(MEPBCourseVideo__storage_, coverImg),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "videoPath",
        .dataTypeSpecific.className = NULL,
        .number = MEPBCourseVideo_FieldNumber_VideoPath,
        .hasIndex = 7,
        .offset = (uint32_t)offsetof(MEPBCourseVideo__storage_, videoPath),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "desc",
        .dataTypeSpecific.className = NULL,
        .number = MEPBCourseVideo_FieldNumber_Desc,
        .hasIndex = 8,
        .offset = (uint32_t)offsetof(MEPBCourseVideo__storage_, desc),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "courseVideoLabelPbArray",
        .dataTypeSpecific.className = GPBStringifySymbol(MEPBCourseVideoLabel),
        .number = MEPBCourseVideo_FieldNumber_CourseVideoLabelPbArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(MEPBCourseVideo__storage_, courseVideoLabelPbArray),
        .flags = (GPBFieldFlags)(GPBFieldRepeated | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[MEPBCourseVideo class]
                                     rootClass:[MevideoRoot class]
                                          file:MevideoRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(MEPBCourseVideo__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\006\002\007\000\004\007\000\005\006\000\007\010\000\010\t\000\013\000courseVideoLabelPb\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - MEPBCourseVideoClass

@implementation MEPBCourseVideoClass

@dynamic id_p;
@dynamic catName;
@dynamic iconPath;
@dynamic courseVideoPbArray, courseVideoPbArray_Count;

typedef struct MEPBCourseVideoClass__storage_ {
  uint32_t _has_storage_[1];
  NSString *catName;
  NSString *iconPath;
  NSMutableArray *courseVideoPbArray;
  int64_t id_p;
} MEPBCourseVideoClass__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "id_p",
        .dataTypeSpecific.className = NULL,
        .number = MEPBCourseVideoClass_FieldNumber_Id_p,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(MEPBCourseVideoClass__storage_, id_p),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "catName",
        .dataTypeSpecific.className = NULL,
        .number = MEPBCourseVideoClass_FieldNumber_CatName,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(MEPBCourseVideoClass__storage_, catName),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "iconPath",
        .dataTypeSpecific.className = NULL,
        .number = MEPBCourseVideoClass_FieldNumber_IconPath,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(MEPBCourseVideoClass__storage_, iconPath),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "courseVideoPbArray",
        .dataTypeSpecific.className = GPBStringifySymbol(MEPBCourseVideo),
        .number = MEPBCourseVideoClass_FieldNumber_CourseVideoPbArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(MEPBCourseVideoClass__storage_, courseVideoPbArray),
        .flags = (GPBFieldFlags)(GPBFieldRepeated | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[MEPBCourseVideoClass class]
                                     rootClass:[MevideoRoot class]
                                          file:MevideoRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(MEPBCourseVideoClass__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\003\002\007\000\003\010\000\004\000courseVideoPb\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - MEPBCourseVideoLabel

@implementation MEPBCourseVideoLabel

@dynamic id_p;
@dynamic title;

typedef struct MEPBCourseVideoLabel__storage_ {
  uint32_t _has_storage_[1];
  NSString *title;
  int64_t id_p;
} MEPBCourseVideoLabel__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "id_p",
        .dataTypeSpecific.className = NULL,
        .number = MEPBCourseVideoLabel_FieldNumber_Id_p,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(MEPBCourseVideoLabel__storage_, id_p),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "title",
        .dataTypeSpecific.className = NULL,
        .number = MEPBCourseVideoLabel_FieldNumber_Title,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(MEPBCourseVideoLabel__storage_, title),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[MEPBCourseVideoLabel class]
                                     rootClass:[MevideoRoot class]
                                          file:MevideoRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(MEPBCourseVideoLabel__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end


#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)