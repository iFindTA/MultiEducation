//
//  MEQiniuUtils.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/16.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QiniuSDK.h>
@class MEPhoto;

@protocol UploadImagesCallBack <NSObject>

- (void)uploadImageSuccess:(QNResponseInfo *)info key:(NSString *)key resp:(NSDictionary *)resp;

- (void)uploadImageFail:(QNResponseInfo *)info key:(NSString *)key resp:(NSDictionary *)resp;

- (void)uploadImageProgress:(NSString *)key percent:(float)percent;

//if success only one and other's are total fail, also did this func
- (void)uploadOver:(NSArray *)keys;

@end

@interface MEQiniuUtils : NSObject

@property (nonatomic, weak) id<UploadImagesCallBack> delegate;

+ (instancetype)sharedQNUploadUtils;

- (void)uploadImages:(NSArray <MEPhoto *> *)images keys:(NSMutableArray *)keys;

- (void)uploadVideo:(NSData *)data key:(NSString *)key;


@end
