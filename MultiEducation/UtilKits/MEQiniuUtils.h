//
//  MEQiniuUtils.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/16.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QiniuSDK.h>

@protocol UploadImagesCallBack <NSObject>

- (void)uploadImageSuccess:(QNResponseInfo *)info key:(NSString *)key resp:(NSDictionary *)resp index:(NSInteger)index;

- (void)uploadImageFail:(QNResponseInfo *)info key:(NSString *)key resp:(NSDictionary *)resp index:(NSInteger)index;

- (void)uploadImageProgress:(NSString *)key percent:(float)percent index:(NSInteger)index;

@end

@interface MEQiniuUtils : NSObject

@property (nonatomic, weak) id<UploadImagesCallBack> delegate;

+ (instancetype)sharedQNUploadUtils;

- (void)uploadImages:(NSArray *)images atIndex:(NSInteger)index token:(NSString *)token keys:(NSMutableArray *)keys;

@end
