//
//  MEBabyWebProfile.m
//  fsc-ios-wan
//
//  Created by 崔小舟 on 2018/4/11.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEBrowserProfile.h"
#import "MEBaseLabel.h"

static CGFloat const PROGRESS_HEIGHT  = 3.f;

@interface MEBrowserProfile () <WKNavigationDelegate>

@property (nonatomic, strong) NSDictionary *params; //params;

@property (nonatomic, strong) UINavigationItem *navigationItem;

@property (nonatomic, strong) MEBaseLabel *titleLab;    //nav titlelab
@property (nonatomic, strong) UIBarButtonItem *backItem;  //go back web
@property (nonatomic, strong) UIBarButtonItem *closeItem;   //pop nav

@property (nonatomic, strong) UIProgressView *progress; //web load progress

@end

@implementation MEBrowserProfile

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
    
    [_progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.navigationBar.mas_bottom);
        make.height.mas_equalTo(PROGRESS_HEIGHT);
    }];
    
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
    
    [self.view addSubview: self.webView];
    [self.view addSubview: self.progress];
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

#pragma mark - WKWebView
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ([webView.URL.absoluteString hasPrefix:@"https://itunes.apple.com"]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progress.hidden = YES;
            [self.progress setProgress:0 animated:NO];
        }else {
            self.progress.hidden = NO;
            [self.progress setProgress:newprogress animated:YES];
        }
    }
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
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

- (UIProgressView *)progress {
    if(!_progress) {
        _progress = [[UIProgressView alloc] init];
        _progress.tintColor = [UIColor orangeColor];
        _progress.trackTintColor = [UIColor whiteColor];
        [self.view addSubview:_progress];
    }
    return _progress;
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] init];
        _webView.backgroundColor = [UIColor whiteColor];
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        
        NSURL *url = [NSURL URLWithString: [self.params objectForKey: @"url"]];
        NSURLRequest *request =[NSURLRequest requestWithURL: url];
        [_webView loadRequest: request];
    }
    return _webView;
}

@end
