//
//  MENurseryClassVM.m
//  MultiIntelligent
//
//  Created by cxz on 2018/6/26.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MENurseryClassVM.h"
#import "Meclass.pbobjc.h"

@interface MENurseryClassVM ()

@property (nonatomic, strong) MEPBClass *classListPb;

@end

@implementation MENurseryClassVM

#pragma mark --- Override

- (NSString *)cmdCode {
    return @"FSC_CLASS_LIST";
}

#pragma mark --- Class Methods for instance

+ (instancetype)vmWithPB:(MEPBClass *)pb {
    NSAssert(pb != nil, @" could not initialized by nil!");
    return [[self alloc] initWithPB:pb];
}

- (id)initWithPB:(MEPBClass *)pb {
    self = [super init];
    if (self) {
        _classListPb = pb;
    }
    return self;
}

@end
