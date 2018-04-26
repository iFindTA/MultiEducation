//
//  MEQNUploadBatchVM.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/26.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEQNUploadBatchVM.h"

@interface MEQNUploadBatchVM ()

@property (nonatomic, strong) ClassAlbumListPb *listPb;

@end

@implementation MEQNUploadBatchVM

+ (instancetype)vmWithPb:(ClassAlbumListPb *)listPb {
    NSAssert(listPb != nil, @" could not initialized by nil!");
    return [[self alloc] initWithPb: listPb];
}


- (instancetype)initWithPb:(ClassAlbumListPb *)pb {
    self = [super init];
    if (self) {
        _listPb = pb;
    }
    return self;
}

- (NSString *)cmdCode {
    return @"FSC_CLASS_ALBUM_POST";
}

@end
