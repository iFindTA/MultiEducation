//
//  MEAlbumDeleteVM.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/25.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEAlbumDeleteVM.h"

@interface MEAlbumDeleteVM ()

@property (nonatomic, strong) ClassAlbumListPb *babyAlbumListPb;

@end

@implementation MEAlbumDeleteVM

+ (instancetype)vmWithPb:(ClassAlbumListPb *)babyAlbumListPb {
    return [[self alloc] initWithPb: babyAlbumListPb];
}

- (instancetype)initWithPb:(ClassAlbumListPb *)pb {
    self = [super init];
    if (self) {
        _babyAlbumListPb = pb;
    }
    return self;
}

- (NSString *)cmdCode {
    return FSC_CLASS_ALBUM_DEL;
}

@end
