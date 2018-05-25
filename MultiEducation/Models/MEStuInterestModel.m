//
//  MEStuInterestModel.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/5/24.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEStuInterestModel.h"
#import <WHC_ModelSqlite.h>
#import "Meuser.pbobjc.h"
#import "AppDelegate.h"
#import <objc/message.h>

@interface MEStuInterestModel () <NSCoding>


@end

@implementation MEStuInterestModel


+ (MEPBUser *)curUser {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.curUser;
}

- (MEPBUser *)curUser {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.curUser;
}

+ (void)saveOrUpdateStudentInterestModel:(MEStuInterestModel *)model {
    NSString *sql = [NSString stringWithFormat: @"uId = %lld AND role = %d", [self curUser].uid, [self curUser].userType];
    MEStuInterestModel *existModel = [WHCSqlite query: [MEStuInterestModel class] where: sql limit: @"1"].firstObject;
    if (existModel) {
        [WHCSqlite delete:[MEStuInterestModel class] where: sql];
    }
    [WHCSqlite insert: model];
}

+ (MEStuInterestModel *)fetchStudentInterestModel {
    NSString *sql = [NSString stringWithFormat: @"uId = %lld AND role = %d", [self curUser].uid, [self curUser].userType];
    MEStuInterestModel *model = [WHCSqlite query: [MEStuInterestModel class] where: sql limit: @"1"].firstObject;
    return model;
}

+ (void)deleteStudentInterestModel {
    NSString *sql = [NSString stringWithFormat: @"uId = %lld AND role = %d", [self curUser].uid, [self curUser].userType];
    MEStuInterestModel *model = [WHCSqlite query: [MEStuInterestModel class] where: sql limit: @"1"].firstObject;
    if (model) {
        [WHCSqlite delete: [MEStuInterestModel class] where: sql];
    }
}

#pragma mark - NSCoding
//- (id)initWithCoder:(NSCoder *)coder {
//    
//}
//
//- (void)encodeWithCoder:(NSCoder *)coder {
//   
//}

#pragma mark -setter
- (void)setTitle:(NSString *)title {
    _title = title;
    self.uId = [self curUser].uid;
    self.role = [self curUser].userType;
}

- (void)setContext:(NSString *)context {
    _context = context;
    self.uId = [self curUser].uid;
    self.role = [self curUser].userType;
}

- (void)setImages:(NSArray *)images {
    _images = images;
    self.uId = [self curUser].uid;
    self.role = [self curUser].userType;
}

- (void)setStuArr:(NSArray *)stuArr {
    _stuArr = stuArr;
    self.uId = [self curUser].uid;
    self.role = [self curUser].userType;
}

@end
