//
//  MEPhotoSelectProfile.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/16.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEPhotoSelectProfile.h"
#import "MEPhotoProgressProfile.h"

@interface MEPhotoSelectProfile ()

@property (nonatomic, strong) MEPhotoProgressProfile *progressProfile;

@end

@implementation MEPhotoSelectProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self customNavigation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customNavigation {
    self.navigationItem.title = @"选择图片";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"上传" style: UIBarButtonItemStyleDone target:self action: @selector(uploadTouchEvent)];
}

- (void)uploadTouchEvent {
    [self.navigationController pushViewController: self.progressProfile animated: YES];
}

#pragma mark - lazyloading
- (MEPhotoProgressProfile *)progressProfile {
    if (!_progressProfile) {
        _progressProfile = [[MEPhotoProgressProfile alloc] initWithImages: nil];
    }
    return _progressProfile;
}

@end
