//
//  PBBaseProfile.m
//  PBBaseClasses
//
//  Created by nanhujiaju on 2017/9/8.
//  Copyright © 2017年 nanhujiaju. All rights reserved.
//

#import "PBBaseProfile.h"
#import <objc/message.h>
#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS
#import <Masonry/Masonry.h>

static NSString * const PB_BASE_FONT               =   @"iconfont";

/**
 excute block func in main tread
 
 @param block to be excuted
 */
static void excuteMainBlock(void(^block)()) {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

/**
 vcr's view Presentation style
 */
typedef NS_ENUM(NSUInteger, PBViewPresentation) {
    PBViewPresentationPushed                   =   1   <<  0,
    PBViewPresentationPresented                =   1   <<  1
};

@interface PBBaseProfile ()

@property (nonatomic, assign) PBViewPresentation presentationMode;

@property (nonatomic, assign, readwrite) BOOL wetherInited;

@property (nonatomic, strong, readwrite) PBNavigationBar *navigationBar;

/**
 for iOS 11.0+
 */
@property (nonatomic, strong, readwrite) UIView *statusStretch;
@property (nonatomic, strong) MASConstraint *statusConstraint;

@end

@implementation PBBaseProfile

#pragma mark -- init url mediator router

- (BOOL)canOpenedByNativeUrl:(NSURL *)url {
    return false;
}

- (BOOL)canOpenedByRemoteUrl:(NSURL *)url {
    return false;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)loadView {
    [super loadView];
    if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
        //self.navigationController.navigationBarHidden = true;//disable swipe back gesture
        self.navigationController.navigationBar.hidden = true;
    }
    UINavigationBar *naviBar = [self initializedNavigationBar];
    [self.view addSubview:naviBar];
    self.navigationBar = naviBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.wetherInited = false;
    /*
    CGFloat status_bar_height = pb_expectedStatusBarHeight();
    UIColor *bgColor = pbColorMake(PB_NAVIBAR_BARTINT_HEX);
    UIView *stretch = [[UIView alloc] initWithFrame:CGRectZero];
    stretch.backgroundColor = bgColor;
    [self.view addSubview:stretch];
    self.statusStretch = stretch;
    weakify(self)
    [self.statusStretch mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(status_bar_height);
    }];
    [self.navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(self.view).priority(UILayoutPriorityDefaultHigh);
        if (!self.statusConstraint) {
            self.statusConstraint = make.top.equalTo(self.view).offset(status_bar_height).priority(UILayoutPriorityRequired);
        }
        [self.statusConstraint deactivate];
        make.left.right.equalTo(self.view);
        make.height.equalTo(PB_NAVIBAR_HEIGHT - PB_STATUSBAR_HEIGHT);
    }];
    
    if (@available(iOS 11.0, *)) {
        [self.statusConstraint activate];
    }
    //*/

    self.navigationController.sj_gestureType = SJFullscreenPopGestureType_Full;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (@available(iOS 11.0, *)) {
        [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
    }
    if (!_wetherInited) {
        //record presentaion mode
        BOOL isModal = false;
        if (self.navigationController != nil) {
            isModal = self.navigationController.isBeingPresented;
        } else {
            isModal = self.isBeingPresented;
        }
        self.presentationMode = 1<<(isModal?1:0);
        
        self.wetherInited = true;
    } else {
        
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self endEditingMode];
}

- (BOOL)isVisible {
    return (self.isViewLoaded && self.view.window != nil);
}

- (void)endEditingMode {
    [self.view endEditing:true];
}

#pragma mark -- custom navigation left back barItem

- (PBNavigationBar *)initializedNavigationBar {
    if (!_navigationBar) {
        //customize settings
        UIColor *tintColor = pbColorMake(PB_NAVIBAR_TINT_HEX);
        UIColor *barTintColor = pbColorMake(PB_NAVIBAR_BARTINT_HEX);//影响背景
        UIFont *font = [UIFont boldSystemFontOfSize:PBFontTitleSize + PBFONT_OFFSET];
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:tintColor, NSForegroundColorAttributeName,font,NSFontAttributeName, nil];
        CGRect barBounds = CGRectZero;
        PBNavigationBar *naviBar = [[PBNavigationBar alloc] initWithFrame:barBounds];
        naviBar.barStyle  = UIBarStyleBlack;
        //naviBar.backgroundColor = [UIColor redColor];
        UIImage *bgImg = [UIImage pb_imageWithColor:barTintColor];
        [naviBar setBackgroundImage:bgImg forBarMetrics:UIBarMetricsDefault];
        UIImage *lineImg = [UIImage pb_imageWithColor:pbColorMake(PB_NAVIBAR_SHADOW_HEX)];
        [naviBar setShadowImage:lineImg];// line
        naviBar.barTintColor = barTintColor;
        naviBar.tintColor = tintColor;//影响item字体
        [naviBar setTranslucent:false];
        [naviBar setTitleTextAttributes:attributes];//影响标题
        return naviBar;
    }
    
    return _navigationBar;
}

