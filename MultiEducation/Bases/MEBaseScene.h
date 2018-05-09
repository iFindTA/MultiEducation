//
//  MEBaseScene.h
//  MultiEducation
//
//  Created by nanhu on 2018/4/7.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEKits.h"
#import "PBView.h"
#import "Meuser.pbobjc.h"
#import "MEUIBaseHeader.h"
#import "MEBaseTableView.h"
#import <PBService/PBService.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface MEBaseScene : PBView

/**
 section tag for label
 */
@property (nonatomic, assign) NSUInteger sectionTag;

/**
 getter user
 */
- (MEPBUser * _Nullable)currentUser;

- (void)showIndecator;

- (void)hiddenIndecator;

@end
