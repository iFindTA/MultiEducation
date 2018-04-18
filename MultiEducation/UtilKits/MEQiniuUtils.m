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
#import "AppDelegate.h"
#import "Meuser.pbobjc.h"

static QNUploadManager *qnUploadManager;
static MEQiniuUtils *qnUtils;

@interface MEQiniuUtils () {
    NSInteger _index;
}

@property (nonatomic, strong) QNUploadOption *option;

@end

@implementation MEQiniuUtils

+ (instancetype)sharedQNUploadUtils {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        qnUtils = [[MEQiniuUtils alloc] init];
        qnUploadManager = [[QNUploadManager alloc] init];
    });
    return qnUtils;
}

- (void)uploadImages:(NSArray *)images atIndex:(NSInteger)index token:(NSString *)token keys:(NSMutableArray *)keys {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    float limit = delegate.curUser.systemConfigPb.uploadLimit.floatValue;
    UIImage *image = images[index];
    __block NSInteger imageIndex = index;
    float uploadLimit = (limit == 0 ? 2 * 1024 * 1024 : limit * 1024 * 1024);
    NSData *data = UIImageJPEGRepresentation([MEKits compressImage: image toByte: uploadLimit], 0.7);
    
    if (data.length > uploadLimit) {
        NSLog(@"image length:(%ld) too big",data.length);
        imageIndex++;
        [self uploadImages:images atIndex:imageIndex token:token keys:keys];
        return;
    }
    
    NSString *filename = [NSString stringWithFormat:@"%@.jpg", [data md5String]];
    __weak typeof(self) weakSelf = self;
    [qnUploadManager putData:data key:filename token:token
                  complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                      _index = index;
                      if (info.isOK) {
                          if (weakSelf.delegate && [weakSelf.delegate respondsToSelector: @selector(uploadImageSuccess:key:resp:index:)]) {
                              dispatch_async_on_main_queue(^{
                                  [self.delegate uploadImageSuccess: info key: key resp: resp index: index];
                              });
                          }
                          NSLog(@"idInex %ld, success",index);
                      } else {
                          if (weakSelf.delegate && [weakSelf.delegate respondsToSelector: @selector(uploadImageFail:key:resp:index:)]) {
                              dispatch_async_on_main_queue(^{
                                  [self.delegate uploadImageFail: info key: key resp: resp index: index];
                              });
                          }
                          NSLog(@"idInex %ld, fail",index);
                      }
                      
                      imageIndex++;
                      
                      [keys addObject:key];
                      if (imageIndex >= images.count) {
                          if (self.delegate && [self.delegate respondsToSelector: @selector(uploadOver)]) {
                              [self.delegate uploadOver];
                          }
                          NSLog(@"上传完成");
                          for (NSString *imgKey in keys) {
                              NSLog(@"%@",imgKey);
                          }
                          return ;
                      }
                      
                      [weakSelf uploadImages:images atIndex:imageIndex token:token keys:keys];
                      
                  } option: self.option];
}

#pragma mark - lazyloading
- (QNUploadOption *)option {
    if (!_option) {
        __weak typeof(self) weakSelf = self;
        _option = [[QNUploadOption alloc] initWithMime: nil progressHandler:^(NSString *key, float percent) {
            NSLog(@"%@ -- percent : %.2f", key, percent);
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(uploadImageProgress:percent:index:)]) {
                dispatch_async_on_main_queue(^{
                    [weakSelf.delegate uploadImageProgress: key percent: percent index: _index];
                });
            }
        } params: nil checkCrc: NO cancellationSignal: nil];
    }
    return _option;
}

@end
