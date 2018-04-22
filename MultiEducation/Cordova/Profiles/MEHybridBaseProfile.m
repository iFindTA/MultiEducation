//
//  MEHybridBaseProfile.m
//  HybridProject
//
//  Created by nanhu on 2018/4/21.
//  Copyright © 2018年 nanhu. All rights reserved.
//

#import "MEHybridBaseProfile.h"
#import <Cordova/CDVWebViewEngineProtocol.h>
#import <NJKWebViewProgress/NJKWebViewProgress.h>

@interface MEHybridBaseProfile ()

@property (nonatomic, strong) NJKWebViewProgress *progress;

@end

@implementation MEHybridBaseProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.progress = [[NJKWebViewProgress alloc] init];
    UIWebView *webView = (UIWebView *)self.webViewEngine.engineWebView;
    if (webView) {
        //webView.delegate = self.progress;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)sandboxPath {
    NSArray <NSString*>*paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
    return paths.firstObject;
}

- (NSString *)wwwFolderPath {
    return [[self sandboxPath] stringByAppendingPathComponent:@"www"];
}

- (NSURL *)appUrl {
    NSURL *appURL = [NSURL URLWithString:self.startPage];
    return appURL;
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
