//
//  MEBabyAlbumVM.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/18.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBabyAlbumVM.h"

@interface MEBabyAlbumVM ()

@property (nonatomic, strong) ClassAlbumPb *babyAlbumPb;

@end

@implementation MEBabyAlbumVM

+ (instancetype)vmWithPb:(ClassAlbumPb *)babyAlbumPb {
    NSAssert(babyAlbumPb != nil, @" could not initialized by nil!");
    return [[self alloc] initWithPb: babyAlbumPb];
}


- (instancetype)initWithPb:(ClassAlbumPb *)pb {
    self = [super init];
    if (self) {
        _babyAlbumPb = pb;
    }
    return self;
}

- (NSString *)cmdCode {
    return FSC_CLASS_ALBUM_LIST;
}


@end
