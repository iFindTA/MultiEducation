//
//  MEAuthorMainProfile.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/5.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEAuthorMainProfile.h"

@interface MEAuthorMainProfile ()

@property (nonatomic, strong) NSDictionary *params;

@end

@implementation MEAuthorMainProfile

- (instancetype)__initWithParams:(NSDictionary *)params {
    self = [super init];
    if (self) {
        self.params = params;
        NSLog(@"收到的参数:%@", params);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //left
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *backBarItem = [self backBarButtonItem:nil withIconUnicode:@"\U0000e600"];
    UINavigationItem *title = [[UINavigationItem alloc] initWithTitle:@"授权中心"];
    title.leftBarButtonItems = @[spacer, backBarItem];
    [self.navigationBar pushNavigationItem:title animated:true];
    
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    label.text = @"授权中心";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    void (^callback)() = self.params[ME_DISPATCH_KEY_CALLBACK];
    if (callback) {
        callback();
    }
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
