//
//  MEFolderPatch.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/26.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEFolderPatchVM.h"

@interface MEFolderPatchVM ()

@property (nonatomic, strong) ClassAlbumListPb *babyAlbumListPb;
@property (nonatomic, strong) ClassAlbumPb *albumPb;

@end

@implementation MEFolderPatchVM

+ (instancetype)vmWithPb:(ClassAlbumListPb *)babyAlbumListPb {
    return [[self alloc] initWithAlbumListPb: babyAlbumListPb];
}

+ (instancetype)vmWithClassAlbumPb:(ClassAlbumPb *)albumPb {
    return [[self alloc] initWithAlbumPb: albumPb];
}
 
- (instancetype)initWithAlbumListPb:(ClassAlbumListPb *)pb {
    self = [super init];
    if (self) {
        _babyAlbumListPb = pb;
    }
    return self;
}

- (instancetype)initWithAlbumPb:(ClassAlbumPb *)pb {
    self = [super init];
    if (self) {
        _albumPb = pb;
    }
    return self;
}

- (NSString *)cmdCode {
    return FSC_CLASS_ALBUM_PATCH;
}

@end
