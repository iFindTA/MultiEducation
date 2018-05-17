//
//  MEBabyInterest.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/5/17.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBabyInterestProfile.h"
#import "MEBabyInterestingContent.h"

@interface MEBabyInterestProfile ()

@property (nonatomic, strong) MEBabyInterestingContent *content;

@end

@implementation MEBabyInterestProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNavigation];
    [self.view addSubview: self.content];
   
}

- (void)customNavigation {
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle: @"趣事趣影"];
    item.leftBarButtonItem = [MEKits defaultGoBackBarButtonItemWithTarget: self];
    [self.navigationBar pushNavigationItem: item animated: false];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - lazyloading
- (MEBabyInterestingContent *)content {
    if (!_content) {
        _content = [[MEBabyInterestingContent alloc] initWithFrame: CGRectMake(0, ME_HEIGHT_NAVIGATIONBAR + [MEKits statusBarHeight], MESCREEN_WIDTH, adoptValue(488.f))];
        _content.items = @[@0, @1, @2];
        _content.pagingEnabled = true;
        _content.DidSelectCardHandler = ^(NSInteger index) {
            
        };
        
    }
    return _content;
}


@end
