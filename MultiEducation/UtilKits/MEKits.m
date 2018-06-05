//
//  MEKits.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/5.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEKits.h"
#import "ValueEnv.h"
#import <sys/stat.h>
#import "MEUserVM.h"
#import "MECordovaVM.h"
#import "AppDelegate.h"
#import <Toast/Toast.h>
#import "Meuser.pbobjc.h"
#import "NSData+NSHash.h"
#import "Meclass.pbobjc.h"
#import "MEClassChatVM.h"
#import "MEClassMemberVM.h"
#import <PBService/PBService.h>
#import <SSZipArchive/SSZipArchive.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <AFNetworking/AFHTTPSessionManager.h>

@implementation MEKits

+ (NSUInteger)statusBarHeight {
    if ([UIDevice pb_isX]) {
        return ME_HEIGHT_NAVIGATIONBAR;
    }
    return ME_LAYOUT_BOUNDARY;
}

+ (NSString *)createUUID {
    CFUUIDRef udid = CFUUIDCreate(NULL);
    NSString *udidString = (NSString *) CFBridgingRelease(CFUUIDCreateString(NULL, udid));
    return udidString;
}

+ (NSTimeInterval)currentTimeInterval {
    return [[NSDate date] timeIntervalSince1970];
}

+ (NSString *)sandboxPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
    NSString *documentPath = paths.firstObject;
    return documentPath;
}

+ (NSString *)currentUserDownloadPath {
    NSString *documentPath = [self sandboxPath];
    NSString *userDownloadRoot = [documentPath stringByAppendingPathComponent:self.app.curUser.uuid];
    NSFileManager *fileHandler = [NSFileManager defaultManager];
    NSError *err;
    if (![fileHandler fileExistsAtPath:userDownloadRoot]) {
        [fileHandler createDirectoryAtPath:userDownloadRoot withIntermediateDirectories:true attributes:nil error:&err];
        if (err) {
            NSLog(@"创建用户下载目录失败!------%@", err.description);
            return nil;
        }
    }
    return userDownloadRoot;
}

+ (CGFloat)fileSizeWithPath:(NSString *)path {
    NSAssert(path.length != 0, @"empty file path");
    const char *filename = path.UTF8String;
    struct stat st;
    memset(&st, 0, sizeof(st));
    stat(filename, &st);
    return st.st_size;
}

+ (AppDelegate *)app {
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    return app;
}

+ (NSString *)imageFullPath:(NSString *)absPath {
    if (self.app.curUser) {
        return PBFormat(@"%@/%@", self.app.curUser.bucketDomain, absPath);
    }
    //
    return nil;
}

+ (NSString *)mediaFullPath:(NSString *)absPath {
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (app.curUser) {
        return PBFormat(@"%@/%@", app.curUser.bucketDomain, absPath);
    }
    //
    return nil;
}

+ (NSString *)shareResourceUri:(ino64_t)resId type:(int32_t)type {
    return PBFormat(@"%@/%d/%lld", ME_WEB_SERVER_HOST, type, resId);
}

+ (BOOL)isNineKeyBoard:(NSString*)string {
    NSString *other =@"➋➌➍➎➏➐➑➒";
    int len = (int)string.length;
    for(int i = 0; i < len; i++) {
        if(!([other rangeOfString:string].location != NSNotFound))
            return NO;
    }
    return YES;
}

