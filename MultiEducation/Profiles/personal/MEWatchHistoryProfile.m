//
//  MEWatchHistoryProfile.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/19.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEWatchItem.h"
#import "MEWatchHistoryProfile.h"

@interface MEWatchHistoryProfile ()

@end

@implementation MEWatchHistoryProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *backItem = [self backBarButtonItem:nil withIconUnicode:@"\U0000e6e2"];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"观看历史"];
    item.leftBarButtonItems = @[spacer, backItem];
    [self.navigationBar pushNavigationItem:item animated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchWarthingHistory];
}

- (void)fetchWarthingHistory {
    NSArray<MEWatchItem*>*items = [WHCSqlite query:[MEWatchItem class]];
    NSLog(@"观看个数:%zd", items.count);
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
