// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: MEUser.proto

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

 #import "Meuser.pbobjc.h"
 #import "Meclass.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - MeuserRoot

@implementation MeuserRoot

// No extensions in the file and none of the imports (direct or indirect)
// defined extensions, so no need to generate +extensionRegistry.

@end

#pragma mark - MeuserRoot_FileDescriptor

static GPBFileDescriptor *MeuserRoot_FileDescriptor(void) {
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

#pragma mark - Enum MEPBUserRole

GPBEnumDescriptor *MEPBUserRole_EnumDescriptor(void) {
  static GPBEnumDescriptor *descriptor = NULL;
  if (!descriptor) {
    static const char *valueNames =
        "Visitor\000Teacher\000Parent\000Gardener\000";
    static const int32_t values[] = {
        MEPBUserRole_Visitor,
        MEPBUserRole_Teacher,
        MEPBUserRole_Parent,
        MEPBUserRole_Gardener,
    };
    static const char *extraTextFormatInfo = "\004\000\007\000\001\007\000\002\006\000\003\010\000";
    GPBEnumDescriptor *worker =
        [GPBEnumDescriptor allocDescriptorForName:GPBNSStringifySymbol(MEPBUserRole)
                                       valueNames:valueNames
                                           values:values
                                            count:(uint32_t)(sizeof(values) / sizeof(int32_t))
                                     enumVerifier:MEPBUserRole_IsValidValue
                              extraTextFormatInfo:extraTextFormatInfo];
    if (!OSAtomicCompareAndSwapPtrBarrier(nil, worker, (void * volatile *)&descriptor)) {
      [worker release];
    }
  }
  return descriptor;
}

BOOL MEPBUserRole_IsValidValue(int32_t value__) {
  switch (value__) {
    case MEPBUserRole_Visitor:
    case MEPBUserRole_Teacher:
    case MEPBUserRole_Parent:
    case MEPBUserRole_Gardener:
      return YES;
    default:
      return NO;
  }
}

#pragma mark - MEPBUserList

@implementation MEPBUserList

@dynamic userListArray, userListArray_Count;

typedef struct MEPBUserList__storage_ {
  uint32_t _has_storage_[1];
  NSMutableArray *userListArray;
} MEPBUserList__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "userListArray",
        .dataTypeSpecific.className = GPBStringifySymbol(MEPBUser),
        .number = MEPBUserList_FieldNumber_UserListArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(MEPBUserList__storage_, userListArray),
        .flags = (GPBFieldFlags)(GPBFieldRepeated | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[MEPBUserList class]
                                     rootClass:[MeuserRoot class]
                                          file:MeuserRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(MEPBUserList__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\001\001\000userList\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - MEPBUser

@implementation MEPBUser

@dynamic id_p;
@dynamic schoolId;
@dynamic uuid;
@dynamic username;
@dynamic password;
@dynamic name;
@dynamic userType;
@dynamic phaseId;
@dynamic gender;
@dynamic mobile;
@dynamic address;
@dynamic email;
@dynamic token;
@dynamic schoolName;
@dynamic portrait;
@dynamic hasParentsPb, parentsPb;
@dynamic hasTeacherPb, teacherPb;
@dynamic hasSchoolPb, schoolPb;
@dynamic funcCtrlPbArray, funcCtrlPbArray_Count;
@dynamic hasInitPwd;
@dynamic bucketDomain;
@dynamic uptoken;
@dynamic groupStatus;
@dynamic isMember;
@dynamic deadline;
@dynamic hasSystemConfigPb, systemConfigPb;
@dynamic diskCap;
@dynamic hasDeanPb, deanPb;
@dynamic isTourist;
@dynamic rcToken;
@dynamic isUserCharge;
@dynamic code;
@dynamic sessionToken;
@dynamic signinstamp;

typedef struct MEPBUser__storage_ {
  uint32_t _has_storage_[2];
  MEPBUserRole userType;
  int32_t gender;
  int32_t hasInitPwd;
  int32_t groupStatus;
  int32_t isMember;
  int32_t isTourist;
  int32_t isUserCharge;
  NSString *uuid;
  NSString *username;
  NSString *password;
  NSString *name;
  NSString *mobile;
  NSString *address;
  NSString *email;
  NSString *token;
  NSString *schoolName;
  NSString *portrait;
  ParentsPb *parentsPb;
  TeacherPb *teacherPb;
  SchoolPb *schoolPb;
  NSMutableArray *funcCtrlPbArray;
  NSString *bucketDomain;
  NSString *uptoken;
  SystemConfigPb *systemConfigPb;
  DeanPb *deanPb;
  NSString *rcToken;
  NSString *code;
  NSString *sessionToken;
  int64_t id_p;
  int64_t schoolId;
  int64_t phaseId;
  int64_t deadline;
  int64_t diskCap;
  int64_t signinstamp;
} MEPBUser__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "id_p",
        .dataTypeSpecific.className = NULL,
        .number = MEPBUser_FieldNumber_Id_p,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(MEPBUser__storage_, id_p),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "schoolId",
        .dataTypeSpecific.className = NULL,
        .number = MEPBUser_FieldNumber_SchoolId,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(MEPBUser__storage_, schoolId),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "uuid",
        .dataTypeSpecific.className = NULL,
        .number = MEPBUser_FieldNumber_Uuid,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(MEPBUser__storage_, uuid),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "username",
        .dataTypeSpecific.className = NULL,
        .number = MEPBUser_FieldNumber_Username,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(MEPBUser__storage_, username),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "password",
        .dataTypeSpecific.className = NULL,
        .number = MEPBUser_FieldNumber_Password,
        .hasIndex = 4,
        .offset = (uint32_t)offsetof(MEPBUser__storage_, password),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "name",
        .dataTypeSpecific.className = NULL,
        .number = MEPBUser_FieldNumber_Name,
        .hasIndex = 5,
        .offset = (uint32_t)offsetof(MEPBUser__storage_, name),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "userType",
        .dataTypeSpecific.enumDescFunc = MEPBUserRole_EnumDescriptor,
        .number = MEPBUser_FieldNumber_UserType,
        .hasIndex = 6,
        .offset = (uint32_t)offsetof(MEPBUser__storage_, userType),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom | GPBFieldHasEnumDescriptor),
        .dataType = GPBDataTypeEnum,
      },
      {
        .name = "phaseId",
        .dataTypeSpecific.className = NULL,
        .number = MEPBUser_FieldNumber_PhaseId,
        .hasIndex = 7,
        .offset = (uint32_t)offsetof(MEPBUser__storage_, phaseId),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "gender",
        .dataTypeSpecific.className = NULL,
        .number = MEPBUser_FieldNumber_Gender,
        .hasIndex = 8,
        .offset = (uint32_t)offsetof(MEPBUser__storage_, gender),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "mobile",
        .dataTypeSpecific.className = NULL,
        .number = MEPBUser_FieldNumber_Mobile,
        .hasIndex = 9,
        .offset = (uint32_t)offsetof(MEPBUser__storage_, mobile),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "address",
        .dataTypeSpecific.className = NULL,
        .number = MEPBUser_FieldNumber_Address,
        .hasIndex = 10,
        .offset = (uint32_t)offsetof(MEPBUser__storage_, address),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "email",
        .dataTypeSpecific.className = NULL,
        .number = MEPBUser_FieldNumber_Email,
        .hasIndex = 11,
        .offset = (uint32_t)offsetof(MEPBUser__storage_, email),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "token",
        .dataTypeSpecific.className = NULL,
        .number = MEPBUser_FieldNumber_Token,
        .hasIndex = 12,
        .offset = (uint32_t)offsetof(MEPBUser__storage_, token),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "schoolName",
        .dataTypeSpecific.className = NULL,
        .number = MEPBUser_FieldNumber_SchoolName,
        .hasIndex = 13,
        .offset = (uint32_t)offsetof(MEPBUser__storage_, schoolName),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "portrait",
        .dataTypeSpecific.className = NULL,
        .number = MEPBUser_FieldNumber_Portrait,
        .hasIndex = 14,
        .offset = (uint32_t)offsetof(MEPBUser__storage_, portrait),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "parentsPb",
        .dataTypeSpecific.className = GPBStringifySymbol(ParentsPb),
        .number = MEPBUser_FieldNumber_ParentsPb,
        .hasIndex = 15,
        .offset = (uint32_t)offsetof(MEPBUser__storage_, parentsPb),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
      {
        .name = "teacherPb",
        .dataTypeSpecific.className = GPBStringifySymbol(TeacherPb),
        .number = MEPBUser_FieldNumber_TeacherPb,
        .hasIndex = 16,
        .offset = (uint32_t)offsetof(MEPBUser__storage_, teacherPb),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
      {
        .name = "schoolPb",
        .dataTypeSpecific.className = GPBStringifySymbol(SchoolPb),
        .number = MEPBUser_FieldNumber_SchoolPb,
        .hasIndex = 17,
        .offset = (uint32_t)offsetof(MEPBUser__storage_, schoolPb),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
      {
        .name = "funcCtrlPbArray",
        .dataTypeSpecific.className = GPBStringifySymbol(FuncCtrlPb),
        .number = MEPBUser_FieldNumber_FuncCtrlPbArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(MEPBUser__storage_, funcCtrlPbArray),
        .flags = (GPBFieldFlags)(GPBFieldRepeated | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
      {
        .name = "hasInitPwd",
        .dataTypeSpecific.className = NULL,
        .number = MEPBUser_FieldNumber_HasInitPwd,
        .hasIndex = 18,
        .offset = (uint32_t)offsetof(MEPBUser__storage_, hasInitPwd),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "bucketDomain",
        .dataTypeSpecific.className = NULL,
        .number = MEPBUser_FieldNumber_BucketDomain,
        .hasIndex = 19,
        .offset = (uint32_t)offsetof(MEPBUser__storage_, bucketDomain),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "uptoken",
        .dataTypeSpecific.className = NULL,
        .number = MEPBUser_FieldNumber_Uptoken,
        .hasIndex = 20,
        .offset = (uint32_t)offsetof(MEPBUser__storage_, uptoken),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "groupStatus",
        .dataTypeSpecific.className = NULL,
        .number = MEPBUser_FieldNumber_GroupStatus,
        .hasIndex = 21,
        .offset = (uint32_t)offsetof(MEPBUser__storage_, groupStatus),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "isMember",
        .dataTypeSpecific.className = NULL,
        .number = MEPBUser_FieldNumber_IsMember,
        .hasIndex = 22,
        .offset = (uint32_t)offsetof(MEPBUser__storage_, isMember),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "deadline",
        .dataTypeSpecific.className = NULL,
        .number = MEPBUser_FieldNumber_Deadline,
        .hasIndex = 23,
        .offset = (uint32_t)offsetof(MEPBUser__storage_, deadline),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "systemConfigPb",
        .dataTypeSpecific.className = GPBStringifySymbol(SystemConfigPb),
        .number = MEPBUser_FieldNumber_SystemConfigPb,
        .hasIndex = 24,
        .offset = (uint32_t)offsetof(MEPBUser__storage_, systemConfigPb),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
      {
        .name = "diskCap",
        .dataTypeSpecific.className = NULL,
        .number = MEPBUser_FieldNumber_DiskCap,
        .hasIndex = 25,
        .offset = (uint32_t)offsetof(MEPBUser__storage_, diskCap),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "deanPb",
        .dataTypeSpecific.className = GPBStringifySymbol(DeanPb),
        .number = MEPBUser_FieldNumber_DeanPb,
        .hasIndex = 26,
        .offset = (uint32_t)offsetof(MEPBUser__storage_, deanPb),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
      {
        .name = "isTourist",
        .dataTypeSpecific.className = NULL,
        .number = MEPBUser_FieldNumber_IsTourist,
        .hasIndex = 27,
        .offset = (uint32_t)offsetof(MEPBUser__storage_, isTourist),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "rcToken",
        .dataTypeSpecific.className = NULL,
        .number = MEPBUser_FieldNumber_RcToken,
        .hasIndex = 28,
        .offset = (uint32_t)offsetof(MEPBUser__storage_, rcToken),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "isUserCharge",
        .dataTypeSpecific.className = NULL,
        .number = MEPBUser_FieldNumber_IsUserCharge,
        .hasIndex = 29,
        .offset = (uint32_t)offsetof(MEPBUser__storage_, isUserCharge),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "code",
        .dataTypeSpecific.className = NULL,
        .number = MEPBUser_FieldNumber_Code,
        .hasIndex = 30,
        .offset = (uint32_t)offsetof(MEPBUser__storage_, code),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "sessionToken",
        .dataTypeSpecific.className = NULL,
        .number = MEPBUser_FieldNumber_SessionToken,
        .hasIndex = 31,
        .offset = (uint32_t)offsetof(MEPBUser__storage_, sessionToken),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "signinstamp",
        .dataTypeSpecific.className = NULL,
        .number = MEPBUser_FieldNumber_Signinstamp,
        .hasIndex = 32,
        .offset = (uint32_t)offsetof(MEPBUser__storage_, signinstamp),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[MEPBUser class]
                                     rootClass:[MeuserRoot class]
                                          file:MeuserRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(MEPBUser__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\023\002\010\000\007\010\000\010\007\000\016\n\000\020\t\000\021\t\000\022\010\000\023\000funcCtrlPb\000\024\n\000\025\014"
        "\000\027\013\000\030\010\000\032\016\000\033\007\000\034\006\000\035\t\000\036\007\000\037\014\000!\014\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

int32_t MEPBUser_UserType_RawValue(MEPBUser *message) {
  GPBDescriptor *descriptor = [MEPBUser descriptor];
  GPBFieldDescriptor *field = [descriptor fieldWithNumber:MEPBUser_FieldNumber_UserType];
  return GPBGetMessageInt32Field(message, field);
}

void SetMEPBUser_UserType_RawValue(MEPBUser *message, int32_t value) {
  GPBDescriptor *descriptor = [MEPBUser descriptor];
  GPBFieldDescriptor *field = [descriptor fieldWithNumber:MEPBUser_FieldNumber_UserType];
  GPBSetInt32IvarWithFieldInternal(message, field, value, descriptor.file.syntax);
}

#pragma mark - SchoolPb

@implementation SchoolPb

@dynamic id_p;
@dynamic domain;
@dynamic name;
@dynamic year;
@dynamic semester;
@dynamic isSchoolCharge;
@dynamic freeDate;

typedef struct SchoolPb__storage_ {
  uint32_t _has_storage_[1];
  int32_t semester;
  int32_t isSchoolCharge;
  NSString *domain;
  NSString *name;
  int64_t id_p;
  int64_t year;
  int64_t freeDate;
} SchoolPb__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "id_p",
        .dataTypeSpecific.className = NULL,
        .number = SchoolPb_FieldNumber_Id_p,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(SchoolPb__storage_, id_p),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "domain",
        .dataTypeSpecific.className = NULL,
        .number = SchoolPb_FieldNumber_Domain,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(SchoolPb__storage_, domain),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "name",
        .dataTypeSpecific.className = NULL,
        .number = SchoolPb_FieldNumber_Name,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(SchoolPb__storage_, name),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "year",
        .dataTypeSpecific.className = NULL,
        .number = SchoolPb_FieldNumber_Year,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(SchoolPb__storage_, year),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "semester",
        .dataTypeSpecific.className = NULL,
        .number = SchoolPb_FieldNumber_Semester,
        .hasIndex = 4,
        .offset = (uint32_t)offsetof(SchoolPb__storage_, semester),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "isSchoolCharge",
        .dataTypeSpecific.className = NULL,
        .number = SchoolPb_FieldNumber_IsSchoolCharge,
        .hasIndex = 5,
        .offset = (uint32_t)offsetof(SchoolPb__storage_, isSchoolCharge),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "freeDate",
        .dataTypeSpecific.className = NULL,
        .number = SchoolPb_FieldNumber_FreeDate,
        .hasIndex = 6,
        .offset = (uint32_t)offsetof(SchoolPb__storage_, freeDate),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt64,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[SchoolPb class]
                                     rootClass:[MeuserRoot class]
                                          file:MeuserRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(SchoolPb__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\002\006\016\000\007\010\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - FuncCtrlPb

@implementation FuncCtrlPb

@dynamic schoolId;
@dynamic funcCode;
@dynamic androidStatus;
@dynamic iosStatus;

typedef struct FuncCtrlPb__storage_ {
  uint32_t _has_storage_[1];
  int32_t androidStatus;
  int32_t iosStatus;
  NSString *funcCode;
  int64_t schoolId;
} FuncCtrlPb__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "schoolId",
        .dataTypeSpecific.className = NULL,
        .number = FuncCtrlPb_FieldNumber_SchoolId,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(FuncCtrlPb__storage_, schoolId),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "funcCode",
        .dataTypeSpecific.className = NULL,
        .number = FuncCtrlPb_FieldNumber_FuncCode,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(FuncCtrlPb__storage_, funcCode),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "androidStatus",
        .dataTypeSpecific.className = NULL,
        .number = FuncCtrlPb_FieldNumber_AndroidStatus,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(FuncCtrlPb__storage_, androidStatus),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "iosStatus",
        .dataTypeSpecific.className = NULL,
        .number = FuncCtrlPb_FieldNumber_IosStatus,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(FuncCtrlPb__storage_, iosStatus),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt32,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[FuncCtrlPb class]
                                     rootClass:[MeuserRoot class]
                                          file:MeuserRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(FuncCtrlPb__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\004\001\010\000\002\010\000\003\r\000\004\t\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - ParentsPb

@implementation ParentsPb

@dynamic mobile;
@dynamic studentPbArray, studentPbArray_Count;
@dynamic classPbArray, classPbArray_Count;

typedef struct ParentsPb__storage_ {
  uint32_t _has_storage_[1];
  NSString *mobile;
  NSMutableArray *studentPbArray;
  NSMutableArray *classPbArray;
} ParentsPb__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "mobile",
        .dataTypeSpecific.className = NULL,
        .number = ParentsPb_FieldNumber_Mobile,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(ParentsPb__storage_, mobile),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "studentPbArray",
        .dataTypeSpecific.className = GPBStringifySymbol(StudentPb),
        .number = ParentsPb_FieldNumber_StudentPbArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(ParentsPb__storage_, studentPbArray),
        .flags = (GPBFieldFlags)(GPBFieldRepeated | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
      {
        .name = "classPbArray",
        .dataTypeSpecific.className = GPBStringifySymbol(MEPBClass),
        .number = ParentsPb_FieldNumber_ClassPbArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(ParentsPb__storage_, classPbArray),
        .flags = (GPBFieldFlags)(GPBFieldRepeated | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[ParentsPb class]
                                     rootClass:[MeuserRoot class]
                                          file:MeuserRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(ParentsPb__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\002\002\000studentPb\000\003\000classPb\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - TeacherPb

@implementation TeacherPb

@dynamic mobile;
@dynamic classPbArray, classPbArray_Count;

typedef struct TeacherPb__storage_ {
  uint32_t _has_storage_[1];
  NSString *mobile;
  NSMutableArray *classPbArray;
} TeacherPb__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "mobile",
        .dataTypeSpecific.className = NULL,
        .number = TeacherPb_FieldNumber_Mobile,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(TeacherPb__storage_, mobile),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "classPbArray",
        .dataTypeSpecific.className = GPBStringifySymbol(MEPBClass),
        .number = TeacherPb_FieldNumber_ClassPbArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(TeacherPb__storage_, classPbArray),
        .flags = (GPBFieldFlags)(GPBFieldRepeated | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[TeacherPb class]
                                     rootClass:[MeuserRoot class]
                                          file:MeuserRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(TeacherPb__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\001\002\000classPb\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - DeanPb

@implementation DeanPb

@dynamic classPbArray, classPbArray_Count;

typedef struct DeanPb__storage_ {
  uint32_t _has_storage_[1];
  NSMutableArray *classPbArray;
} DeanPb__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "classPbArray",
        .dataTypeSpecific.className = GPBStringifySymbol(MEPBClass),
        .number = DeanPb_FieldNumber_ClassPbArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(DeanPb__storage_, classPbArray),
        .flags = (GPBFieldFlags)(GPBFieldRepeated | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[DeanPb class]
                                     rootClass:[MeuserRoot class]
                                          file:MeuserRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(DeanPb__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\001\001\000classPb\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - StudentPb

@implementation StudentPb

@dynamic id_p;
@dynamic uuid;
@dynamic name;
@dynamic classId;
@dynamic gradeId;
@dynamic classNo;
@dynamic birthday;
@dynamic parentType;
@dynamic gender;

typedef struct StudentPb__storage_ {
  uint32_t _has_storage_[1];
  int32_t parentType;
  int32_t gender;
  NSString *uuid;
  NSString *name;
  NSString *classNo;
  int64_t id_p;
  int64_t classId;
  int64_t gradeId;
  int64_t birthday;
} StudentPb__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "id_p",
        .dataTypeSpecific.className = NULL,
        .number = StudentPb_FieldNumber_Id_p,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(StudentPb__storage_, id_p),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "uuid",
        .dataTypeSpecific.className = NULL,
        .number = StudentPb_FieldNumber_Uuid,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(StudentPb__storage_, uuid),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "name",
        .dataTypeSpecific.className = NULL,
        .number = StudentPb_FieldNumber_Name,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(StudentPb__storage_, name),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "classId",
        .dataTypeSpecific.className = NULL,
        .number = StudentPb_FieldNumber_ClassId,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(StudentPb__storage_, classId),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "gradeId",
        .dataTypeSpecific.className = NULL,
        .number = StudentPb_FieldNumber_GradeId,
        .hasIndex = 4,
        .offset = (uint32_t)offsetof(StudentPb__storage_, gradeId),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "classNo",
        .dataTypeSpecific.className = NULL,
        .number = StudentPb_FieldNumber_ClassNo,
        .hasIndex = 5,
        .offset = (uint32_t)offsetof(StudentPb__storage_, classNo),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "birthday",
        .dataTypeSpecific.className = NULL,
        .number = StudentPb_FieldNumber_Birthday,
        .hasIndex = 6,
        .offset = (uint32_t)offsetof(StudentPb__storage_, birthday),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "parentType",
        .dataTypeSpecific.className = NULL,
        .number = StudentPb_FieldNumber_ParentType,
        .hasIndex = 7,
        .offset = (uint32_t)offsetof(StudentPb__storage_, parentType),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "gender",
        .dataTypeSpecific.className = NULL,
        .number = StudentPb_FieldNumber_Gender,
        .hasIndex = 8,
        .offset = (uint32_t)offsetof(StudentPb__storage_, gender),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt32,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[StudentPb class]
                                     rootClass:[MeuserRoot class]
                                          file:MeuserRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(StudentPb__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\004\004\007\000\005\007\000\006\007\000\010\n\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - SystemConfigPb

@implementation SystemConfigPb

@dynamic diskCap;
@dynamic uploadLimit;

typedef struct SystemConfigPb__storage_ {
  uint32_t _has_storage_[1];
  NSString *diskCap;
  NSString *uploadLimit;
} SystemConfigPb__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "diskCap",
        .dataTypeSpecific.className = NULL,
        .number = SystemConfigPb_FieldNumber_DiskCap,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(SystemConfigPb__storage_, diskCap),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "uploadLimit",
        .dataTypeSpecific.className = NULL,
        .number = SystemConfigPb_FieldNumber_UploadLimit,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(SystemConfigPb__storage_, uploadLimit),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[SystemConfigPb class]
                                     rootClass:[MeuserRoot class]
                                          file:MeuserRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(SystemConfigPb__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\002\001\007\000\002\013\000";
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
