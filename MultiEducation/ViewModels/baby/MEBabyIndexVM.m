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
    
    NSString *where = [NSString stringWithFormat: @"userId = '%lld'", curUser.uid];
    NSArray *arr = [WHCSqlite query: [GuIndexPb class] where: where];
    
    if (arr.count == 0) {
        baby.userId = curUser.uid;
         [WHCSqlite insert: baby];
    } else {
        GuIndexPb *oldBaby = arr.firstObject;
        NSString *where = [NSString stringWithFormat: @"userId = '%lld'", oldBaby.userId];
        [WHCSqlite delete: [GuIndexPb class] where: where];
        baby.userId = curUser.uid;
        [WHCSqlite insert: baby];
    }
}

+ (GuIndexPb *)fetchSelectBaby {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        MEPBUser *curUser = delegate.curUser;
    
        NSString *where = [NSString stringWithFormat: @"userId = '%lld'", curUser.uid];
        NSArray *arr = [WHCSqlite query: [GuIndexPb class] where: where];
    
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
