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
#import "MEPhoto.h"

static QNUploadManager *qnUploadManager;
static MEQiniuUtils *qnUtils;

@interface MEQiniuUtils () {
    NSInteger _index;
}

@property (nonatomic, strong) QNUploadOption *option;

@property (nonatomic, strong) NSString *qnToken;

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

- (void)uploadImages:(NSArray <MEPhoto *> *)images keys:(NSMutableArray *)keys {
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    float limit = delegate.curUser.systemConfigPb.uploadLimit.floatValue;
    float uploadLimit = (limit == 0 ? 2 * 1024 * 1024 : limit * 1024 * 1024);
    
    UIImage *image = images[_index].image;
    __block NSInteger imageIndex = _index;

    NSData *data = UIImagePNGRepresentation(image);
    
    if (data.length > uploadLimit) {
        NSLog(@"image length:(%ld) too big",data.length);
        imageIndex++;
        [self uploadImages: images keys: keys];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    NSString *key = [NSString stringWithFormat: @"%@.jpg", [images objectAtIndex: _index].md5FileName];
    [qnUploadManager putData:data key: key token:self.qnToken
                  complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                      if (info.isOK) {
                          if (weakSelf.delegate && [weakSelf.delegate respondsToSelector: @selector(uploadImageSuccess:key:resp:)]) {
                              dispatch_async_on_main_queue(^{
                                  [self.delegate uploadImageSuccess: info key: key resp: resp];
                              });
                          }
                          [keys addObject:key];
                          NSLog(@"idInex %ld, success", _index);
                      } else {
                          if (weakSelf.delegate && [weakSelf.delegate respondsToSelector: @selector(uploadImageFail:key:resp:)]) {
                              dispatch_async_on_main_queue(^{
                                  [self.delegate uploadImageFail: info key: key resp: resp];
                              });
                          }
                          NSLog(@"idInex %ld, fail", _index);
                      }
                      
                      imageIndex++;
                      
                      if (imageIndex >= images.count) {
                          NSLog(@"上传完成");
                          _index = 0;
                          for (NSString *imgKey in keys) {
                              NSLog(@"%@",imgKey);
                          }
                          if (self.delegate && [self.delegate respondsToSelector: @selector(uploadOver:)]) {
                              [self.delegate uploadOver: keys];
                          }
                          return ;
                      }
                      
                      _index++;
                      [weakSelf uploadImages:images keys:keys];
                      
                  } option: self.option];
}

- (void)uploadVideo:(NSData *)data key:(NSString *)key {
    __weak typeof(self) weakSelf = self;
    [qnUploadManager putData:data key: key token: self.qnToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        NSLog(@"%@", info);
        if (info.isOK) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector: @selector(uploadImageSuccess:key:resp:)]) {
                dispatch_async_on_main_queue(^{
                    [self.delegate uploadImageSuccess: info key: key resp: resp];
                });
            }
        } else {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector: @selector(uploadImageFail:key:resp:)]) {
                dispatch_async_on_main_queue(^{
                    [self.delegate uploadImageFail: info key: key resp: resp];
                });
            }
        }
    } option: self.option];
}

#pragma mark - lazyloading
- (QNUploadOption *)option {
    if (!_option) {
        __weak typeof(self) weakSelf = self;
        _option = [[QNUploadOption alloc] initWithMime: nil progressHandler:^(NSString *key, float percent) {
            NSLog(@"%@ -- percent : %.2f", key, percent);
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(uploadImageProgress:percent:)]) {
                dispatch_async_on_main_queue(^{
                    [weakSelf.delegate uploadImageProgress: key percent: percent];
                });
            }
        } params: nil checkCrc: NO cancellationSignal: nil];
    }
    return _option;
}

- (NSString *)qnToken {
    if (!_qnToken) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        _qnToken = delegate.curUser.uptoken;
    }
    return _qnToken;
}

@end
