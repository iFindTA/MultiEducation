//
//  MEBaseScene.h
//  MultiEducation
//
//  Created by nanhu on 2018/4/7.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "PBView.h"
#import "Meuser.pbobjc.h"
#import "MEUIBaseHeader.h"

@interface MEBaseScene : PBView

/**
 getter user
 */
- (MEPBUser * _Nullable)currentUser;

/**
 handle error
 */
- (void)handleTransitionError:(NSError *_Nullable)error;

@end
