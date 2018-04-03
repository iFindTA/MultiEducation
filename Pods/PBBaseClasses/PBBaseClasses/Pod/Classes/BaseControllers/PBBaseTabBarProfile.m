//
//  PBBaseTabBarProfile.m
//  PBBaseClasses
//
//  Created by nanhujiaju on 2017/9/8.
//  Copyright © 2017年 nanhujiaju. All rights reserved.
//

#import "PBBaseTabBarProfile.h"
#import "PBBaseNavigationProfile.h"

@interface PBBaseTabBarProfile ()

@property (nonatomic, strong, readwrite) NSArray *mRootClasses;

@end

@implementation PBBaseTabBarProfile

- (id)initWithRootClasses:(NSArray<Class> *)cls {
    self = [super init];
    if (self) {
        NSAssert(cls.count != 0, @"root classes array should not be nil!");
        self.mRootClasses = [[NSArray alloc] initWithArray:cls];
    }
    return self;
}

+ (id)barWithSubClasses:(NSArray<Class> *)cls {
    NSAssert(cls.count != 0, @"root classes array should not be nil!");
    PBBaseTabBarProfile *tabBar = [[PBBaseTabBarProfile alloc] init];
    tabBar.mRootClasses = cls;
    [tabBar setupBaseRootControllers];
    return tabBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- custom root controllers

- (void)setupBaseRootControllers {
    if (self.mRootClasses.count == 0) {
        return;
    }
    NSEnumerator *enumrator = [self.mRootClasses objectEnumerator];
    Class aClass = nil;NSMutableArray *controllers = [NSMutableArray arrayWithCapacity:0];
    while (aClass = [enumrator nextObject]) {
        UIViewController *ctr = [[aClass alloc] init];
        if (ctr) {
            PBBaseNavigationProfile *naviCtr = [[PBBaseNavigationProfile alloc] initWithRootViewController:ctr];
            naviCtr.navigationBar.hidden = true;
            [controllers addObject:naviCtr];
        }
    }
    self.viewControllers = [controllers copy];
    [self setupMaxium];
}

#pragma mark -- custom badge

- (void)setupMaxium {
    NSArray<UITabBarItem *> *items = [self.tabBar items];
    UIColor *redColor = [UIColor redColor];
    UIColor *textColor = [UIColor whiteColor];
    [items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.badgeBgColor = redColor;
        obj.badgeTextColor = textColor;
        [obj setBadgeMaximumBadgeNumber:99];
    }];
}

- (void)updateBadgeStyle:(WBadgeStyle)style value:(NSUInteger)num atIndex:(NSUInteger)index {
    NSArray<UITabBarItem *> *items = [self.tabBar items];
    NSUInteger mCounts = items.count;
    if (index >= mCounts) {
        return;
    }
    UITabBarItem *barItem = items[index];
    [barItem showBadgeWithStyle:style value:num animationType:WBadgeAnimTypeNone];
}

- (void)clearBadgeAtIndex:(NSUInteger)index {
    NSArray<UITabBarItem *> *items = [self.tabBar items];
    NSUInteger mCounts = items.count;
    if (index >= mCounts) {
        return;
    }
    [items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (index == idx) {
            [obj clearBadge];
            *stop = true;
        }
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