+ (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

//获取字符串首字母(传入汉字字符串, 返回大写拼音首字母)
+ (NSString *)getFirstLetterFromString:(NSString *)aString {
    NSMutableString *str = [NSMutableString stringWithString:aString];
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    NSString *strPinYin = [str capitalizedString];
    return [strPinYin substringToIndex:1];
}

+ (NSString *)timeStamp2DateStringWithFormatter:(NSString *)formatter timeStamp:(int64_t)timeStamp {
    if ([formatter isEqualToString: @""] || formatter == nil) {
        formatter = @"yyyy-MM-dd HH:mm:ss";
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970: timeStamp / 1000];
    NSDateFormatter *dateformatter= [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat: formatter];
    NSString *dateStr=[dateformatter stringFromDate: date];
    return dateStr;
}

+ (int64_t)DateString2TimeStampWithFormatter:(NSString *)formatter dateStr:(NSString *)dateStr {
    if ([formatter isEqualToString: @""] || formatter == nil) {
        return 0;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = formatter;
    NSDate *date = [dateFormatter dateFromString: dateStr];
    return (int64_t)([date timeIntervalSince1970] * 1000);
}

#pragma mark --- User Abouts

/**
 当前用户所关联的所有班级
 */
+ (NSArray<MEPBClass*>*)fetchCurrentUserMultiClasses {
    __block NSMutableArray<MEPBClass*> *classes = [NSMutableArray arrayWithCapacity:0];
    MEPBUser *curUser = self.app.curUser;
    if (curUser.userType == MEPBUserRole_Teacher) {
        //老师
        TeacherPb *teacher = curUser.teacherPb;
        [classes addObjectsFromArray:teacher.classPbArray.copy];
    } else if (curUser.userType == MEPBUserRole_Parent) {
        //家长
        ParentsPb *parent = curUser.parentsPb;
        [classes addObjectsFromArray:parent.classPbArray.copy];
    } else if (curUser.userType == MEPBUserRole_Gardener) {
        //园务
        DeanPb *dean = curUser.deanPb;
        [classes addObjectsFromArray:dean.classPbArray.copy];
    }
    return classes.copy;
}

+ (BOOL)whetherCurrentUserHaveMulticastClasses {
    NSArray<MEPBClass*>*classes = [self fetchCurrentUserMultiClasses];
    return classes.count > 1;
}

+ (NSString * _Nullable)fetchCurrentUserSessionToken {
    return self.app.curUser.sessionToken;
}

#pragma mark --- Cordova Resources && Hot Updating---
/**
 *  Cordova策略：
 *  1,启动app先解压bundle资源文件
 *  2,登录后Wi-Fi环境下在去更新资源包
 **/

/**
 准备Cordova环境变量
 */
+ (void)configureCordovaEnv {
    PBMAIN(^{
        [ValueEnv setKey:@"env" value:ME_APP_ENV];
        [ValueEnv setKey:@"webServer" value:ME_CORDOVA_SERVER_HOST];
        NSString *sessionToken = self.app.curUser.sessionToken;
        [ValueEnv setKey:@"sessionToken" value:sessionToken];
        NSLog(@"configure Cordova Env done.");
    });
}
/**
 Cordova bundle 路径
 */
+ (NSString *)cordovaBundlePath {
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"www" ofType:@"zip"];
    NSAssert(bundlePath.length != 0, @"budnle 无法找到Cordova资源包！");
    return bundlePath.copy;
}

/**
 Cordova 资源包路径
 */
+ (NSString *)cordovaOriginResourcePath {
    NSString *sandBoxPath = [self sandboxPath];
    NSString *cdvPath = [sandBoxPath stringByAppendingPathComponent:@"www.zip"];
    return cdvPath;
}

/**
 Cordova 运行路径
 */
+ (NSString *)cordovaWebRootPath {
    NSString *sandBoxPath = [self sandboxPath];
    NSString *cdvPath = [sandBoxPath stringByAppendingPathComponent:@"www"];
    return cdvPath;
}

/**
 解压准备Cordova资源包
 */
+ (BOOL)UnzipCordovaResources {
    NSString *cdvRunPath = [self cordovaWebRootPath];
    BOOL dir = true;NSFileManager *fileHandler = [NSFileManager defaultManager];
    if ([fileHandler fileExistsAtPath:cdvRunPath isDirectory:&dir]) {
        NSLog(@"已经解压过，无需再解压资源包！");
        return true;
    }
    NSString *cdvResourcePath = [self cordovaOriginResourcePath];
    if (![fileHandler fileExistsAtPath:cdvResourcePath]) {
        NSLog(@"Cordova 资源包未copy到沙盒，正在copy...");
        NSString *bundlePath = [self cordovaBundlePath];
        NSError *err;
        [fileHandler copyItemAtPath:bundlePath toPath:cdvResourcePath error:&err];
        if (err) {
            NSLog(@"copy Cordova资源包出错：%@", err.description);
            return false;
        }
    }
    //解压资源包
    NSString *documentsPath = [self sandboxPath];
    BOOL ret = [SSZipArchive unzipFileAtPath:cdvResourcePath toDestination:documentsPath];
    if (!ret) {
        NSLog(@"解压文件出错");
        return false;
    }
    NSLog(@"解压Cordova资源包完成！");
    return true;
}

/**
 获取当前Cordova资源包版本
 */
+ (int)fetchCurrentCordovaResourceVersion {
    NSString *cdvRunPath = [self cordovaWebRootPath];
    BOOL dir = true;NSFileManager *fileHandler = [NSFileManager defaultManager];
    if (![fileHandler fileExistsAtPath:cdvRunPath isDirectory:&dir]) {
        NSLog(@"未找到Cordova资源包！");
        return -1;
    }
    NSString *versionPath = [cdvRunPath stringByAppendingPathComponent:@"version.json"];
    NSURL *versionUri = [NSURL fileURLWithPath:versionPath];
    NSError *error;
    NSData *versionData = [NSData dataWithContentsOfURL:versionUri options:NSDataReadingMappedAlways|NSMappedRead error:&error];
    if (error) {
        NSLog(@"读取磁盘文件出错：%@", error.description);
    }
    NSError *err;
    NSDictionary *versionMap = [NSJSONSerialization JSONObjectWithData:versionData options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments error:&err];
    if (err || !versionMap) {
        NSLog(@"version json 解析出错！");
        return -1;
    }
    NSNumber *version = [versionMap objectForKey:@"version"];
    return version.intValue;
}

/**
 更新Cordova资源包
 */
+ (void)updateCordovaResourcePacket {
    int curVersion = [self fetchCurrentCordovaResourceVersion];
    if (curVersion <= 0) {
        NSLog(@"无效的版本号！");
    }
    NSLog(@"当前Cordova资源包版本:%d", curVersion);
    if ([SBNetState isViaWifi]) {
        NSLog(@"当前非Wi-Fi环境，不更新资源包！");
        return;
    }
    weakify(self)
    MECordovaVM *vm = [[MECordovaVM alloc] init];
    [vm postData:[NSData data] hudEnable:false success:^(NSData * _Nullable resObj) {
        NSError *err;strongify(self)
        MEPBCordova *cdv = [MEPBCordova parseFromData:resObj error:&err];
        if (err) {
            NSLog(@"解析Cordova版本信息失败:%@", err.description);
        } else {
            //判断线上版本信息
            if (cdv.version > curVersion && cdv.iosKey.length > 0) {
                [self loadCordovaNewestResource4Info:cdv];
            } else {
                NSLog(@"当前Cordova资源为最新资源，无需更新！");
            }
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"获取Cordova版本信息失败:%@", error.description);
    }];
}

+ (NSURL *)assmbleCordovaResourceUrlWithKey:(NSString *)key andBucketDomain:(NSString *)domain {
    if (domain.length == 0) {
        domain = self.app.curUser.bucketDomain;
    }
    NSString *urlString = PBFormat(@"%@/%@", domain, key);
    return [NSURL URLWithString:urlString];
}

/**
 下载Cordova最新资源包
 */
+ (void)loadCordovaNewestResource4Info:(MEPBCordova *)cdv {
    if (cdv) {
        NSURL *url = [self assmbleCordovaResourceUrlWithKey:cdv.iosKey andBucketDomain:cdv.bucketDomain];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSString *fullPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[url lastPathComponent]];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        weakify(self)
        NSURLSessionDownloadTask *dataTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            //下载进度
            NSLog(@"cordova 资源下载进度:%f", downloadProgress.completedUnitCount / (downloadProgress.totalUnitCount / 1.0));
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            return [NSURL fileURLWithPath:fullPath];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            strongify(self)
            NSLog(@"codova资源下载完成：%@----%@",response.textEncodingName, filePath);
            //处理替换原有路径
            [self replaceCordovaNewestResource4FilePath:filePath];
        }];
        [dataTask resume];
    }
}

