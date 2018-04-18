// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: MEBabyAlbum.proto

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

 #import "MebabyAlbum.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - MebabyAlbumRoot

@implementation MebabyAlbumRoot

// No extensions in the file and no imports, so no need to generate
// +extensionRegistry.

@end

#pragma mark - MebabyAlbumRoot_FileDescriptor

static GPBFileDescriptor *MebabyAlbumRoot_FileDescriptor(void) {
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

#pragma mark - ClassAlbumListPb

@implementation ClassAlbumListPb

@dynamic classAlbumArray, classAlbumArray_Count;

typedef struct ClassAlbumListPb__storage_ {
  uint32_t _has_storage_[1];
  NSMutableArray *classAlbumArray;
} ClassAlbumListPb__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "classAlbumArray",
        .dataTypeSpecific.className = GPBStringifySymbol(ClassAlbumPb),
        .number = ClassAlbumListPb_FieldNumber_ClassAlbumArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(ClassAlbumListPb__storage_, classAlbumArray),
        .flags = (GPBFieldFlags)(GPBFieldRepeated | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[ClassAlbumListPb class]
                                     rootClass:[MebabyAlbumRoot class]
                                          file:MebabyAlbumRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(ClassAlbumListPb__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\001\001\000classAlbum\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - ClassAlbumPb

@implementation ClassAlbumPb

@dynamic id_p;
@dynamic classId;
@dynamic isParent;
@dynamic parentId;
@dynamic fileId;
@dynamic fileName;
@dynamic fileType;
@dynamic fileSize;
@dynamic filePath;
@dynamic dataStatus;
@dynamic createdDate;
@dynamic modifiedDate;
@dynamic md5;

typedef struct ClassAlbumPb__storage_ {
  uint32_t _has_storage_[1];
  int32_t isParent;
  int32_t dataStatus;
  NSString *fileName;
  NSString *fileType;
  NSString *filePath;
  NSString *md5;
  int64_t id_p;
  int64_t classId;
  int64_t parentId;
  int64_t fileId;
  int64_t fileSize;
  int64_t createdDate;
  int64_t modifiedDate;
} ClassAlbumPb__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "id_p",
        .dataTypeSpecific.className = NULL,
        .number = ClassAlbumPb_FieldNumber_Id_p,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(ClassAlbumPb__storage_, id_p),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "classId",
        .dataTypeSpecific.className = NULL,
        .number = ClassAlbumPb_FieldNumber_ClassId,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(ClassAlbumPb__storage_, classId),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "isParent",
        .dataTypeSpecific.className = NULL,
        .number = ClassAlbumPb_FieldNumber_IsParent,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(ClassAlbumPb__storage_, isParent),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "parentId",
        .dataTypeSpecific.className = NULL,
        .number = ClassAlbumPb_FieldNumber_ParentId,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(ClassAlbumPb__storage_, parentId),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "fileId",
        .dataTypeSpecific.className = NULL,
        .number = ClassAlbumPb_FieldNumber_FileId,
        .hasIndex = 4,
        .offset = (uint32_t)offsetof(ClassAlbumPb__storage_, fileId),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "fileName",
        .dataTypeSpecific.className = NULL,
        .number = ClassAlbumPb_FieldNumber_FileName,
        .hasIndex = 5,
        .offset = (uint32_t)offsetof(ClassAlbumPb__storage_, fileName),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "fileType",
        .dataTypeSpecific.className = NULL,
        .number = ClassAlbumPb_FieldNumber_FileType,
        .hasIndex = 6,
        .offset = (uint32_t)offsetof(ClassAlbumPb__storage_, fileType),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "fileSize",
        .dataTypeSpecific.className = NULL,
        .number = ClassAlbumPb_FieldNumber_FileSize,
        .hasIndex = 7,
        .offset = (uint32_t)offsetof(ClassAlbumPb__storage_, fileSize),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "filePath",
        .dataTypeSpecific.className = NULL,
        .number = ClassAlbumPb_FieldNumber_FilePath,
        .hasIndex = 8,
        .offset = (uint32_t)offsetof(ClassAlbumPb__storage_, filePath),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "dataStatus",
        .dataTypeSpecific.className = NULL,
        .number = ClassAlbumPb_FieldNumber_DataStatus,
        .hasIndex = 9,
        .offset = (uint32_t)offsetof(ClassAlbumPb__storage_, dataStatus),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "createdDate",
        .dataTypeSpecific.className = NULL,
        .number = ClassAlbumPb_FieldNumber_CreatedDate,
        .hasIndex = 10,
        .offset = (uint32_t)offsetof(ClassAlbumPb__storage_, createdDate),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "modifiedDate",
        .dataTypeSpecific.className = NULL,
        .number = ClassAlbumPb_FieldNumber_ModifiedDate,
        .hasIndex = 11,
        .offset = (uint32_t)offsetof(ClassAlbumPb__storage_, modifiedDate),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "md5",
        .dataTypeSpecific.className = NULL,
        .number = ClassAlbumPb_FieldNumber_Md5,
        .hasIndex = 12,
        .offset = (uint32_t)offsetof(ClassAlbumPb__storage_, md5),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[ClassAlbumPb class]
                                     rootClass:[MebabyAlbumRoot class]
                                          file:MebabyAlbumRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(ClassAlbumPb__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\013\002\007\000\003\010\000\004\010\000\005\006\000\006\010\000\007\010\000\010\010\000\t\010\000\n\n\000\013\013\000\014\014\000";
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
