//
//  MEStudentVM.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/20.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEStudentVM.h"
#import "AppDelegate.h"

@interface MEStudentVM ()

@property (nonatomic, strong) StudentPb *pb;
@property (nonatomic, strong) NSString *cmd;

@end

@implementation MEStudentVM

+ (instancetype)vmWithPb:(StudentPb *)pb cmdCode:(NSString *)cmdCode{
    return [[self alloc] initWithPb: pb cmdCode: cmdCode];
}

- (instancetype)initWithPb:(StudentPb *)pb cmdCode:(NSString *)cmdCode {
    self = [super init];
    if (self) {
        _pb = pb;
        self.cmd = cmdCode;
    } 
    return self;
}

+ (void)saveSelectBaby:(StudentPb *)baby {
    
//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    MEPBUser *curUser = delegate.curUser;
//
//    NSArray *arr = [WHCSqlite query: [StudentPb class] where: [NSString stringWithFormat: @"uid = %lld", curUser.id_p]];
//
//    if (arr.count == 0) {
//        [WHCSqlite insert: baby];
//    } else {
//        StudentPb *oldBaby = arr.firstObject;
//        NSString *value = [NSString stringWithFormat: @"uid = %lld, id = %lld", baby.uId, baby.id_p];
//        NSString *where = [NSString stringWithFormat: @"uid = %lld", oldBaby.uId];
//        [WHC_ModelSqlite update: [StudentPb class] value:value  where: where];
//    }
}

+ (StudentPb *)fetchSelectBaby {
//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    MEPBUser *curUser = delegate.curUser;
//
//    NSString *where = [NSString stringWithFormat: @"uid = %lld", curUser.id_p];
//    NSArray *arr = [WHCSqlite query: [StudentPb class] where: where limit: @"1"];
//
//    if (arr.count != 0) {
//        return arr.firstObject;
//    } else {
        return nil;
//    }
}



- (NSString *)cmdCode {
    return self.cmd;
}

@end