/**
 替换Cordova最新资源路径
 */
+ (void)replaceCordovaNewestResource4FilePath:(NSURL *)path {
    if (path) {
        NSFileManager *fileHandler = [NSFileManager defaultManager];
        //查询旧资源
        NSError *err = nil;
        NSString *cdvResourcePath = [self cordovaOriginResourcePath];
        if ([fileHandler fileExistsAtPath:cdvResourcePath]) {
            NSLog(@"Cordova 旧资源包存在，正在移除...");
            [fileHandler removeItemAtPath:cdvResourcePath error:&err];
            if (err) {
                NSLog(@"delete old Cordova资源包出错：%@", err.description);
            }
        }
        //写入新的资源包
        err = nil;
        NSString *resNewPath = path.absoluteString;
        [fileHandler copyItemAtPath:resNewPath toPath:cdvResourcePath error:&err];
        if (err) {
            NSLog(@"移动资源出错:%@", err.description);
        }
        //解压新资源包
        NSString *cdvRunPath = [self sandboxPath];
        BOOL ret = [SSZipArchive unzipFileAtPath:cdvResourcePath toDestination:cdvRunPath];
        if (!ret) {
            NSLog(@"解压Cordova新资源包文件出错!");
        }
    }
}

#pragma mark --- UINavigationBar items

