//
//  MEAboutMeProfile.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/23.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEAboutMeProfile.h"
#import "MEAboutMeContent.h"

@interface MEAboutMeProfile ()


@end

@implementation MEAboutMeProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customNavigation]
    ;
    MEAboutMeContent *contentView = [[NSBundle mainBundle] loadNibNamed: @"MEAboutMeContent" owner: self options: nil].firstObject;
    [self.view addSubview: contentView];
    
    //layout
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).mas_offset(ME_HEIGHT_STATUSBAR + ME_HEIGHT_NAVIGATIONBAR);
    }];

}

- (void)customNavigation {
    NSString *title = @"关于我们";
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *backItem = [self backBarButtonItem:nil withIconUnicode:@"\U0000e6e2"];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:title];
    item.leftBarButtonItems = @[spacer, backItem];
    [self.navigationBar pushNavigationItem:item animated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
