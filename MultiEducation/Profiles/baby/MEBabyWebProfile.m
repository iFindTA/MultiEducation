//
//  MEBabyWebProfile.m
//  fsc-ios-wan
//
//  Created by 崔小舟 on 2018/4/11.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEBabyWebProfile.h"
#import "MEBaseLabel.h"

@interface MEBabyWebProfile ()

@property (nonatomic, strong) NSDictionary *params; //params;

@property (nonatomic, strong) UINavigationItem *navigationItem;

@property (nonatomic, strong) MEBaseLabel *titleLab;    //nav titlelab
@property (nonatomic, strong) UIBarButtonItem *backItem;  //go back web
@property (nonatomic, strong) UIBarButtonItem *closeItem;   //pop nav

@end

@implementation MEBabyWebProfile

- (instancetype)__initWithParams:(NSDictionary *)params {
    self = [super init];
    if (self) {
        self.params = params;
        NSLog(@"收到的参数:%@", params);
    }
    return self;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.navigationBar.mas_bottom);
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLab.text = [self.params objectForKey: @"title"];
    self.navigationItem.leftBarButtonItem = self.backItem;
    self.navigationItem.titleView = self.titleLab;
    [self.navigationBar pushNavigationItem: self.navigationItem animated:true];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.scalesPageToFit = YES;
    _webView.allowsInlineMediaPlayback = YES;
    _webView.mediaPlaybackRequiresUserAction = NO;
    
    NSURL *url = [NSURL URLWithString: [self.params objectForKey: @"url"]];
    NSURLRequest *request =[NSURLRequest requestWithURL: url];
    [_webView loadRequest: request];
    [self.view addSubview: _webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)backWebTouchEvent {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        self.navigationItem.leftBarButtonItems = @[self.backItem, self.closeItem];
    } else {
        [self popWebTouchEvent];
    }
}

- (void)popWebTouchEvent {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - lazyloading
- (UIBarButtonItem *)backItem {
    if (!_backItem) {
        _backItem = [[UIBarButtonItem alloc] init];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@""];
        [btn setImage:image forState:UIControlStateNormal];
        [btn setTitle:@"返回" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(backWebTouchEvent) forControlEvents:UIControlEventTouchUpInside];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn sizeToFit];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.frame = CGRectMake(0, 0, 40, 40);
        _backItem.customView = btn;
    }
    return _backItem;
}

- (UIBarButtonItem *)closeItem {
    if (!_closeItem) {
        _closeItem = [[UIBarButtonItem alloc] init];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"关闭" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(popWebTouchEvent) forControlEvents:UIControlEventTouchUpInside];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn sizeToFit];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.frame = CGRectMake(40, 0, 40, 40);
        _closeItem.customView = btn;
    }
    return _closeItem;
}

- (UINavigationItem *)navigationItem {
    if (!_navigationItem) {
        _navigationItem = [[UINavigationItem alloc] init];
    }
    return _navigationItem;
}

- (MEBaseLabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[MEBaseLabel alloc] init];
        _titleLab.font = UIFontPingFangSC(20);
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

@end
