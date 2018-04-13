//
//  MEBaseScene.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/7.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseScene.h"
#import "MEUserVM.h"
#import "AppDelegate.h"
#import <SVProgressHUD/SVProgressHUD.h>

@implementation MEBaseScene

- (AppDelegate *)appDelegate {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return delegate;
}
#pragma mark --- user relatives

- (MEUserRole)currentUserRole {
    return [[self appDelegate].curUser userRole];
}

- (void)handleTransitionError:(NSError *)error {
    if (error) {
        [SVProgressHUD showErrorWithStatus:error.domain];
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
