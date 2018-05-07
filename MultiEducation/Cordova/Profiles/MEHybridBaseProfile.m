//
//  MEHybridBaseProfile.m
//  HybridProject
//
//  Created by nanhu on 2018/4/21.
//  Copyright © 2018年 nanhu. All rights reserved.
//

#import "ValueMore.h"
#import "MEWebProgress.h"
#import "MEHybridBaseProfile.h"
#import <Cordova/CDVWebViewEngineProtocol.h>
#import <IQKeyboardManager/IQKeyboardManager.h>

@interface MEHybridBaseProfile ()

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) MEWebProgress *progressProxy;

@property (nonatomic, strong, readwrite) PBNavigationBar *navigationBar;

@property (nonatomic, strong, readwrite) ValueMore *morePlugin;
@property (nonatomic, copy, nullable) NSString *moreAction;

@end

@implementation MEHybridBaseProfile

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CDVPluginResetNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CDVPageDidLoadNotification object:nil];
}

- (id)init {
    self = [super init];
    if (self) {
        [self registerPlugins];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.sj_fadeAreaViews = @[self.webView];
    /*
    [self.view addSubview:self.navigationBar];
    [self.navigationBar addSubview:self.progressView];
    [self.progressView makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.navigationBar);
        make.height.equalTo(ME_LAYOUT_LINE_HEIGHT * 2);
    }];
    
    self.webView.backgroundColor = [UIColor pb_randomColor];
    [self.webView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    //*/
    
    /*
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
    //*/
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cordovaWebViewDidStartLoad) name:CDVPluginResetNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cordovaWebViewDidFinishLoad) name:CDVPageDidLoadNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /*
    [IQKeyboardManager sharedManager].enable = false;
    [IQKeyboardManager sharedManager].enableAutoToolbar = false;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = true;
    */
    [self.commandDelegate evalJs:@"viewWillAppear&&viewWillAppear()"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    /*
    [IQKeyboardManager sharedManager].enable = true;
    [IQKeyboardManager sharedManager].enableAutoToolbar = true;
    */
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

- (MEWebProgress *)progressProxy {
    if (!_progressProxy) {
        _progressProxy = [[MEWebProgress alloc] init];
        weakify(self)
        _progressProxy.webProxyCallback = ^(CGFloat progress) {
            strongify(self)
            [self.progressView setProgress:progress animated:true];
        };
    }
    return _progressProxy;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectZero];
        _progressView.backgroundColor = UIColorFromRGB(ME_THEME_COLOR_VALUE);
        _progressView.tintColor = UIColorFromRGB(0xE15256);
    }
    return _progressView;
}

- (ValueMore *)morePlugin {
    if (!_morePlugin) {
        _morePlugin = [[ValueMore alloc] init];
    }
    return _morePlugin;
}

- (void)cordovaGoBackEvent {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)cordovaNavigationBackEvent {
    [self.commandDelegate evalJs:@"back()"];
}

- (void)cordovaNavigationMoreEvent {
    [self.commandDelegate evalJs:PBAvailableString(self.moreAction)];
}

#pragma mark --- MEWebProgress Delegate

- (void)cordovaWebViewDidStartLoad {
    self.progressView.hidden = false;
    
    [self.progressProxy reset];
    
    [self.progressProxy webviewDidStartLoad];
}

- (void)cordovaWebViewDidFinishLoad {
    [self.progressProxy webViewDidFinishLoad];
    
    [self.progressProxy reset];
    
    self.progressView.hidden = true;
}

#pragma mark --- Register plugins

- (void)registerPlugins {
    [self registerPlugin:self.morePlugin withClassName:@"ValueMore"];
}

#pragma mark --- outside user actions

- (void)updateMoreActionTitle:(NSString *)title callbackMethod:(NSString *)callback {
    NSArray<UINavigationItem*>*items = self.navigationBar.items;
    if (title.length == 0 || callback.length == 0) {
        [items enumerateObjectsUsingBlock:^(UINavigationItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.rightBarButtonItems = nil;
        }];
        return;
    }
    title = PBAvailableString(title);
    UIBarButtonItem *spacer = [MEKits barSpacer];
    UIBarButtonItem *more = [MEKits barWithTitle:title color:[UIColor whiteColor] target:self action:@selector(cordovaNavigationMoreEvent)];
    [items enumerateObjectsUsingBlock:^(UINavigationItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.rightBarButtonItems = @[more, spacer];
    }];
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