- (void)hiddenNavigationBar {
    [self.statusStretch removeFromSuperview];
    [self.navigationBar removeFromSuperview];
    /*
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    @synchronized (self.navigationBar) {
        [self.navigationBar.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:NSClassFromString(@"UIButton")]
                ||[obj isMemberOfClass:NSClassFromString(@"UIButton")]) {
                obj.alpha = 1;
            } else {
                obj.alpha = 0;
                
            }
        }];
    }
    [self printHierarchy4View:self.navigationBar];
    //*/
}

- (void)printHierarchy4View:(UIView *)view {
    if (view == nil) {
        return;
    }
    
    NSArray *subviews = [view subviews];
    if (subviews.count == 0) {
        return;
    }
    NSEnumerator *enumrator = [subviews objectEnumerator];
    UIView *tmp = nil;
    while (tmp = [enumrator nextObject]) {
        NSLog(@"viewClass:%@---subClass:%@",NSStringFromClass(view.class),NSStringFromClass(tmp.class));
    }
}

- (void)updateGesturePopStyle:(int)style {
    self.navigationController.sj_gestureType = style;
}

- (void)changeNavigationBarShadow2Color:(UIColor *)color {
    UIImage *lineImg = [UIImage pb_imageWithColor:color];
    [self.navigationBar setShadowImage:lineImg];// line
}

- (UIBarButtonItem *)barSpacer {
    UIBarButtonItem *barSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    barSpacer.width = - PB_BOUNDARY_MARGIN;
    return barSpacer;
}

- (UIBarButtonItem *)backBarButtonItem:(NSString * _Nullable)backTitle  withIconUnicode:(NSString * _Nullable)img {
    return [self backBarButtonItem:backTitle withIconUnicode:img withTarget:self withSelector:@selector(backBarItemTouchEvent)];
}

- (UIBarButtonItem *)backBarButtonItem:(NSString * _Nullable)backTitle withIconUnicode:(NSString * _Nullable)img withTarget:(nullable id)target withSelector:(nullable SEL)selector {
    NSString *defaultTitle = PBBASECLASSESString(@"PB_BASE_NAVIBAR_BACK_ITEM_TITLE");
    backTitle = PBIsEmpty(backTitle)?defaultTitle:backTitle;
    CGFloat fontSize = PBFontTitleSize;
    NSString *fontName = PB_BASE_FONT;
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    NSString *title = PBFormat(@"%@%@",img, backTitle);
    CGSize titleSize = [title pb_sizeThatFitsWithFont:font width:PBSCREEN_WIDTH];
    UIColor *fontColor = [UIColor pb_colorWithHexString:PB_NAVIBAR_TINT_STRING];
    //    CGFloat spacing = 2.f; // the amount of spacing to appear between image and title
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //btn.backgroundColor = [UIColor pb_randomColor];
    btn.frame = CGRectMake(0, 0, titleSize.width, 30);
    btn.exclusiveTouch = true;
    btn.titleLabel.font = font;
    //btn.translatesAutoresizingMaskIntoConstraints = false;
    //[btn setContentEdgeInsets:UIEdgeInsetsMake(13, 8, 13, 8)];
    //    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacin
    //    btn.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:fontColor forState:UIControlStateNormal];
    //[btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [barItem setTintColor:fontColor];
    return barItem;
}