+ (UIBarButtonItem *)barSpacer {
    UIBarButtonItem *barSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    barSpacer.width = - ME_LAYOUT_MARGIN;
    return barSpacer;
}

+ (UIBarButtonItem *)defaultGoBackBarButtonItemWithTarget:(id _Nullable)target {
    return [self defaultGoBackBarButtonItemWithTarget:target color:[UIColor whiteColor]];
}

+ (UIBarButtonItem *)defaultGoBackBarButtonItemWithTarget:(id _Nullable)target action:(SEL _Nullable)selector {
    return [self barWithUnicode:@"\U0000e6e2" color:[UIColor whiteColor] target:target action:selector];
}

+ (UIBarButtonItem *)defaultGoBackBarButtonItemWithTarget:(id _Nullable)target color:(UIColor *_Nullable)color {
    return [self barWithUnicode:@"\U0000e6e2" color:color target:nil action:NSSelectorFromString(@"defaultGoBackStack")];
}

+ (UIBarButtonItem *)barWithUnicode:(NSString *)iconCode color:(UIColor * _Nullable)color target:(nullable id)target action:(nullable SEL)selector {
    return [self barWithUnicode:iconCode title:nil color:color target:target action:selector];
}

+ (UIBarButtonItem *)barWithUnicode:(NSString *)iconCode title:(NSString*_Nullable)title color:(UIColor * _Nullable)color target:(nullable id)target action:(nullable SEL)selector {
    CGFloat itemSize = 28;
    CGFloat fontSize = METHEME_FONT_TITLE * 1.5;
    NSString *fontName = @"iconfont";
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    title = PBAvailableString(title);
    title = PBFormat(@"%@ %@", iconCode, title);
    CGSize titleSize = [title pb_sizeThatFitsWithFont:font width:PBSCREEN_WIDTH];
    UIColor *fontColor = (color == nil)?[UIColor whiteColor]:color;
    CGFloat spacing = 2.f; // the amount of spacing to appear between image and title
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //btn.backgroundColor = [UIColor pb_randomColor];
    btn.frame = CGRectMake(0, 0, titleSize.width + spacing, itemSize);
    btn.exclusiveTouch = true;
    btn.titleLabel.font = font;
    //    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
    //    btn.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
    [btn setTitle:iconCode forState:UIControlStateNormal];
    [btn setTitleColor:fontColor forState:UIControlStateNormal];
    //[btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [barItem setTintColor:fontColor];
    return barItem;
}

