//
//  MEUserVM.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/5.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEUserVM.h"
#import "AppDelegate.h"

@interface MEUserVM ()

@property (nonatomic, strong, readwrite) MEPBUser *usr;

@property (nonatomic, strong) MEPBSignIn *siginPb;

@end

static NSString * userPath = @"user/signin";
static NSString * userFile = @"signedin.bat";

@implementation MEUserVM

#pragma mark --- Override

- (NSString *)cmdVersion {
    return @"3";
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
    if (user) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setBool:false forKey:ME_USER_DID_INITIATIVE_LOGOUT];
    }
    if (user.signinstamp == 0) {
        user.signinstamp = [MEKits currentTimeInterval];
    }
    //查询数据库有没有已存在
    NSString *sql = PBFormat(@"uid = %lld AND uuid = '%@'", user.uid, user.uuid);
    NSArray <MEPBUser*> *existSet = [WHCSqlite query:MEPBUser.self where:sql];
    if (existSet.count > 0) {
        [WHCSqlite delete:MEPBUser.self where:sql];
    }
    
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
    //NSArray <MEPBUser*> *signedinUsers = [WHCSqlite query:[MEPBUser class]];
    //NSLog(@"当前已经有 %zd 位登录用户！", signedinUsers.count);
    NSArray <MEPBUser*> *usrs = [WHCSqlite query:[MEPBUser class] order:@"by signinstamp desc" limit:@"1"];
    if (usrs.count > 0) {
        return [usrs firstObject];
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

+ (BOOL)updateUserGender:(int32_t)gender uid:(int64_t)uid {
    NSString *sql = PBFormat(@"gender = %d", gender);
    NSString *where = PBFormat(@"uid = %lld", uid);
    return [WHCSqlite update:[MEPBUser class] value:sql where:where];
}

+ (BOOL)updateUserAvatar:(NSString *)avatar uid:(int64_t)uid {
    NSString *sql = PBFormat(@"portrait = '%@'", avatar);
    NSString *where = PBFormat(@"uid = %lld", uid);
    return [WHCSqlite update:[MEPBUser class] value:sql where:where];
}

+ (BOOL)updateUserNick:(NSString *)nick uid:(int64_t)uid {
    NSString *sql = PBFormat(@"name = '%@'", nick);
    NSString *where = PBFormat(@"uid = %lld", uid);
    return [WHCSqlite update:[MEPBUser class] value:sql where:where];
}

+ (BOOL)updateUserStuent:(StudentPb *)stu cls:(MEPBClass *)cls uid:(int64_t)uid {
    MEPBUser *user = [self fetchLatestSignedInUser];
    if (user.userType != MEPBUserRole_Parent) {
        return false;
    }
    
    ParentsPb *parentsPb;
    if (!user.parentsPb) {
        parentsPb = [[ParentsPb alloc] init];
        parentsPb.mobile = user.mobile;
    } else {
        parentsPb = user.parentsPb;
    }
    
    if (![parentsPb.studentPbArray containsObject: stu]) {
        [parentsPb.studentPbArray addObject: stu];
    }
    
    if (![parentsPb.classPbArray containsObject: cls]) {
        [parentsPb.classPbArray addObject: cls];
    }
    
    user.parentsPb = parentsPb;
    NSString *where = PBFormat(@"uid = %lld", uid);
    BOOL result = [WHCSqlite update: user where: where];
    if (result) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate updateCurrentSignedInUser: user];
    }
    return result;
}

#pragma mark --- setter & getter

@end
