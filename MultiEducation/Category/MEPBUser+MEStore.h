//
//  MEPBUser+MEStore.h
//  MultiEducation
//
//  Created by nanhu on 2018/4/16.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "Meuser.pbobjc.h"
#import <WHC_ModelSqliteKit/WHC_ModelSqlite.h>

@interface MEPBUser (MEStore)<WHC_SqliteInfo>

+ (NSString *)whc_SqliteMainkey;

+ (NSArray *)whc_IgnorePropertys;

@end
