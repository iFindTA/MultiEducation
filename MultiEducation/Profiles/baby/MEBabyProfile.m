//
//  MEBabyProfile.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/5.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBabyProfile.h"

@interface MEBabyProfile ()

@end

@implementation MEBabyProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"宝宝";
    
    
    [self setBadgeValue:10 atIndex:2];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor blueColor];
    [btn setTitle:@"Event" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(urlEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).mas_offset(-20);
        make.top.equalTo(self.view).offset(100);
        make.height.equalTo(@30);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)urlEvent {
    NSString *urlString = @"profile://root@MEVideoPlayProfile/";
    //NSDictionary *params = @{ME_DISPATCH_KEY_CALLBACK:callBack};
    NSError * err = [MEDispatcher openURL:[NSURL URLWithString:urlString] withParams:nil];
    if (err) {
        NSLog(err.description);
    }
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
