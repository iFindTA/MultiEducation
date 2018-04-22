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

- (id)init {
    self = [super init];
    if (self) {
        NSString *wwwPath = [self wwwFolderPath];
        self.startPage = [wwwPath stringByAppendingPathComponent:@"notice.html"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"学校通知";
    
    
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
