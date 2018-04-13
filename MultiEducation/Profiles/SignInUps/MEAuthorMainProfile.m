//
//  MEAuthorMainProfile.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/5.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEAuthorMainProfile.h"
#import <JVFloatLabeledTextField/JVFloatLabeledTextField.h>

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
    
    [self hiddenNavigationBar];
    
    //welcom
    MEBaseLabel *label = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
    label.font = UIFontPingFangSCBold(METHEME_FONT_LARGETITLE);
    label.text = @"欢迎登录多元幼教";
    [self.view addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(adoptValue(ME_LAYOUT_SUBBAR_HEIGHT * 2));
        make.left.equalTo(self.view).offset(ME_LAYOUT_BOUNDARY);
        make.right.equalTo(self.view);
        make.height.equalTo(ME_LAYOUT_SUBBAR_HEIGHT);
    }];
    //mobile
    MEBaseImageView *icon = [[MEBaseImageView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:icon];
    icon.image = [UIImage imageNamed:@"signin_mobile"];
    [icon makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(ME_LAYOUT_SUBBAR_HEIGHT);
        make.left.equalTo(self.view).offset(ME_LAYOUT_BOUNDARY);
        make.width.equalTo(ME_LAYOUT_ICON_HEIGHT * 0.5);
        make.height.equalTo(ME_LAYOUT_ICON_HEIGHT);
    }];
    JVFloatLabeledTextField *input = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectZero];
    input.placeholder = @"输入手机号码";
    [self.view addSubview:input];
    [input makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(icon);
        make.left.equalTo(icon.mas_right).offset(ME_LAYOUT_MARGIN);
        make.right.equalTo(self.view).offset(-ME_LAYOUT_BOUNDARY);
    }];
    
    CGRect bounds = CGRectMake(100, 200, 100, 50);
    MEBaseButton *btn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
    btn.frame = bounds;
    [btn setTitle:@"登录" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(loginEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    bounds.origin.y += 100;
    btn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
    btn.frame = bounds;
    [btn setTitle:@"逛逛" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(browserEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self setNeedsStatusBarAppearanceUpdate];
    //黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginEvent {
    [self splash2ChangeDisplayStyle:MEDisplayStyleMainSence];
}

- (void)browserEvent {
    [self splash2ChangeDisplayStyle:MEDisplayStyleVisitor];
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
