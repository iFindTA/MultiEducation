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
#import "MEFileQuryVM.h"
#import "Meqnfile.pbobjc.h"
#import <SVProgressHUD.h>

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

- (void)uploadImagesWithCheck:(NSArray <NSDictionary *> *)images {
    weakify(self);
    [self checkWhetherExistInServer: images checkCallback:^(NSArray<NSDictionary *> *noExistArr, NSArray<NSDictionary *> *existArr) {
        strongify(self);
        
        for (NSDictionary *dic in existArr) {
            [self.delegate uploadImageSuccess: [dic objectForKey: @"filePath"]];
        }
        
        NSData *data = [[noExistArr objectAtIndex: _index] objectForKey: @"data"];
        NSString *key = [[noExistArr objectAtIndex: _index] objectForKey: @"filePath"];
        __block NSInteger imageIndex = _index;
        weakify(self);
        [qnUploadManager putData: data key: key token:self.qnToken
                        complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                strongify(self);
                if (info.isOK) {
                    if (self.delegate && [self.delegate respondsToSelector: @selector(uploadImageSuccess:)]) {
                        dispatch_async_on_main_queue(^{
                            [self.delegate uploadImageSuccess: key];
                        });
                    }
                } else {
                    if (self.delegate && [self.delegate respondsToSelector: @selector(uploadImageFail:)]) {
                        dispatch_async_on_main_queue(^{
                            [self.delegate uploadImageFail: key];
                        });
                    }
                }
                imageIndex++;
                if (imageIndex >= noExistArr.count) {
                    _index = 0;
                    if (self.delegate && [self.delegate respondsToSelector: @selector(uploadOver)]) {
                        [self.delegate uploadOver];
                    }
                    return ;
                }
                _index++;
                [self uploadImagesWithCheck: noExistArr];
                
            } option: self.option];
    }];
}

- (void)uploadImagesWithUncheck:(NSArray <ClassAlbumPb *> *)albums {
    //NSLog(@"上传图片index:%ld", _index);
    NSData *data = [albums objectAtIndex: _index].fileData;
    NSString *key = [albums objectAtIndex: _index].filePath;
    __block NSInteger imageIndex = _index;
    weakify(self);
    [qnUploadManager putData: data key: key token:self.qnToken
                    complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                        NSLog(@"上传结果key:%@------:%@", key, info);
                        strongify(self);
                        if (info.isOK) {
                            if (self.delegate && [self.delegate respondsToSelector: @selector(uploadImageSuccess:)]) {
                                dispatch_async_on_main_queue(^{
                                    [self.delegate uploadImageSuccess: key ];
                                });
                            }
                        } else {
                            if (self.delegate && [self.delegate respondsToSelector: @selector(uploadImageFail:)]) {
                                dispatch_async_on_main_queue(^{
                                    [self.delegate uploadImageFail: key];
                                });
                            }
                        }
                        imageIndex++;
                        if (imageIndex >= albums.count) {
                            _index = 0;
                            if (self.delegate && [self.delegate respondsToSelector: @selector(uploadOver)]) {
                                [self.delegate uploadOver];
                            }
                            return ;
                        }
                        _index++;
                        [self uploadImagesWithUncheck: albums];
                        
                    } option: self.option];
}

- (void)uploadImages:(NSArray<NSDictionary *> *)images callback:(void (^)(NSArray *, NSArray *, NSError *error))callback {
    weakify(self);
    [self checkWhetherExistInServer: images checkCallback:^(NSArray <NSDictionary *> *noExistArr, NSArray <NSDictionary *> *existArr) {
        strongify(self);
        if (existArr.count != 0) {
            for (NSDictionary *dic in existArr) {
                [self.succKeys addObject: [dic objectForKey: @"filePath"]];
            }
            callback(self.succKeys, nil, nil);
        }
        if (noExistArr.count == 0) {
            return;
        }
        NSData *data = [[noExistArr objectAtIndex: _index] objectForKey: @"data"];
        NSString *key = [[noExistArr objectAtIndex: _index] objectForKey: @"filePath"];
        __block NSInteger imageIndex = _index;
        weakify(self);
        [qnUploadManager putData: data key: key token:self.qnToken
                        complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                            strongify(self);
                            if (info.isOK) {
                                [self.succKeys addObject: key];
                            } else {
                                [self.failKeys addObject: key];
                            }
                            imageIndex++;
                            if (imageIndex >= noExistArr.count) {
                                callback(self.succKeys, self.failKeys, info.error);
                                _index = 0;
                                self.succKeys = nil;
                                self.failKeys = nil;
                                self.keys = nil;
                                return;
                            }
                            _index++;
                            [self uploadImages:noExistArr callback: callback];
                            
                        } option: self.option];
    }];
}

