//
//  METemplateProfile.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/22.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "METemplateProfile.h"

@interface METemplateProfile ()

@property (nonatomic, strong) NSDictionary *params;

@end

@implementation METemplateProfile

- (id)__initWithParams:(NSDictionary *)params {
    self = [super init];
    if (self) {
        _params = [NSDictionary dictionaryWithDictionary:params];
        NSString *startPage = [params objectForKey:ME_CORDOVA_KEY_STARTPAGE];
        NSString *wwwPath = [self wwwFolderPath];
        self.startPage = [wwwPath stringByAppendingPathComponent:startPage];
        NSLog(@"cordova start page:%@", startPage);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *title = [self.params pb_stringForKey:ME_CORDOVA_KEY_TITLE];
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *back = [self barWithIconUnicode:@"\U0000e6e2" color:[UIColor whiteColor] eventSelector:@selector(cordovaNavigationBackEvent)];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:title];
    item.leftBarButtonItems = @[spacer, back];
    [self.navigationBar pushNavigationItem:item animated:true];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
