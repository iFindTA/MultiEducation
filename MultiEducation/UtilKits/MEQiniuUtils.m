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
@property (nonatomic, strong) NSString *qnToken;

@property (nonatomic, strong) NSMutableArray *keys;

@property (nonatomic, strong) NSMutableArray *succKeys;
@property (nonatomic, strong) NSMutableArray *failKeys;

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

- (void)uploadImages:(NSArray <NSDictionary *> *)images {
    NSData *data = [[images objectAtIndex: _index] objectForKey: @"data"];
    NSString *key = [[images objectAtIndex: _index] objectForKey: @"filePath"];
    __block NSInteger imageIndex = _index;
    __weak typeof(self) weakSelf = self;
    [qnUploadManager putData: data key: key token:self.qnToken
                  complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
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
                      imageIndex++;
                      if (imageIndex >= images.count) {
                          _index = 0;
                          if (self.delegate && [self.delegate respondsToSelector: @selector(uploadOver)]) {
                              [self.delegate uploadOver];
                          }
                          return ;
                      }
                      _index++;
                      [weakSelf uploadImages:images];
                      
                  } option: self.option];
}

- (void)uploadImages:(NSArray<NSDictionary *> *)images callback:(void (^)(NSArray *, NSArray *))callback {
    NSData *data = [[images objectAtIndex: _index] objectForKey: @"data"];
    NSString *key = [[images objectAtIndex: _index] objectForKey: @"filePath"];
    __block NSInteger imageIndex = _index;
    __weak typeof(self) weakSelf = self;
    [qnUploadManager putData: data key: key token:self.qnToken
                    complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                        if (info.isOK) {
                            [self.succKeys addObject: key];
                        } else {
                            [self.failKeys addObject: key];
                        }
                        imageIndex++;
                        if (imageIndex >= images.count) {
                            callback(self.succKeys, self.failKeys);
                            _index = 0;
                            self.succKeys = nil;
                            self.failKeys = nil;
                            self.keys = nil;
                            return;
                        }
                        _index++;
                        [weakSelf uploadImages:images];
                        
                    } option: self.option];
    
}

#pragma mark - lazyloading
- (QNUploadOption *)option {
    if (!_option) {
        __weak typeof(self) weakSelf = self;
        _option = [[QNUploadOption alloc] initWithMime: nil progressHandler:^(NSString *key, float percent) {
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

- (NSMutableArray *)keys {
    if (!_keys) {
        _keys = [NSMutableArray array];
    }
    return _keys;
}

- (NSMutableArray *)succKeys {
    if (!_succKeys) {
        _succKeys = [NSMutableArray array];
    }
    return _succKeys;
}

- (NSMutableArray *)failKeys {
    if (!_failKeys) {
        _failKeys = [NSMutableArray array];
    }
    return _failKeys;
}

@end
