//
//  MENotFoundProfile.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/5.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MENotFoundProfile.h"

@interface MENotFoundProfile ()

@end

@implementation MENotFoundProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //left
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *backBarItem = [MEKits defaultGoBackBarButtonItemWithTarget:self];
    UINavigationItem *title = [[UINavigationItem alloc] initWithTitle:@"404"];
    title.leftBarButtonItems = @[spacer, backBarItem];
    [self.navigationBar pushNavigationItem:title animated:true];
    
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:17];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    label.text = @"oops!~~该服务移民到火星了";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
