//
//  MEBaseScene.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/7.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseScene.h"
#import "MEUserVM.h"
#import "AppDelegate.h"
#import <UIView+Toast.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface MEBaseScene ()

@property (nonatomic, strong) UIActivityIndicatorView *indecator;

@end

@implementation MEBaseScene

- (void)dealloc {
//    NSLog(@"%@---dealloc", NSStringFromClass(self.class));
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.exclusiveTouch = true;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (AppDelegate *)appDelegate {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return delegate;
}
#pragma mark --- user relatives

- (MEPBUser * _Nullable)currentUser; {
    return [self appDelegate].curUser;
}

- (void)handleTransitionError:(NSError *)error {
    if (error) {
        NSDictionary *userInfo = [error userInfo];
        NSString *alertInfo = error.domain;
        if (userInfo) {
            alertInfo = [userInfo pb_stringForKey:NSLocalizedDescriptionKey];
        }
        [SVProgressHUD showErrorWithStatus:alertInfo];
    }
}

- (UIActivityIndicatorView *)indecator {
    if (!_indecator) {
        _indecator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indecator.hidesWhenStopped = true;
    }
    return _indecator;
}

- (void)showIndecator {
    [self addSubview:self.indecator];
    [self bringSubviewToFront:self.indecator];
    [self.indecator makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.indecator startAnimating];
}

- (void)hiddenIndecator {
    [self.indecator stopAnimating];
    [self.indecator removeFromSuperview];
    _indecator = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