- (void)checkWhetherExistInServer:(NSArray <NSDictionary *> *)images checkCallback:(void(^)(NSArray <NSDictionary *> *noExistArr, NSArray <NSDictionary *> *existArr))checkCallback {
    MEPBQNFile *pb = [[MEPBQNFile alloc] init];
    MEFileQuryVM *fileQuryVM = [MEFileQuryVM vmWithPb: pb];
    
    NSMutableString *md5Str = [NSMutableString string];
    for (NSDictionary *dic in images) {
        [md5Str appendString: [NSString stringWithFormat: @"%@,", [dic objectForKey: @"md5"]]];
    }
    [md5Str deleteCharactersInRange: NSMakeRange(md5Str.length - 1, 1)];
    pb.fileMd5Str = md5Str;
    [fileQuryVM postData: [pb data] hudEnable: YES success:^(NSData * _Nullable resObj) {
        MEPBQNFile *filePb = [MEPBQNFile parseFromData: resObj error: nil];
        NSArray *fileIdArr = [filePb.fileIdStr componentsSeparatedByString: @","];
        NSMutableArray *noExistArray = [NSMutableArray array];
        NSMutableArray *existArray = [NSMutableArray array];
        int index = 0;
        for (NSString *fileId in fileIdArr) {
            if (fileId.integerValue <= 0) {
                [noExistArray addObject: [images objectAtIndex: index]];
            } else {
                [existArray addObject: [images objectAtIndex: index]];
            }
            index++;
        }
        checkCallback(noExistArray, existArray);
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus: error.domain];
    }];
}

- (void)checkWhetherExistInServer:(NSArray <NSDictionary *> *)images callback:(void (^)(NSDictionary *returnDic))callback {
    MEPBQNFile *pb = [[MEPBQNFile alloc] init];
    MEFileQuryVM *fileQuryVM = [MEFileQuryVM vmWithPb: pb];
    
    NSMutableString *md5Str = [NSMutableString string];
    for (NSDictionary *dic in images) {
        [md5Str appendString: [NSString stringWithFormat: @"%@,", [dic objectForKey: @"md5"]]];
    }
    [md5Str deleteCharactersInRange: NSMakeRange(md5Str.length - 1, 1)];
    //NSLog(@"上传前的md5文件名:%@", md5Str);
    pb.fileMd5Str = md5Str;
    [fileQuryVM postData: [pb data] hudEnable: YES success:^(NSData * _Nullable resObj) {
        MEPBQNFile *filePb = [MEPBQNFile parseFromData: resObj error: nil];
        //NSLog(@"上传查询服务器结果:%@", filePb.fileIdStr);
        NSArray *fileIdArr = [filePb.fileIdStr componentsSeparatedByString: @","];
        NSMutableArray *noExistArray = [NSMutableArray array];
        NSMutableArray *existArray = [NSMutableArray array];
        int index = 0;
        for (NSString *fileId in fileIdArr) {
            if (fileId.integerValue <= 0) {
                [noExistArray addObject: [images objectAtIndex: index]];
            } else {
                [existArray addObject: [images objectAtIndex: index]];
            }
            index++;
        }
        
        NSDictionary *returnDic = @{@"noExist": noExistArray, @"exist": existArray};
        callback(returnDic);
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus: error.domain];
    }];
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
