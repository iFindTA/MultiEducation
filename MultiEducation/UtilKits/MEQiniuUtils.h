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

- (void)uploadImageSuccess:(NSString *)key;

- (void)uploadImageFail:(NSString *)key;

@optional
- (void)uploadImageProgress:(NSString *)key percent:(float)percent;

//if success only one and other's are total fail, also did this func
- (void)uploadOver;

@end

@interface MEQiniuUtils : NSObject

@property (nonatomic, weak) id<UploadImagesCallBack> delegate;

+ (instancetype)sharedQNUploadUtils;

- (void)uploadImages:(NSArray <NSDictionary *> *)images;

- (void)uploadImages:(NSArray <NSDictionary *> *)images callback:(void(^)(NSArray * succKeys, NSArray * failKeys))callback;

@end
