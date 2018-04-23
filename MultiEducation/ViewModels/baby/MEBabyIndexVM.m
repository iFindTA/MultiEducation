//
//  MEBabyIndexVM.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/21.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBabyIndexVM.h"
#import "AppDelegate.h"
#import "Meuser.pbobjc.h"


@interface MEBabyIndexVM ()

@property (nonatomic, strong) GuIndexPb *pb;

@end

@implementation MEBabyIndexVM

+ (instancetype)vmWithPb:(GuIndexPb *)pb {
    return [[self alloc] initWithPb: pb];
}

- (instancetype)initWithPb:(GuIndexPb *)pb {
    self = [super init];
    if (self) {
        _pb = pb;
    }
    return self;
}

+ (void)saveSelectBaby:(GuIndexPb *)baby {

        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        MEPBUser *curUser = delegate.curUser;
    
        NSArray *arr = [WHCSqlite query: [GuIndexPb class]  where: [NSString stringWithFormat: @"studentArchives.userId = %lld", curUser.id_p]];
    
        if (arr.count == 0) {
            [WHCSqlite insert: baby];
        } else {
            GuIndexPb *oldBaby = arr.firstObject;
            NSString *value = [NSString stringWithFormat: @"studentArchives.id = %lld", baby.studentArchives.studentId];
            NSString *where = [NSString stringWithFormat: @"userId = %lld", oldBaby.studentArchives.userId];
            [WHCSqlite update: [GuIndexPb class] value:value  where: where];
        }
}

+ (GuIndexPb *)fetchSelectBaby {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        MEPBUser *curUser = delegate.curUser;
    
        NSString *where = [NSString stringWithFormat: @"userId = %lld", curUser.id_p];
        NSArray *arr = [WHCSqlite query: [GuIndexPb class] where: where limit: @"1"];
    
        if (arr.count != 0) {
            return arr.firstObject;
        } else {
            return nil;
        }
}

- (NSString *)cmdCode {
    return @"GU_INDEX";
}

@end