+ (UIBarButtonItem *)barWithTitle:(NSString *)title color:(UIColor * _Nullable)color target:(nullable id)target action:(nullable SEL)selector  {
    CGFloat itemSize = 28;
    CGFloat fontSize = METHEME_FONT_TITLE;
    UIFont *font = UIFontPingFangSC(fontSize);
    CGFloat itemWidth = [title pb_sizeThatFitsWithFont:font width:MESCREEN_WIDTH].width;
    UIColor *fontColor = (color == nil)?[UIColor whiteColor]:color;
    CGFloat spacing = 2.f; // the amount of spacing to appear between image and title
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //btn.backgroundColor = [UIColor pb_randomColor];
    btn.frame = CGRectMake(0, 0, MAX(itemWidth, itemSize) + spacing, itemSize);
    btn.exclusiveTouch = true;
    btn.titleLabel.font = font;
    //    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
    //    btn.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:fontColor forState:UIControlStateNormal];
    //[btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [barItem setTintColor:fontColor];
    return barItem;
}

+ (UIBarButtonItem *)barWithImage:(UIImage *)image target:(id)target eventSelector:(SEL)selector {
    CGFloat itemSize = 28;
//    CGFloat fontSize = METHEME_FONT_TITLE;
//    UIFont *font = UIFontPingFangSC(fontSize);
//    CGFloat itemWidth = [title pb_sizeThatFitsWithFont:font width:MESCREEN_WIDTH].width;
//    UIColor *fontColor = (color == nil)?[UIColor whiteColor]:color;
//    CGFloat spacing = 2.f; // the amount of spacing to appear between image and title
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //btn.backgroundColor = [UIColor pb_randomColor];
    btn.frame = CGRectMake(0, 0, itemSize, itemSize);
    btn.exclusiveTouch = true;
//    btn.titleLabel.font = font;
    //    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
    //    btn.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
//    [btn setTitle:title forState:UIControlStateNormal];
//    [btn setTitleColor:fontColor forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
//    [barItem setTintColor:fontColor];
    return barItem;
}

#pragma mark --- handle hud

+ (void)handleError:(NSError *)err {
    if (err) {
        if (err.code >= 401 && err.code < 500) {
            //用户未鉴权
            [self.app passiveLogout:@"当前授权已过期，请重新登录！"];
            return;
        }
        NSDictionary *userInfo = [err userInfo];
        NSString *alertInfo = err.domain;
        if (userInfo && alertInfo.length == 0) {
            alertInfo = [userInfo pb_stringForKey:NSLocalizedDescriptionKey];
        }
        if ([alertInfo isEqualToString:@"NSURLErrorDomain"]) {
            alertInfo = @"当前网络不可用，请检查网络！";
        }
        [SVProgressHUD showErrorWithStatus:alertInfo];
    }
}

+ (void)handleSuccess:(NSString *)hud {
    if (hud) {
        [SVProgressHUD showSuccessWithStatus:hud];
    }
}

+ (void)makeToast:(NSString *)info {
    if (info.length > 0) {
        NSValue *position = [NSValue valueWithCGPoint:CGPointMake(MESCREEN_WIDTH*0.5, MESCREEN_HEIGHT*ME_TOAST_BOTTOM_SCALE)];
        [self.app.rootView makeToast:info duration:1 position:position style:nil];
    }
}