- (UIBarButtonItem *)barWithIconUnicode:(NSString *)iconCode withTarget:(nullable id)target withSelector:(nullable SEL)selector {
    CGFloat itemSize = 28;
    CGFloat fontSize = PBFontTitleSize;
    NSString *fontName = PB_BASE_FONT;
    UIFont *font = [UIFont fontWithName:fontName size:fontSize * 2];
    UIColor *fontColor = [UIColor pb_colorWithHexString:PB_NAVIBAR_TINT_STRING];
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

- (UIBarButtonItem *)barWithIcon:(NSString *)icon withTarget:(nullable id)target withSelector:(nullable SEL)selector{
    UIColor *color = [UIColor pb_colorWithHexString:PB_NAVIBAR_TINT_STRING];
    return [self barWithIcon:icon withColor:color withTarget:target withSelector:selector];
}

- (UIBarButtonItem *)barWithIcon:(NSString *)icon withColor:(UIColor *)color withTarget:(nullable id)target withSelector:(nullable SEL)selector{
    return [self barWithIcon:icon withSize:PB_NAVIBAR_ITEM_SIZE withColor:color withTarget:target withSelector:selector];
}

- (UIBarButtonItem *)barWithIcon:(NSString *)icon withSize:(NSInteger)size withColor:(UIColor *)color withTarget:(nullable id)target withSelector:(nullable SEL)selector{
    UIImage *bar_img = [UIImage pb_iconFont:nil withName:icon withSize:size withColor:color];
    return [self assembleBar:bar_img withTarget:target withSelector:selector];
}

- (UIBarButtonItem *)barWithImage:(UIImage *)icon withTarget:(id)target withSelector:(SEL)selector {
    return [self barWithImage:icon withColor:nil withTarget:target withSelector:selector];
}

- (UIBarButtonItem *)barWithImage:(UIImage *)icon withColor:(UIColor *)color withTarget:(id)target withSelector:(SEL)selector {
    if (color != nil) {
        icon = [icon pb_darkColor:color lightLevel:1];
    }
    return [self assembleBar:icon withTarget:target withSelector:selector];
}

- (UIBarButtonItem *)assembleBar:(UIImage *)icon withTarget:(id)target withSelector:(SEL)selector {
    
    CGSize m_bar_size = {PB_NAVIBAR_ITEM_SIZE, PB_NAVIBAR_ITEM_SIZE};
    UIButton *menu = [UIButton buttonWithType:UIButtonTypeCustom];
    menu.frame = (CGRect){.origin = CGPointZero,.size = m_bar_size};
    [menu setImage:icon forState:UIControlStateNormal];
    [menu addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithCustomView:menu];
    return bar;
}

#pragma mark -- navigationBar event

- (void)backBarItemTouchEvent {
    if (self.presentationMode & PBViewPresentationPushed) {
        [self.navigationController popViewControllerAnimated:true];
    } else {
        [self dismissViewControllerAnimated:true completion:nil];
    }
}

- (void)defaultGoBackStack {
    [self backBarItemTouchEvent];
}

#pragma mark -- navigationBar stack change method

- (void)backStack2Class:(Class)aClass {
    if (aClass == nil) {
        return;
    }
    NSArray *tmps = self.navigationController.viewControllers;
    __block NSMutableArray *__tmp = [NSMutableArray array];
    [tmps enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:aClass] ||
            [obj isMemberOfClass:aClass] ||
            obj.class == aClass) {
            
            *stop = true;
        }
        [__tmp addObject:obj];
    }];
    [self.navigationController setViewControllers:[__tmp copy] animated:true];
}

- (void)replaceStack4Class:(Class)aClass {
    if (aClass == nil) {
        return;
    }
    
    UIViewController * m_instance = [[aClass alloc] init];
    if (m_instance) {
        [self replaceStack4Instance:m_instance];
    }
}

- (void)replaceStack4Instance:(UIViewController *)aInstance {
    NSArray *tmps = self.navigationController.viewControllers;
    __block NSMutableArray *__tmp = [NSMutableArray array];
    [tmps enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[self class]] ||
            [obj isMemberOfClass:[self class]] ||
            obj.class == self.class) {
            *stop = true;
        }else{
            [__tmp addObject:obj];
        }
    }];
    
    if (aInstance != nil) {
        [__tmp addObject:aInstance];
        [self.navigationController setViewControllers:[__tmp copy] animated:true];
    }
}

#pragma mark -- handle networking error

/**
 此方法在用户授权成功后调用，此时需要更新Authorization Token
 @attentions: this method need be implememented by the subClasses.
 */
- (void)resumeCMDWhileAfterUsrAuthorizeSuccess {
    
}

//push or present usr oauthor profiler

- (void)displayUserAuthorizationProfiler:(UIViewController *)ctr {
    if (!ctr) {
        return;
    }
    
    UINavigationController *naviCtr = self.navigationController;
    if (naviCtr) {
        [naviCtr pushViewController:ctr animated:true];
    } else {
        [self presentViewController:ctr animated:true completion:nil];
    }
}

