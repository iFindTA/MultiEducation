// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: MEBabyGrowth.proto

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

 #import "MebabyGrowth.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - MebabyGrowthRoot

@implementation MebabyGrowthRoot

// No extensions in the file and no imports, so no need to generate
// +extensionRegistry.

@end

#pragma mark - MebabyGrowthRoot_FileDescriptor

static GPBFileDescriptor *MebabyGrowthRoot_FileDescriptor(void) {
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

#pragma mark - GuStudentArchivesListPb

@implementation GuStudentArchivesListPb

@dynamic hasStudentArchivesPb, studentArchivesPb;

typedef struct GuStudentArchivesListPb__storage_ {
  uint32_t _has_storage_[1];
  GuStudentArchivesPb *studentArchivesPb;
} GuStudentArchivesListPb__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "studentArchivesPb",
        .dataTypeSpecific.className = GPBStringifySymbol(GuStudentArchivesPb),
        .number = GuStudentArchivesListPb_FieldNumber_StudentArchivesPb,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(GuStudentArchivesListPb__storage_, studentArchivesPb),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[GuStudentArchivesListPb class]
                                     rootClass:[MebabyGrowthRoot class]
                                          file:MebabyGrowthRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(GuStudentArchivesListPb__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\001\001\021\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - GuStudentArchivesPb

@implementation GuStudentArchivesPb

@dynamic title;
@dynamic studentId;
@dynamic gradeId;
@dynamic semester;
@dynamic petName;
@dynamic gender;
@dynamic birthday;
@dynamic age;
@dynamic zodiac;
@dynamic height;
@dynamic weight;
@dynamic leftVision;
@dynamic rightVision;
@dynamic bloodType;
@dynamic hemoglobin;
@dynamic nation;
@dynamic homeAddress;
@dynamic contactNumber;
@dynamic warnItem;
@dynamic motherName;
@dynamic motherMobile;
@dynamic motherWorkUnit;
@dynamic fatherName;
@dynamic fatherMobile;
@dynamic fatherWorkUnit;
@dynamic studentPortrait;
@dynamic studentName;
@dynamic classId;
@dynamic userId;

typedef struct GuStudentArchivesPb__storage_ {
  uint32_t _has_storage_[1];
  int32_t semester;
  int32_t gender;
  int32_t age;
  int32_t height;
  int32_t weight;
  int32_t hemoglobin;
  NSString *petName;
  NSString *zodiac;
  NSString *leftVision;
  NSString *rightVision;
  NSString *bloodType;
  NSString *nation;
  NSString *homeAddress;
  NSString *contactNumber;
  NSString *warnItem;
  NSString *motherName;
  NSString *motherMobile;
  NSString *motherWorkUnit;
  NSString *fatherName;
  NSString *fatherMobile;
  NSString *fatherWorkUnit;
  NSString *studentPortrait;
  NSString *studentName;
  int64_t title;
  int64_t studentId;
  int64_t gradeId;
  int64_t birthday;
  int64_t classId;
  int64_t userId;
} GuStudentArchivesPb__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "title",
        .dataTypeSpecific.className = NULL,
        .number = GuStudentArchivesPb_FieldNumber_Title,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(GuStudentArchivesPb__storage_, title),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "studentId",
        .dataTypeSpecific.className = NULL,
        .number = GuStudentArchivesPb_FieldNumber_StudentId,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(GuStudentArchivesPb__storage_, studentId),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "gradeId",
        .dataTypeSpecific.className = NULL,
        .number = GuStudentArchivesPb_FieldNumber_GradeId,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(GuStudentArchivesPb__storage_, gradeId),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "semester",
        .dataTypeSpecific.className = NULL,
        .number = GuStudentArchivesPb_FieldNumber_Semester,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(GuStudentArchivesPb__storage_, semester),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "petName",
        .dataTypeSpecific.className = NULL,
        .number = GuStudentArchivesPb_FieldNumber_PetName,
        .hasIndex = 4,
        .offset = (uint32_t)offsetof(GuStudentArchivesPb__storage_, petName),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "gender",
        .dataTypeSpecific.className = NULL,
        .number = GuStudentArchivesPb_FieldNumber_Gender,
        .hasIndex = 5,
        .offset = (uint32_t)offsetof(GuStudentArchivesPb__storage_, gender),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "birthday",
        .dataTypeSpecific.className = NULL,
        .number = GuStudentArchivesPb_FieldNumber_Birthday,
        .hasIndex = 6,
        .offset = (uint32_t)offsetof(GuStudentArchivesPb__storage_, birthday),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "age",
        .dataTypeSpecific.className = NULL,
        .number = GuStudentArchivesPb_FieldNumber_Age,
        .hasIndex = 7,
        .offset = (uint32_t)offsetof(GuStudentArchivesPb__storage_, age),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "zodiac",
        .dataTypeSpecific.className = NULL,
        .number = GuStudentArchivesPb_FieldNumber_Zodiac,
        .hasIndex = 8,
        .offset = (uint32_t)offsetof(GuStudentArchivesPb__storage_, zodiac),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "height",
        .dataTypeSpecific.className = NULL,
        .number = GuStudentArchivesPb_FieldNumber_Height,
        .hasIndex = 9,
        .offset = (uint32_t)offsetof(GuStudentArchivesPb__storage_, height),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "weight",
        .dataTypeSpecific.className = NULL,
        .number = GuStudentArchivesPb_FieldNumber_Weight,
        .hasIndex = 10,
        .offset = (uint32_t)offsetof(GuStudentArchivesPb__storage_, weight),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "leftVision",
        .dataTypeSpecific.className = NULL,
        .number = GuStudentArchivesPb_FieldNumber_LeftVision,
        .hasIndex = 11,
        .offset = (uint32_t)offsetof(GuStudentArchivesPb__storage_, leftVision),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "rightVision",
        .dataTypeSpecific.className = NULL,
        .number = GuStudentArchivesPb_FieldNumber_RightVision,
        .hasIndex = 12,
        .offset = (uint32_t)offsetof(GuStudentArchivesPb__storage_, rightVision),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "bloodType",
        .dataTypeSpecific.className = NULL,
        .number = GuStudentArchivesPb_FieldNumber_BloodType,
        .hasIndex = 13,
        .offset = (uint32_t)offsetof(GuStudentArchivesPb__storage_, bloodType),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "hemoglobin",
        .dataTypeSpecific.className = NULL,
        .number = GuStudentArchivesPb_FieldNumber_Hemoglobin,
        .hasIndex = 14,
        .offset = (uint32_t)offsetof(GuStudentArchivesPb__storage_, hemoglobin),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "nation",
        .dataTypeSpecific.className = NULL,
        .number = GuStudentArchivesPb_FieldNumber_Nation,
        .hasIndex = 15,
        .offset = (uint32_t)offsetof(GuStudentArchivesPb__storage_, nation),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "homeAddress",
        .dataTypeSpecific.className = NULL,
        .number = GuStudentArchivesPb_FieldNumber_HomeAddress,
        .hasIndex = 16,
        .offset = (uint32_t)offsetof(GuStudentArchivesPb__storage_, homeAddress),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "contactNumber",
        .dataTypeSpecific.className = NULL,
        .number = GuStudentArchivesPb_FieldNumber_ContactNumber,
        .hasIndex = 17,
        .offset = (uint32_t)offsetof(GuStudentArchivesPb__storage_, contactNumber),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "warnItem",
        .dataTypeSpecific.className = NULL,
        .number = GuStudentArchivesPb_FieldNumber_WarnItem,
        .hasIndex = 18,
        .offset = (uint32_t)offsetof(GuStudentArchivesPb__storage_, warnItem),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "motherName",
        .dataTypeSpecific.className = NULL,
        .number = GuStudentArchivesPb_FieldNumber_MotherName,
        .hasIndex = 19,
        .offset = (uint32_t)offsetof(GuStudentArchivesPb__storage_, motherName),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "motherMobile",
        .dataTypeSpecific.className = NULL,
        .number = GuStudentArchivesPb_FieldNumber_MotherMobile,
        .hasIndex = 20,
        .offset = (uint32_t)offsetof(GuStudentArchivesPb__storage_, motherMobile),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "motherWorkUnit",
        .dataTypeSpecific.className = NULL,
        .number = GuStudentArchivesPb_FieldNumber_MotherWorkUnit,
        .hasIndex = 21,
        .offset = (uint32_t)offsetof(GuStudentArchivesPb__storage_, motherWorkUnit),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "fatherName",
        .dataTypeSpecific.className = NULL,
        .number = GuStudentArchivesPb_FieldNumber_FatherName,
        .hasIndex = 22,
        .offset = (uint32_t)offsetof(GuStudentArchivesPb__storage_, fatherName),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "fatherMobile",
        .dataTypeSpecific.className = NULL,
        .number = GuStudentArchivesPb_FieldNumber_FatherMobile,
        .hasIndex = 23,
        .offset = (uint32_t)offsetof(GuStudentArchivesPb__storage_, fatherMobile),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "fatherWorkUnit",
        .dataTypeSpecific.className = NULL,
        .number = GuStudentArchivesPb_FieldNumber_FatherWorkUnit,
        .hasIndex = 24,
        .offset = (uint32_t)offsetof(GuStudentArchivesPb__storage_, fatherWorkUnit),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "studentPortrait",
        .dataTypeSpecific.className = NULL,
        .number = GuStudentArchivesPb_FieldNumber_StudentPortrait,
        .hasIndex = 25,
        .offset = (uint32_t)offsetof(GuStudentArchivesPb__storage_, studentPortrait),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "studentName",
        .dataTypeSpecific.className = NULL,
        .number = GuStudentArchivesPb_FieldNumber_StudentName,
        .hasIndex = 26,
        .offset = (uint32_t)offsetof(GuStudentArchivesPb__storage_, studentName),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "classId",
        .dataTypeSpecific.className = NULL,
        .number = GuStudentArchivesPb_FieldNumber_ClassId,
        .hasIndex = 27,
        .offset = (uint32_t)offsetof(GuStudentArchivesPb__storage_, classId),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "userId",
        .dataTypeSpecific.className = NULL,
        .number = GuStudentArchivesPb_FieldNumber_UserId,
        .hasIndex = 28,
        .offset = (uint32_t)offsetof(GuStudentArchivesPb__storage_, userId),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt64,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[GuStudentArchivesPb class]
                                     rootClass:[MebabyGrowthRoot class]
                                          file:MebabyGrowthRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(GuStudentArchivesPb__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\023\002\t\000\003\007\000\005\007\000\014\n\000\r\013\000\016\t\000\021\013\000\022\r\000\023\010\000\024\n\000\025\014\000\026\016\000\027\n\000"
        "\030\014\000\031\016\000\032\017\000\033\013\000\034\007\000\035\006\000";
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
