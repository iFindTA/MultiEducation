//
//  MEStuIntersetVM.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/5/21.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEStuInterestVM.h"

@interface MEStuInterestVM ()

@property (nonatomic, strong) GuFunPhotoPb *funPhotoPb;

@end

@implementation MEStuInterestVM

+ (instancetype)vmWithPb:(GuFunPhotoPb *)funPhotoPb {
    return [[self alloc] initWithPb: funPhotoPb];
}

- (instancetype)initWithPb:(GuFunPhotoPb *)pb {
    self = [super init];
    if (self) {
        _funPhotoPb = pb;
    }
    return self;
}

- (NSString *)cmdCode {
    return @"GU_FUN_PHOTO_PUT";
}


@end
