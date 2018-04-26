//
//  MESelectFolderProfile.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/26.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MESelectFolderProfile.h"

@interface MESelectFolderProfile ()

@end

@implementation MESelectFolderProfile

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)customNavigation {
    NSString *title = @"移动到";
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *backItem = [MEKits defaultGoBackBarButtonItemWithTarget:self];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:title];
    navigationItem.leftBarButtonItems = @[spacer, backItem];
    [self.navigationBar pushNavigationItem: navigationItem animated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
