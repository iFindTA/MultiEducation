//
//  MEIndexProfile.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/5.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEIndexProfile.h"
#import "MEIndexSearchSence.h"

@interface MEIndexProfile ()

@property (nonatomic, strong) MEIndexSearchSence *searchSence;

@end

@implementation MEIndexProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"首页";
    
    UIButton * searchbar = [[UIButton alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 44.0f)];
    [searchbar setTintColor:[UIColor redColor]];
    [searchbar addTarget:self action:@selector(displaySearchSence) forControlEvents:UIControlEventTouchUpInside];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@""];
    item.titleView = searchbar;
    
//    UIBarButtonItem * searchButton = [[UIBarButtonItem alloc]initWithCustomView:searchbar];
//    item.rightBarButtonItem = searchButton;
    
    [self.navigationBar pushNavigationItem:item animated:true];
    
    self.searchSence = [[MEIndexSearchSence alloc] initWithFrame:CGRectZero];
    self.searchSence.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.searchSence];
    [self.searchSence mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.searchSence.hidden = true;
    [self.searchSence handleSearchBlock:^{
        [self hiddenSearchSence];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)displaySearchSence {
    self.searchSence.hidden = false;
    
    [self hideTabBar:true animated:true];
}

- (void)hiddenSearchSence {
    self.searchSence.hidden = true;
    
    [self hideTabBar:false animated:true];
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
