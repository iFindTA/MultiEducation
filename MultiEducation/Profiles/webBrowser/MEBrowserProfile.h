//
//  MEBabyWebProfile.h
//  fsc-ios-wan
//
//  Created by 崔小舟 on 2018/4/11.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEBaseProfile.h"
#import <WebKit/WebKit.h>

@interface MEBrowserProfile : MEBaseProfile

@property (nonatomic, strong) WKWebView *webView;

@end