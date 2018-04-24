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
#import "MECordovaVM.h"
#import "AppDelegate.h"
#import "Meuser.pbobjc.h"
#import "NSData+NSHash.h"
#import <PBService/PBService.h>
#import <SSZipArchive/SSZipArchive.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <AFNetworking/AFHTTPSessionManager.h>

@implementation MEKits

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
    return PBFormat(@"%@/?type=%d&resId=%lld", ME_WEB_SERVER_HOST, type, resId);
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
    [ValueEnv setKey:@"env" value:ME_APP_ENV];
    [ValueEnv setKey:@"webServer" value:ME_DEFAULT_HTTP_SERVER_URL];
    NSString *sessionToken = self.app.curUser.sessionToken;
    [ValueEnv setKey:@"sessionToken" value:sessionToken];
    NSLog(@"configure Cordova Env done.");
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
    if ([PBService shared].netState & (PBNetStateUnavaliable|PBNetStateViaWWAN)) {
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
    barSpacer.width = - ME_LAYOUT_MARGIN*2;
    return barSpacer;
}

+ (UIBarButtonItem *)backBarWithColor:(UIColor *)color target:(id)target withSelector:(SEL)selector{
    return [self barWithIconUnicode:@"\U0000e6e2" color:color withTarget:target withSelector:selector];
}

+ (UIBarButtonItem *)barWithIconUnicode:(NSString *)iconCode color:(UIColor *)color target:(id)target eventSelector:(nullable SEL)selector {
    return [self barWithIconUnicode:iconCode color:color withTarget:target withSelector:selector];
}

+ (UIBarButtonItem *)barWithIconUnicode:(NSString *)iconCode color:(UIColor *)color withTarget:(nullable id)target withSelector:(nullable SEL)selector {
    CGFloat itemSize = 28;
    CGFloat fontSize = METHEME_FONT_TITLE;
    NSString *fontName = @"iconfont";
    UIFont *font = [UIFont fontWithName:fontName size:fontSize * 2];
    UIColor *fontColor = (color == nil)?[UIColor whiteColor]:color;
    //    CGFloat spacing = 2.f; // the amount of spacing to appear between image and title
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //btn.backgroundColor = [UIColor pb_randomColor];
    btn.frame = CGRectMake(0, 0, itemSize, itemSize);
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

+ (UIBarButtonItem *)barWithTitle:(NSString *)title color:(UIColor *)color target:(id)target eventSelector:(SEL)selector {
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
        [SVProgressHUD showErrorWithStatus:err.domain];
    }
}

+ (void)handleSuccess:(NSString *)hud {
    if (hud) {
        [SVProgressHUD showSuccessWithStatus:hud];
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
            NSString *absolutePath = [userPrePath stringByAppendingPathComponent:filePath];
            [data writeToFile:absolutePath atomically:true];
        }
        
        NSLog(@"File size is : %.2f MB", (float) data.length / 1024.0f / 1024.0f);
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
