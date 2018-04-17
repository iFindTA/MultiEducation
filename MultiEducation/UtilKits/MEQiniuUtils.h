//
//  MEQiniuUtils.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/16.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QiniuSDK.h>

typedef void(^UploadImageSuccCallBack)(QNResponseInfo *info, NSString *key, NSDictionary *resp);

typedef void(^UploadImageOptionHandler)(NSString *key, float percent);

@interface MEQiniuUtils : NSObject

@property (nonatomic, copy) UploadImageSuccCallBack uploadImageSuccCallBack;

@property (nonatomic, copy) UploadImageOptionHandler uploadImageOptionHandler;

+ (instancetype)sharedQNUploadManager;

- (void)uploadImages:(NSArray *)images atIndex:(NSInteger)index token:(NSString *)token uploadManager:(QNUploadManager *)uploadManager keys:(NSMutableArray *)keys;

@end
