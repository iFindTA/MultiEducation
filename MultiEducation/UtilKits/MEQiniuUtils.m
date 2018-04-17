//
//  MEQiniuUtils.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/16.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEQiniuUtils.h"
#import <YYKit.h>
#import "MEKits.h"

static double const MAX_IMAGE_LENGTH = 2 * 1024 * 1024; //压缩图片 <= 2MB
static QNUploadManager *qnUploadManager;
static MEQiniuUtils *qnUtils;

@interface MEQiniuUtils ()

@property (nonatomic, strong) QNUploadOption *option;

@end

@implementation MEQiniuUtils

+ (instancetype)sharedQNUploadManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        qnUtils = [[MEQiniuUtils alloc] init];
        qnUploadManager = [[QNUploadManager alloc] init];
    });
    return qnUtils;
}

- (void)uploadImages:(NSArray *)images atIndex:(NSInteger)index token:(NSString *)token uploadManager:(QNUploadManager *)uploadManager keys:(NSMutableArray *)keys {
    UIImage *image = images[index];
    __block NSInteger imageIndex = index;
    NSData *data = UIImagePNGRepresentation([MEKits compressImage: image toByte: MAX_IMAGE_LENGTH]);
    NSString *filename = [NSString stringWithFormat:@"%@.jpg", [data md5String]];
    [uploadManager putData:data key:filename token:token
                  complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                      
                      if (self.uploadImageSuccCallBack) {
                          self.uploadImageSuccCallBack(info, key, resp);
                      }
                      
                      [keys addObject:key];
                      if (imageIndex >= images.count) {
                          NSLog(@"上传完成");
                          for (NSString *imgKey in keys) {
                              NSLog(@"%@",imgKey);
                          }
                          return ;
                      }
                      if (info.isOK) {
                          NSLog(@"idInex %ld, success",index);
                          [self uploadImages:images atIndex:imageIndex token:token uploadManager:uploadManager keys:keys];
                      } else {
                          NSLog(@"idInex %ld, fail",index);
                      }
      
                      imageIndex++;

                  } option: self.option];
}

- (void)uploadProgress {
    self.option = [[QNUploadOption alloc] initWithMime: nil progressHandler:^(NSString *key, float percent) {
        if (self.uploadImageOptionHandler) {
            self.uploadImageOptionHandler(key, percent);
        }
    } params: nil checkCrc: NO cancellationSignal: nil];
}

@end
