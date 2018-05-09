//
//  MEPhotoBrowser.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/5/9.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEPhotoBrowser.h"
#import "MEKits.h"

@interface MEPhotoBrowser ()


@end

@implementation MEPhotoBrowser

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [MEKits defaultGoBackBarButtonItemWithTarget:self action:@selector(backBarItemTouchEvent)];
    self.navigationItem.rightBarButtonItem = [MEKits barWithTitle: @"宝宝相册" color: [UIColor whiteColor] target: self action: @selector(gotoBabyPhotoProfileTouchEvent)];
}

- (void)backBarItemTouchEvent {
    if (self.DidBackItemHandler) {
        self.DidBackItemHandler();
    }
}

- (void)gotoBabyPhotoProfileTouchEvent {
    if (self.DidGotoBabyPhotoProfileHandler) {
        self.DidGotoBabyPhotoProfileHandler();
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
