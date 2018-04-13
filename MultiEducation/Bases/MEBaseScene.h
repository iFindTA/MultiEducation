//
//  MEBaseScene.h
//  MultiEducation
//
//  Created by nanhu on 2018/4/7.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "PBView.h"
#import "MEUIBaseHeader.h"

@interface MEBaseScene : PBView

/**
 getter user role
 */
- (MEUserRole)currentUserRole;

/**
 handle error
 */
- (void)handleTransitionError:(NSError *_Nullable)error;

@end
