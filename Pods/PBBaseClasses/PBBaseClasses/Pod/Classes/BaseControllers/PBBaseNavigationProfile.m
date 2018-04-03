//
//  PBBaseNavigationProfile.m
//  PBBaseClasses
//
//  Created by nanhujiaju on 2017/9/8.
//  Copyright © 2017年 nanhujiaju. All rights reserved.
//

#import "PBBaseNavigationProfile.h"
#import <objc/message.h>

NSString * const PB_NAVISTACK_PUSH_SAME_SEL            =   @"classWhetherCanBePushedRepeatly";

@interface PBBaseNavigationProfile () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) dispatch_queue_t excuteQueue;

@end

@implementation PBBaseNavigationProfile

- (id)init {
    self = [super initWithNavigationBarClass:[UINavigationBar class] toolbarClass:nil];
    if (self) {
        //todo custom sub-views
    }
    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithNavigationBarClass:[UINavigationBar class] toolbarClass:nil];
    if (self) {
        self.viewControllers = @[rootViewController];
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)loadView {
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- override push method
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isExists = [self isClassExist4Instance:viewController];
    if (isExists) {
        SEL aSel = NSSelectorFromString(PB_NAVISTACK_PUSH_SAME_SEL);
        if ([viewController respondsToSelector:aSel]) {
            BOOL (*msgSend)(id, SEL) = (BOOL (*)(id, SEL))objc_msgSend;
            BOOL canRepeatly = msgSend(viewController, aSel);
            if (!canRepeatly) {
                return;
            }
        }
    }
    [super pushViewController:viewController animated:animated];
}

- (dispatch_queue_t)excuteQueue {
    if (!_excuteQueue) {
        _excuteQueue = dispatch_queue_create("com.flk.navigator-io.com", NULL);
    }
    
    return _excuteQueue;
}

- (BOOL)isClassExist4Instance:(UIViewController *)var {
    __block BOOL exist = false;
    
    NSArray <UIViewController *>*stacks = self.viewControllers;
    if (stacks.count > 0) {
        NSString *varClass = NSStringFromClass(var.class);
        UIViewController *tmpVar = [stacks lastObject];
        NSString *previousClass = NSStringFromClass(tmpVar.class);
        if (previousClass.length && [previousClass isEqualToString:varClass]) {
            exist = true;
        }
    }
    //    __block NSMutableString *aClassSets = [NSMutableString stringWithCapacity:0];
    //    [stacks enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //        [aClassSets appendString:NSStringFromClass(obj.class)];
    //    }];
    //    if (aClassSets.length > 0 && [aClassSets rangeOfString:NSStringFromClass(var.class)].location != NSNotFound) {
    //        exist = true;
    //    }
    
    return exist;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count <= 1 ) {
        return NO;
    }
    return YES;
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
