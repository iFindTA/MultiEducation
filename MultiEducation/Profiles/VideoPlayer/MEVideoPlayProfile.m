//
//  MEVideoPlayProfile.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/7.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEVideoPlayProfile.h"
#import <ZFPlayer/ZFPlayer.h>
#import <MediaPlayer/MediaPlayer.h>

static CGFloat const ME_VIDEO_PLAYER_WIDTH_HEIGHT_SCALE                     =   16.f/9;

@interface MEVideoPlayProfile ()

@end

@implementation MEVideoPlayProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    MPVolumeView *volume = [[MPVolumeView alloc] initWithFrame:CGRectMake(100, 200, 50, 50)];
    [volume sizeToFit];
    [self.view addSubview:volume];
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
