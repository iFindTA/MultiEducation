//
//  MEQNUploadVM.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/17.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEQNUploadVM.h"

@interface MEQNUploadVM ()

@property (nonatomic, strong) ClassAlbumPb *qnPb;
@property (nonatomic, strong) NSString *reqCode;

@end

@implementation MEQNUploadVM

+ (instancetype)vmWithPb:(ClassAlbumPb *)qnPb reqCode:(NSString *)reqCode {
    NSAssert(qnPb != nil, @" could not initialized by nil!");
    return [[self alloc] initWithPb: qnPb reqCode:reqCode];
}


- (instancetype)initWithPb:(ClassAlbumPb *)pb reqCode:(NSString *)reqCode {
    self = [super init];
    if (self) {
        _qnPb = pb;
        _reqCode = reqCode;
    }
    return self;
}

- (NSString *)cmdCode {
    return @"FSC_CLASS_ALBUM_POST";
}

- (NSString *)reqCode {
    return _reqCode;
}

@end
