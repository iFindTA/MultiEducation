//
//  MEBaseTabBarProfile.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/5.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseTabBarProfile.h"
#import <WZLBadge/UITabBarItem+WZLBadge.h>

@implementation MEBaseTabBarProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //reset badge value
    NSArray<UITabBarItem *>*items = [[self tabBar] items];
    for (UITabBarItem * item in items) {
        [item clearBadge];
    }
}

@end
