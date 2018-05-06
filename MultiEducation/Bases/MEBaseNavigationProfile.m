//
//  MEBaseNavigationProfile.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/5.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#define ME_ENABLED_PUSHING              0

#import "MEBaseNavigationProfile.h"

@interface MEBaseNavigationProfile () <UINavigationControllerDelegate>

@property (nonatomic, assign) BOOL isPushing;

@end

@implementation MEBaseNavigationProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
#if ME_ENABLED_PUSHING
    __weak typeof(self) weakSelf = self;
    self.delegate = weakSelf;
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- override super methods
#if ME_ENABLED_PUSHING
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (animated) {
        if (self.isPushing) {
            return;
        }
        self.isPushing = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (animated) {
        self.isPushing = NO;
    }
}
#endif

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
