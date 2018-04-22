//
//  MENoticeProfile.m
//  HybridProject
//
//  Created by nanhu on 2018/4/21.
//  Copyright © 2018年 nanhu. All rights reserved.
//

#import "MENoticeProfile.h"

@interface MENoticeProfile ()

@end

@implementation MENoticeProfile

- (id)__initWithParams:(NSDictionary *)params {
    self = [super init];
    if (self) {
        NSString *startPage = [params objectForKey:ME_CORDOVA_KEY_STARTPAGE];
        NSString *wwwPath = [self wwwFolderPath];
        self.startPage = [wwwPath stringByAppendingPathComponent:startPage];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *back = [self barWithIconUnicode:@"\U0000e6e2" color:[UIColor whiteColor] eventSelector:@selector(cordovaNavigationBackEvent)];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"学校通知"];
    item.leftBarButtonItems = @[spacer, back];
    [self.navigationBar pushNavigationItem:item animated:true];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.commandDelegate evalJs:@"viewWillAppear&&viewWillAppear()"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
