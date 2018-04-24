//
//  MEBabyAlbumVM.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/18.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBabyAlbumListVM.h"

@interface MEBabyAlbumListVM ()

@property (nonatomic, strong) ClassAlbumPb *babyAlbumListPb;

@end

@implementation MEBabyAlbumListVM

+ (instancetype)vmWithPb:(ClassAlbumPb *)babyAlbumListPb {
    return [[self alloc] initWithPb: babyAlbumListPb];
}

- (instancetype)initWithPb:(ClassAlbumPb *)pb {
    self = [super init];
    if (self) {
        _babyAlbumListPb = pb;
    }
    return self;
}

+ (BOOL)saveAlbum:(ClassAlbumPb *)album {
    NSString *where = [NSString stringWithFormat: @"id_p = %lld", album.id_p];
    NSArray *arr = [WHCSqlite query: [ClassAlbumListPb class] where: where limit: @"1"];
    if (arr.count == 0) {
        return [WHCSqlite insert: album];
    } else {
        return NO;
    }
}

+ (NSArray *)fetchAlbumWithClassId:(int64_t)classId {
    NSString *where = [NSString stringWithFormat: @"classId = %lld", classId];
    NSArray *arr = [WHCSqlite query: [ClassAlbumListPb class] where: where];
    return arr;
}

- (NSString *)cmdCode {
    return FSC_CLASS_ALBUM_LIST;
}

@end
