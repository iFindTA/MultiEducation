//
//  MEAddChildVM.m
//  MultiIntelligent
//
//  Created by cxz on 2018/6/26.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEAddChildVM.h"
#import "Meuser.pbobjc.h"

@interface MEAddChildVM ()

@property (nonatomic, strong) StudentPb *stuPb;

@end

@implementation MEAddChildVM

#pragma mark --- Override

- (NSString *)cmdCode {
    return @"FSC_STUDENT_POST";
}

#pragma mark --- Class Methods for instance

+ (instancetype)vmWithPB:(StudentPb *)pb {
    NSAssert(pb != nil, @" could not initialized by nil!");
    return [[self alloc] initWithPB:pb];
}

- (id)initWithPB:(StudentPb *)pb {
    self = [super init];
    if (self) {
        _stuPb = pb;
    }
    return self;
}

@end
