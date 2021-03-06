//
//  MENurseryVM.m
//  MultiEducation
//
//  Created by cxz on 2018/6/25.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MENurseryVM.h"

@interface MENurseryVM ()

@property (nonatomic, strong) SchoolAddressListPb *schoolPb;

@end

@implementation MENurseryVM

#pragma mark --- Override

- (NSString *)cmdCode {
    return @"FSC_SCHOOL_LIST";
}

#pragma mark --- Class Methods for instance

+ (instancetype)vmWithPB:(SchoolAddressListPb *)pb {
    NSAssert(pb != nil, @" could not initialized by nil!");
    return [[self alloc] initWithPB:pb];
}

- (id)initWithPB:(SchoolAddressListPb *)pb {
    self = [super init];
    if (self) {
        _schoolPb = pb;
    }
    return self;
}

@end