- (void)handleNetworkingActivityError:(NSError *)error {
    if (error == nil) {
        return;
    }
    //deal with error logic!
    NSInteger code = error.code;
    if (code == 401) {     //need usr authorized
        NSString *selfClassStr = NSStringFromClass(self.class).lowercaseString;
        NSRange loginRange = [selfClassStr rangeOfString:@"login"];
        NSRange authorRange = [selfClassStr rangeOfString:@"author"];
        NSRange signRange = [selfClassStr rangeOfString:@"sign"];
        if (loginRange.location != NSNotFound || authorRange.location != NSNotFound || signRange.location != NSNotFound) {
            //self class is the login view
            excuteMainBlock(^{
                [SVProgressHUD showErrorWithStatus:error.domain];
            });
        } else {
            //TODO: need present login view, switch to login vcr
            
            /** Program 1: switch root view
             *
             *  must implement the selector:#switchRootView2AuthorProfiler for appDelegate class!!!
             *
             *  result:not the better
             
             AppDelegate *app = [self appDelegate];
             SEL aSelector = @selector(switchRootView2AuthorProfiler);
             if (app && [app respondsToSelector:aSelector]) {
             [app performSelectorOnMainThread:aSelector withObject:nil waitUntilDone:true];
             }
             */
            
            /** Program 2:present or push login by url mediator
             *
             *  use url mediator router
             *
             */
            NSString *urlString = [NSString stringWithFormat:@"%@://PBAuthorProfile/%@",PB_SAFE_SCHEME, PB_INIT_METHOD_PARAMS];
            NSURL *nativeURL = [NSURL URLWithString:urlString];
            __weak typeof(&*self) weakSelf = self;
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:weakSelf,PB_OBJC_CMD_TARGET, nil];
            UIViewController *authorProfiler = [[PBMediator shared] nativeCallWithURL:nativeURL withParams:params];
            [self displayUserAuthorizationProfiler:authorProfiler];
        }
    } else {
        // other error that unknown, also can report it to service
        excuteMainBlock(^{
            [SVProgressHUD showErrorWithStatus:error.domain];
        });
    }
}

- (void)showAlertWithTitle:(NSString *)title withMsg:(NSString *)msg whetherShowOK:(BOOL)okShow whetherShowCancel:(BOOL)cancelShow withOKItem:(NSString *)ok withOKCompletion:(void (^)())okBlock withCancelCompletion:(void (^)())cancelBlock {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    if (okShow) {
        NSString *okItem = ok.length == 0?@"确定":ok;
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:okItem style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (okBlock) {
                okBlock();
            }
        }];
        [alertController addAction:okAction];
    }
    if (cancelShow) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (cancelBlock) {
                cancelBlock();
            }
        }];
        [alertController addAction:cancelAction];
    }
    [self presentViewController:alertController animated:true completion:^{
        
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

#pragma mark == extern or export variables/functions

void checkNavigationStack(UIViewController *wk) {
    assert(wk.navigationController != nil);
}

CGFloat pb_expectedStatusBarHeight() {
    return [UIDevice pb_isiPhoneX] ? PB_STATUSBAR_HEIGHT_X : PB_STATUSBAR_HEIGHT;
}

void pb_adjustsScrollViewInsets(UIScrollView * scrollView) {
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if ([scrollView respondsToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {
        NSMethodSignature *signature = [UIScrollView instanceMethodSignatureForSelector:@selector(setContentInsetAdjustmentBehavior:)];;
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];;
        NSInteger argument = 2;;
        invocation.target = scrollView;;
        invocation.selector = @selector(setContentInsetAdjustmentBehavior:);;
        [invocation setArgument:&argument atIndex:2];;
        [invocation retainArguments];;
        [invocation invoke];;
    }
    #pragma clang diagnostic pop
}

NSString * const PB_STORAGE_DB_NAME                                         =   @"com.pb.nanhu.app.db";

NSString * const PB_ORG_KEYCHAIN_ACCESSGROUP                                =   @"YLAY7728KW.com.pb.nanhu.org-group";
NSString * const PB_ENT_KEYCHAIN_ACCESSGROUP                                =   @"ZCG75YJN57.com.pb.nanhu.ent-group";

NSString * const PB_CLIENT_DID_AUTHORIZED_NOTIFICATION                      =   @"com.pb.nanhu.app.notify-did.authorized";
NSString * const PB_CLIENT_DID_UNAUTHORIZED_NOTIFICATION                    =   @"com.pb.nanhu.app.notify-did.unauthorized";