+ (void)makeTopToast:(NSString *)info {
    if (info.length > 0) {
        NSValue *position = [NSValue valueWithCGPoint:CGPointMake(MESCREEN_WIDTH*0.5, MESCREEN_HEIGHT*(1-ME_TOAST_BOTTOM_SCALE))];
        [self.app.rootView makeToast:info duration:1 position:position style:nil];
    }
}

#pragma mark --- User Token Refresh

/**
 app再次进入前台 超过时间间隔需要刷新token 如七牛上传token
 */
+ (void)refreshCurrentUserSessionTokenWithCompletion:(void (^)(NSError * _Nullable))completion {
    if (self.app.curUser) {
        MEPBUser *user = self.app.curUser;
        NSTimeInterval signedTimestamp = self.app.curUser.signinstamp;
        NSTimeInterval currentTimestamp = [self currentTimeInterval];
        if (fabs(signedTimestamp - currentTimestamp) >= ME_USER_SESSION_TOKEN_REFRESH_INTERVAL) {
            //需要刷新token
            NSLog(@"正在刷新用户session-token...");
            //goto signin
            MEPBSignIn *pb = [[MEPBSignIn alloc] init];
            [pb setLoginName:user.username];
            //apns token
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *token = [defaults stringForKey:ME_APPLICATION_APNE_TOKEN];
            [pb setAppleToken:token];
            //device info
            MEPBPhoneInfo *info = [MEUserVM getDeviceInfo];
            pb.phoneInfo = info;
            
            MEUserVM *vm = [MEUserVM vmWithPB:pb];
            vm.sessionToken = user.sessionToken;
            NSData *pbdata = [pb data];
            weakify(self)
            [vm postData:pbdata hudEnable:false success:^(NSData * _Nullable resObj) {
                NSError *err;strongify(self)
                MEPBUserList *userList = [MEPBUserList parseFromData:resObj error:&err];
                if (err || userList.userListArray.count == 0) {
                    [self handleError:err];
                    if (completion) {
                        completion(err);
                    }
                    NSLog(@"刷新用户session-token失败！----%@", err.localizedDescription);
                } else {
                    MEPBUser *curUser = userList.userListArray.firstObject;
                    user.signinstamp = [self currentTimeInterval];
                    [MEUserVM saveUser:curUser];
                    [self.app updateCurrentSignedInUser:curUser];
                    NSLog(@"刷新用户session-token成功！");
                    if (completion) {
                        completion(nil);
                    }
                }
            } failure:^(NSError * _Nonnull error) {
                strongify(self)
                [self handleError:error];
                if (completion) {
                    completion(error);
                }
            }];
        } else {
            NSLog(@"无需刷新用户session-token");
            if (completion) {
                completion(nil);
            }
        }
    } else {
        if (completion) {
            completion(nil);
        }
    }
}

#pragma mark --- 获取当前登录用户的所有班级用户

