//
//  ViewController.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/3.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>
#import "MEFrameProfile.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.title = @"first";
    self.view.backgroundColor = [UIColor whiteColor];
    
    /**
     18751732219:123456
     */
    

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor blueColor];
    [btn setTitle:@"push" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pushEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).mas_offset(-20);
        make.top.equalTo(self.view).offset(100);
        make.height.equalTo(@30);
    }];
    
    
}

- (void)pushEvent {
//    MEFrameProfile *profile = [[MEFrameProfile alloc] init];
//    [self.navigationController pushViewController:profile animated:true];
    
    NSString *urlString = @"profile://root@MEAuthorMainProfile/?b=7&msg=jjd#code";
    NSError * err = [MEDispatcher openURL:[NSURL URLWithString:urlString] withParams:nil];
    if (err) {
        NSLog(err.description);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
