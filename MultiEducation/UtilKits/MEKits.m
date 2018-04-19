//
//  MEKits.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/5.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEKits.h"
#import <sys/stat.h>
#import "AppDelegate.h"
#import "Meuser.pbobjc.h"

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

+ (CGFloat)fileSizeWithPath:(NSString *)path {
    NSAssert(path.length != 0, @"empty file path");
    const char *filename = path.UTF8String;
    struct stat st;
    memset(&st, 0, sizeof(st));
    stat(filename, &st);
    return st.st_size;
}

+ (NSString *)imageFullPath:(NSString *)absPath {
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (app.curUser) {
        return PBFormat(@"%@/%@", app.curUser.bucketDomain, absPath);
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
