//
//  ViewController.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/3.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>


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
    
    //NSString *urlString = @"profile://root@MEAuthorMainProfile/?b=7&msg=jjd#code";
    NSString *urlString = @"profile://root@MEVideoPlayProfile/";
    void (^callBack)() = ^(){
        NSLog(@"我是回调执行了");
    };
    NSDictionary *params = @{ME_DISPATCH_KEY_CALLBACK:callBack};
    NSError * err = [MEDispatcher openURL:[NSURL URLWithString:urlString] withParams:params];
    if (err) {
        NSLog(err.description);
    }
    
    //[self splash2ChangeDisplayStyle:MEDisplayStyleMainSence];
}

- (void)videoRecordEvent {
    //params
    void(^callback)(NSString *, CGFloat) = ^(NSString *p, CGFloat d) {
        CGFloat size = [MEKits fileSizeWithPath:p];
        CGFloat uintM = size/ 1024.f / 1024.f;
        NSLog(@"%f 秒的视频大小:%f M", d, uintM);
    };
    NSString *urlString = @"profile://root@MEVideoRecordProfile/";
    NSDictionary *params = @{ME_DISPATCH_KEY_CALLBACK:callback};
    NSError * err = [MEDispatcher openURL:[NSURL URLWithString:urlString] withParams:params];
    if (err) {
        NSLog(err.description);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
