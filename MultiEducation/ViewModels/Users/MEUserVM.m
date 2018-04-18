//
//  MEUserVM.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/5.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEUserVM.h"
#import <sys/utsname.h>

@interface MEUserVM ()

@property (nonatomic, strong, readwrite) MEPBUser *usr;

@property (nonatomic, strong) MEPBSignIn *siginPb;

@end

static NSString * userPath = @"user/signin";
static NSString * userFile = @"signedin.bat";

@implementation MEUserVM

#pragma mark --- Override

- (NSString *)cmdVersion {
    return @"2";
}

- (NSString *)cmdCode {
    return SESSION_POST;
}

#pragma mark --- Class Methods for instance

+ (instancetype)vmWithModel:(MEPBUser *)usr {
    NSAssert(usr != nil, @" could not initialized by nil!");
    return [[self alloc] initWithUsr:usr];
}

- (id)initWithUsr:(MEPBUser *)usr {
    self = [super init];
    if (self) {
        _usr = usr;
    }
    return self;
}

+ (instancetype)vmWithPB:(MEPBSignIn *)pb {
    NSAssert(pb != nil, @" could not initialized by nil!");
    return [[self alloc] initWithPB:pb];
}

- (id)initWithPB:(MEPBSignIn *)pb {
    self = [super init];
    if (self) {
        _siginPb = pb;
    }
    return self;
}

+ (BOOL)saveUser:(MEPBUser *)user {
    NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
    user.signinstamp = timestamp;
    return [WHCSqlite insert:user];
    
    /*
    NSString *rootPath = [MEKits sandboxPath];
    NSString *dir = [rootPath stringByAppendingPathComponent:userPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dir]) {
        [fileManager createDirectoryAtPath:dir withIntermediateDirectories:true attributes:nil error:nil];
    }
    NSString *filePath = [dir stringByAppendingPathComponent:userFile];
    if ([fileManager fileExistsAtPath:filePath]) {
        [fileManager removeItemAtPath:filePath error:nil];
    }
    
    NSData *userData = [user data];
    return [userData writeToFile:filePath atomically:true];
    //*/
}

+ (MEPBUser * _Nullable)fetchLatestSignedInUser {
    //*TODO:处理已登录用户相关逻辑
    NSArray <MEPBUser*> *usrs = [WHCSqlite query:[MEPBUser class] order:@"by signinstamp desc" limit:@"1"];
    if (usrs.count > 0) {
        return [usrs lastObject];
    }
    return nil;//*/
    
    /*
    NSString *rootPath = [MEKits sandboxPath];
    NSString *dir = [rootPath stringByAppendingPathComponent:userPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [dir stringByAppendingPathComponent:userFile];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSData *userData = [NSData dataWithContentsOfFile:filePath];
        NSError *error;
        MEPBUser *user = [MEPBUser parseFromData:userData error:&error];
        if (!error) {
            return user;
        }
    }
    return nil;
    //*/
}

+ (MEPBPhoneInfo *)getDeviceInfo {
    
    NSDictionary *dicInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *deviceId = [[UIDevice currentDevice].identifierForVendor UUIDString];
    NSString *subscruberId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *model =  [NSString stringWithCString:systemInfo.machine
                                          encoding:NSUTF8StringEncoding];
    NSString *appVersion = [dicInfo objectForKey:@"CFBundleShortVersionString"];
    NSString *osVersion = [[UIDevice currentDevice] systemVersion];
    MEPBPhoneInfo *info = [[MEPBPhoneInfo alloc] init];
    [info setDeviceId:deviceId];
    [info setSubscriberId:subscruberId];
    [info setModel:model];
    [info setAppVersion:appVersion];
    [info setOsVersion:osVersion];
    [info setBrand:@"iPhone"];
    return info;
}

#pragma mark --- setter & getter

- (MEUserRole)userRole {
    return self.usr.userType;
}

@end
