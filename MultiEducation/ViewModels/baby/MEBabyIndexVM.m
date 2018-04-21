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

+ (void)saveSelectBaby:(GuStudentArchivesPb *)baby {

        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        MEPBUser *curUser = delegate.curUser;
    
        NSArray *arr = [WHCSqlite query: [GuStudentArchivesPb class]  where: [NSString stringWithFormat: @"userId = %lld", curUser.id_p]];
    
        if (arr.count == 0) {
            [WHCSqlite insert: baby];
        } else {
            GuStudentArchivesPb *oldBaby = arr.firstObject;
            NSString *value = [NSString stringWithFormat: @"userId = %lld, id = %lld", baby.studentId, baby.userId];
            NSString *where = [NSString stringWithFormat: @"userId = %lld", oldBaby.userId];
            [WHC_ModelSqlite update: [GuStudentArchivesPb class] value:value  where: where];
        }
}

+ (GuStudentArchivesPb *)fetchSelectBaby {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        MEPBUser *curUser = delegate.curUser;
    
        NSString *where = [NSString stringWithFormat: @"userId = %lld", curUser.id_p];
        NSArray *arr = [WHCSqlite query: [GuStudentArchivesPb class] where: where limit: @"1"];
    
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