+ (void)fetchContacts4CurrentUser {
    MEPBUser *user = self.app.curUser;
    if (!user) {
        return;
    }
    NSArray<MEPBClass*>*cls = [self fetchCurrentUserMultiClasses];
    for (MEPBClass *c in cls) {
        //section1:刷新班级成员
        int64_t cls_id = c.id_p;
        int64_t timestamp = [MEClassMemberVM fetchMaxTimestamp4ClassID:cls_id];
        MEClassMemberVM *vm = [[MEClassMemberVM alloc] init];
        MEClassMemberList *list = [[MEClassMemberList alloc] init];
        [list setTimestamp:timestamp];
        [list setClassIds:PBFormat(@"%lld", cls_id)];
        //weakify(self)
        [vm postData:[list data] hudEnable:false success:^(NSData * _Nullable resObj) {
            NSError *err;//strongify(self)
            MEClassMemberList *memberList = [MEClassMemberList parseFromData:resObj error:&err];
            //NSLog(@"timestamp:%lld", memberList.timestamp);
            if (err) {
                [MEKits handleError:err];
            } else {
                NSArray<MEClassMember*>*members = memberList.classUserArray.copy;
                [MEClassMemberVM saveClassMembers:members];
                NSLog(@"获取到%lu个联系人!", (unsigned long)members.count);
            }
        } failure:^(NSError * _Nonnull error) {
            [MEKits handleError:error];
        }];
        //secton2:刷新班聊session
        timestamp = [MEClassChatVM fetchMaxClassSessionTimestamp4ClassID:cls_id];
        //发起班聊
        MEClassChatVM *svm = [[MEClassChatVM alloc] init];
        MECSession *cSession = [[MECSession alloc] init];
        cSession.timestamp = timestamp;
        cSession.classId = cls_id;
        //weakify(self)
        [svm postData:[cSession data] hudEnable:false success:^(NSData * _Nullable resObj) {
            NSError *err; //strongify(self)
            MESessionList *sessionList = [MESessionList parseFromData:resObj error:&err];
            if (err) {
                [MEKits handleError:err];
            } else {
                [MEClassChatVM saveClassChatSessions:sessionList.classSessionArray.copy];
            }
        } failure:^(NSError * _Nonnull error) {
            [MEKits handleError:error];
        }];
    }
}

#pragma mark --- Max Upload Size
#define MAX_FILE_UPLOAD 10 //10M
+ (float)uploadMaxLimit {
    float uploadLimit = self.app.curUser.systemConfigPb.uploadLimit.floatValue;
    uploadLimit = uploadLimit * 1024 * 1024;
    if (uploadLimit < MAX_FILE_UPLOAD * 1024 * 1024) {
        return MAX_FILE_UPLOAD;
    } else {
        return uploadLimit;
    }
}

+ (NSString *)formatFileSize:(id)value {
    double convertedValue = [value doubleValue];
    int multiplyFactor = 0;
    NSArray *tokens = [NSArray arrayWithObjects:@"bytes", @"KB", @"MB", @"GB", @"TB", nil];
    while (convertedValue > 1024) {
        convertedValue /= 1024;
        multiplyFactor++;
    }
    return [NSString stringWithFormat:@"%4.2f %@", convertedValue, [tokens objectAtIndex:multiplyFactor]];
}

+ (NSString *)checkUserDiskCap:(SInt64)fileSize {
    float curDickCap = self.app.curUser.diskCap;
    float totalDiskCap = [self app].curUser.systemConfigPb.diskCap.floatValue * 1024 * 1024 * 1024;
    if (curDickCap + fileSize > totalDiskCap) {
        return [NSString stringWithFormat:@"网盘容量不够,您只剩下%@容量,当前文件大小%@",
                [self formatFileSize:@(totalDiskCap - curDickCap)],
                [self formatFileSize:@(fileSize)]];
    } else {
        return nil;
    }
}

