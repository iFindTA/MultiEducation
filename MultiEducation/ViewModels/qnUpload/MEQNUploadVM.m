//
//  MEQNUploadVM.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/17.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEQNUploadVM.h"

@interface MEQNUploadVM ()

@property (nonatomic, strong) ClassAlbumListPb *qnPb;

@end

@implementation MEQNUploadVM

+ (instancetype)vmWithPb:(ClassAlbumListPb *)qnPb {
    NSAssert(qnPb != nil, @" could not initialized by nil!");
    return [[self alloc] initWithPb: qnPb];
}


- (instancetype)initWithPb:(ClassAlbumListPb *)pb {
    self = [super init];
    if (self) {
        _qnPb = pb;
    }
    return self;
}

- (NSString *)cmdCode {
    return FSC_CLASS_ALBUM_BATCH_POST;
}

@end
