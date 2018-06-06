//
//  MEBabyAlbumVM.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/18.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBabyAlbumListVM.h"
#import "AppDelegate.h"
#import "Meuser.pbobjc.h"
#import "Meclass.pbobjc.h"

@interface MEBabyAlbumListVM ()

@property (nonatomic, strong) ClassAlbumPb *babyAlbumPb;

@end

@implementation MEBabyAlbumListVM

+ (instancetype)vmWithPb:(ClassAlbumPb *)babyAlbumListPb {
    return [[self alloc] initWithPb: babyAlbumListPb];
}

- (instancetype)initWithPb:(ClassAlbumPb *)pb {
    self = [super init];
    if (self) {
        _babyAlbumPb = pb;
    }
    return self;
}

+ (BOOL)saveAlbum:(ClassAlbumPb *)album {
    NSString *where = [NSString stringWithFormat: @"id_p = %lld", album.id_p];
    NSArray *arr = [WHCSqlite query: [ClassAlbumPb class] where: where limit: @"1"];
    if (arr.count == 0) {
        return [WHCSqlite insert: album];
    } else {
        BOOL result = [WHCSqlite delete: [ClassAlbumPb class] where: where];
        if (result) {
            return [WHCSqlite insert: album];
        } else {
            return NO;
        }
    }
}

+ (BOOL)deleteAlbum:(ClassAlbumPb *)album {
    NSString *where = [NSString stringWithFormat: @"id_p = %lld", album.id_p];
    ClassAlbumPb *pb = [WHCSqlite query: [ClassAlbumPb class] where: where limit: @"1"].firstObject;
    if (pb.dataStatus == 0) {
        return YES;
    } else {
        BOOL result = [WHC_ModelSqlite update: [ClassAlbumPb class] value: @"dataStatus = 1" where: where];
        return result;
    }
}

+ (NSArray *)fetchUserAllAlbum {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    MEPBUser *user = delegate.curUser;
    
    NSArray *classPbArr;
    if (user.userType == MEPBUserRole_Teacher) {
        classPbArr = user.teacherPb.classPbArray;
    } else if (user.userType == MEPBUserRole_Gardener) {
        classPbArr = user.deanPb.classPbArray;
    } else if (user.userType == MEPBUserRole_Parent) {
        classPbArr = user.parentsPb.classPbArray;
    } else {
        return nil;
    }
    if (PBIsEmpty(classPbArr)) {
        return nil;
    }
    
    NSMutableString *where = [NSMutableString string];
    for (MEPBClass *class in classPbArr) {
        [where appendString: [NSString stringWithFormat: @"classId = '%lld' AND", class.id_p]];
    }
    [where appendFormat: @" dataStatus = 1"];
    NSArray *arr = [WHCSqlite query: [ClassAlbumPb class] where: where order: @"by modifiedDate desc"];
    return arr;
}

+ (NSArray *)fetchAlbmsWithClassId:(int64_t)classId {
    NSString *where = [NSString stringWithFormat: @"classId = %lld AND dataStatus = 1", classId];
    NSArray *arr = [WHCSqlite query: [ClassAlbumPb class] where: where order: @"by modifiedDate desc"];
    return arr;
}

+ (NSArray *)fetchAlbumsWithParentId:(int64_t)parentId {
    NSString *where = [NSString stringWithFormat: @"parentId = %lld AND dataStatus = 1", parentId];
    NSArray *arr = [WHCSqlite query: [ClassAlbumPb class] where: where order: @"by modifiedDate desc"];
    return arr;
}

+ (NSArray *)fetchAlbumsWithParentId:(int64_t)parentId classId:(int64_t)classId {
    NSString *where = [NSString stringWithFormat: @"parentId = %lld AND classId = %lld AND dataStatus = 1", parentId, classId];
    NSArray *arr = [WHCSqlite query: [ClassAlbumPb class] where: where order: @"by modifiedDate desc"];
    return arr;
}

+ (int64_t)fetchNewestModifyDate {
    ClassAlbumPb *newestAlbum = [WHCSqlite query: [ClassAlbumPb class] order: @"by modifiedDate desc"].firstObject;
    return newestAlbum.modifiedDate;
}

- (NSString *)cmdCode {
    return FSC_CLASS_ALBUM_LIST;
}

@end
