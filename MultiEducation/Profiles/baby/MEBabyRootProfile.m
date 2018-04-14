//
//  MEBabyRootProfile.m
//  fsc-ios
//
//  Created by nanhu on 2018/4/9.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEBabyRootProfile.h"
#import "MEBabyContent.h"
#import "MEBrowserProfile.h"
#import "MEDispatcher.h"

@interface MEBabyRootProfile ()

@property (nonatomic, strong) MEBabyContent *babyView;

@end

@implementation MEBabyRootProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //隐藏导航条
//    [self hiddenNavigationBar];
    
    [self.view addSubview: self.babyView];
    
    //layout
    [self.babyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - lazyloading
- (MEBabyContent *)babyView {
    if (!_babyView) {
        _babyView = [[MEBabyContent alloc] init];
    }
    return _babyView;
}


@end