+ (void)handleUploadPhotos:(NSArray *)photos assets:(NSArray *)assets checkDiskCap:(BOOL)checkCap completion:(void (^)(NSArray <NSDictionary*>* _Nullable))completion {
    NSMutableArray *destAssets = [NSMutableArray array];
    NSFileManager *fileHandler = [NSFileManager defaultManager];
    NSString *userPrePath = [self currentUserDownloadPath];
    for (int i = 0; i < photos.count; ++i) {
        UIImage *photo = photos[i];
        NSObject *asset = nil;
        if (assets.count >= (i + 1)) {
            asset = assets[i];
        }
        
        NSMutableDictionary *infoMap = [NSMutableDictionary dictionary];
        //后缀名
        NSString *extension = @"jpg";
        infoMap[@"extension"] = extension;
        //md5和filePath
        NSData *data;
        if (asset == nil) {
            data = UIImageJPEGRepresentation(photo, 0.3);
        } else {
            data = UIImageJPEGRepresentation(photo, 1);
        }
        NSString *md5 = [data MD5String];
        NSString *filePath = [NSString stringWithFormat:@"%@.%@", md5, extension];
        infoMap[@"md5"] = md5;
        infoMap[@"filePath"] = filePath;
        infoMap[@"fileName"] = filePath;
        infoMap[@"data"] = data;
        infoMap[@"fileSize"] = [NSNumber numberWithFloat: data.length / 1024.f / 1024.f];
        
        //检查文件大小
        float size = (float) data.length / 1024.0f / 1024.0f;
        float uploadLimit = [MEKits uploadMaxLimit];
        if (size > uploadLimit) {
            NSString *alertString = [NSString stringWithFormat:@"上传文件最大只能%fM", uploadLimit];
            [SVProgressHUD showInfoWithStatus:alertString];
            return;
        }
        if (checkCap) {
            NSString *msg = [self checkUserDiskCap:data.length];
            if (msg != nil) {
                [SVProgressHUD showInfoWithStatus:msg];
                return;
            }
        }
        //写入文件 如果已经有了就不再写入
        if (![fileHandler fileExistsAtPath:filePath]) {
            NSLog(@"file:%@已经存在，不用写入!", filePath);
            NSString *absolutePath = [userPrePath stringByAppendingPathComponent:filePath];
            [data writeToFile:absolutePath atomically:true];
        }
        
        NSLog(@"File size is : %.2f MB----file:%@", (float) data.length / 1024.0f / 1024.0f, filePath);
        [destAssets addObject:infoMap.copy];
    }
    if (completion) {
        completion(destAssets.copy);
    }
}

+ (void)handleUploadVideos:(NSArray <NSData *> *)videos checkDiskCap:(BOOL)checkCap completion:(void (^)(NSArray <NSDictionary*>* _Nullable))completion {
    NSMutableArray *destAssets = [NSMutableArray array];
    NSFileManager *fileHandler = [NSFileManager defaultManager];
    NSString *userPrePath = [self currentUserDownloadPath];
    for (int i = 0; i < videos.count; ++i) {
        NSData *video = videos[i];
        
        NSMutableDictionary *infoMap = [NSMutableDictionary dictionary];
        //后缀名
        NSString *extension = @"mp4";
        infoMap[@"extension"] = extension;
        //md5和filePath
        NSString *md5 = [video MD5String];
        NSString *filePath = [NSString stringWithFormat:@"%@.%@", md5, extension];
        infoMap[@"md5"] = md5;
        infoMap[@"filePath"] = filePath;
        infoMap[@"fileName"] = filePath;
        infoMap[@"data"] = video;
        infoMap[@"fileSize"] = [NSNumber numberWithFloat: video.length / 1024.f / 1024.f];

        //检查文件大小
        float size = (float) video.length / 1024.0f / 1024.0f;
        float uploadLimit = [MEKits uploadMaxLimit];
        if (size > uploadLimit) {
            NSString *alertString = [NSString stringWithFormat:@"上传文件最大只能%fM", uploadLimit];
            [SVProgressHUD showInfoWithStatus:alertString];
            return;
        }
        if (checkCap) {
            NSString *msg = [self checkUserDiskCap: video.length];
            if (msg != nil) {
                [SVProgressHUD showInfoWithStatus:msg];
                return;
            }
        }
        //写入文件 如果已经有了就不再写入
        if (![fileHandler fileExistsAtPath:filePath]) {
            NSString *absolutePath = [userPrePath stringByAppendingPathComponent:filePath];
            [video writeToFile:absolutePath atomically:true];
        }
        
        NSLog(@"File size is : %.2f MB", (float) video.length / 1024.0f / 1024.0f);
        [destAssets addObject:infoMap.copy];
    }
    if (completion) {
        completion(destAssets.copy);
    }
}

#pragma mark --- 处理图片相关

+ (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength {
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 8; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.7) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return resultImage;
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    
    return resultImage;
}

@end
