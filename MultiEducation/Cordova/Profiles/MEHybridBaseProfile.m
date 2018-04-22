//
//  MEHybridBaseProfile.m
//  HybridProject
//
//  Created by nanhu on 2018/4/21.
//  Copyright © 2018年 nanhu. All rights reserved.
//

#import "MEHybridBaseProfile.h"
#import <Cordova/CDVWebViewEngineProtocol.h>
#import <NJKWebViewProgress/NJKWebViewProgress.h>

@interface MEHybridBaseProfile () <NJKWebViewProgressDelegate, UIWebViewDelegate>

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) NJKWebViewProgress *progressProxy;

@property (nonatomic, strong, readwrite) PBNavigationBar *navigationBar;

@end

@implementation MEHybridBaseProfile

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CDVPluginResetNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CDVPageDidLoadNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.navigationBar];
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectZero];
    [self.navigationBar addSubview:self.progressView];
    [self.progressView makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.navigationBar);
        make.height.equalTo(ME_LAYOUT_LINE_HEIGHT);
    }];
    
    self.webView.backgroundColor = [UIColor pb_randomColor];
    [self.webView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    self.progressProxy = [[NJKWebViewProgress alloc] init];
    weakify(self)
    self.progressProxy.progressBlock = ^(CGFloat progress) {
        strongify(self)
        [self.progressView setProgress:progress animated:false];
    };
    UIWebView *webView = (UIWebView *)self.webViewEngine.engineWebView;
    if (webView) {
        webView.delegate = self.progressProxy;
        self.progressProxy.webViewProxyDelegate = self;
        self.progressProxy.progressDelegate = self;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)documentsPath {
    NSArray <NSString*>*paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
    return paths.firstObject;
}

- (NSString *)wwwFolderPath {
    return [[self documentsPath] stringByAppendingPathComponent:@"www"];
}

- (NSURL *)appUrl {
    NSURL *appURL = [NSURL URLWithString:self.startPage];
    return appURL;
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark --- lazy loader

- (PBNavigationBar *)navigationBar {
    if (!_navigationBar) {
        //customize settings
        UIColor *tintColor = pbColorMake(0xFFFFFF);
        UIColor *barTintColor = pbColorMake(ME_THEME_COLOR_VALUE);//影响背景
        UIFont *font = UIFontPingFangSCBold(METHEME_FONT_LARGETITLE);
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:tintColor, NSForegroundColorAttributeName,font,NSFontAttributeName, nil];
        CGRect barBounds = CGRectZero;
        PBNavigationBar *naviBar = [[PBNavigationBar alloc] initWithFrame:barBounds];
        naviBar.barStyle  = UIBarStyleBlack;
        //naviBar.backgroundColor = [UIColor redColor];
        UIImage *bgImg = [UIImage pb_imageWithColor:barTintColor];
        [naviBar setBackgroundImage:bgImg forBarMetrics:UIBarMetricsDefault];
        UIImage *lineImg = [UIImage pb_imageWithColor:pbColorMake(0xE8E8E8)];
        [naviBar setShadowImage:lineImg];// line
        naviBar.barTintColor = barTintColor;
        naviBar.tintColor = tintColor;//影响item字体
        [naviBar setTranslucent:false];
        [naviBar setTitleTextAttributes:attributes];//影响标题
        //adjust frame
        CGFloat height = [naviBar barHeight];
        barBounds = CGRectMake(0, 0, MESCREEN_WIDTH, height);
        [naviBar setFrame:barBounds];
        _navigationBar = naviBar;
    }
    
    return _navigationBar;
}

- (UIBarButtonItem *)barSpacer {
    UIBarButtonItem *barSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    barSpacer.width = - ME_LAYOUT_MARGIN*3;
    return barSpacer;
}

- (UIBarButtonItem *)backBarWithColor:(UIColor *)color {
    return [self barWithIconUnicode:@"\U0000e6e2" color:color withTarget:self withSelector:@selector(cordovaGoBackEvent)];
}

- (UIBarButtonItem *)barWithIconUnicode:(NSString *)iconCode color:(UIColor *)color eventSelector:(nullable SEL)selector {
    return [self barWithIconUnicode:iconCode color:color withTarget:self withSelector:selector];
}

- (UIBarButtonItem *)barWithIconUnicode:(NSString *)iconCode color:(UIColor *)color withTarget:(nullable id)target withSelector:(nullable SEL)selector {
    CGFloat itemSize = 28;
    CGFloat fontSize = METHEME_FONT_TITLE;
    NSString *fontName = @"iconfont";
    UIFont *font = [UIFont fontWithName:fontName size:fontSize * 2];
    UIColor *fontColor = (color == nil)?[UIColor whiteColor]:color;
    //    CGFloat spacing = 2.f; // the amount of spacing to appear between image and title
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //btn.backgroundColor = [UIColor pb_randomColor];
    btn.frame = CGRectMake(0, 0, itemSize, itemSize);
    btn.exclusiveTouch = true;
    btn.titleLabel.font = font;
    //    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
    //    btn.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
    [btn setTitle:iconCode forState:UIControlStateNormal];
    [btn setTitleColor:fontColor forState:UIControlStateNormal];
    //[btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [barItem setTintColor:fontColor];
    return barItem;
}

- (void)cordovaGoBackEvent {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark --- NJKProgressView Delegate

- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
    [self.progressView setProgress:progress animated:false];
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
