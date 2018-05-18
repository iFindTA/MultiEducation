//
//  MESendIntersetingProfile.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/5/18.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MESendIntersetingProfile.h"
#import "MESendIntersetContent.h"
#import <TZImagePickerController.h>
#import <TZImageManager.h>

@interface MESendIntersetingProfile () <TZImagePickerControllerDelegate>

@property (nonatomic, strong) MESendIntersetContent *content;

@property (nonatomic, strong) TZImagePickerController *pickerProfile;

@end

@implementation MESendIntersetingProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNavigation];
    
    [self.view addSubview: self.content];
    //layout
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navigationBar.mas_bottom);
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];
}

- (void)customNavigation {
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle: @"趣事趣影"];
    item.leftBarButtonItem = [MEKits defaultGoBackBarButtonItemWithTarget: self];
    item.rightBarButtonItem = [MEKits barWithTitle: @"发送" color: [UIColor whiteColor] target: self action: @selector(didSubmitButtonTouchEvent)];
    [self.navigationBar pushNavigationItem: item animated: false];
}

- (void)didSubmitButtonTouchEvent {
    //FIXME: 发布趣事趣影
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    weakify(self);
    [MEKits handleUploadPhotos: photos assets: assets checkDiskCap: NO completion:^(NSArray<NSDictionary *> * _Nullable images) {
        strongify(self);
        [self.content didSelectImagesOrVideo: images];
        self.pickerProfile = nil;
    }];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    weakify(self);
    [[TZImageManager manager] getVideoOutputPathWithAsset:asset presetName:AVAssetExportPreset640x480 success:^(NSString *outputPath) {
        strongify(self);
        NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
        NSData *data = [NSData dataWithContentsOfFile: outputPath];
        weakify(self);
        [MEKits handleUploadVideos: @[data] checkDiskCap: NO completion:^(NSArray<NSDictionary *> * _Nullable videos) {
            strongify(self);
            [self.content didSelectImagesOrVideo: videos];
            self.pickerProfile = nil;
        }];
        
    } failure:^(NSString *errorMessage, NSError *error) {
        [MEKits handleError: error];
        NSLog(@"视频导出失败:%@,error:%@",errorMessage, error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - lazyloading
- (MESendIntersetContent *)content{
    if (!_content) {
        _content = [[MESendIntersetContent alloc] init];
        weakify(self);
        _content.DidPickerButtonTouchCallback = ^{
            strongify(self);
            [self.navigationController presentViewController: self.pickerProfile animated: true completion: nil];
        };
    }
    return _content;
}

- (TZImagePickerController *)pickerProfile {
    if (!_pickerProfile) {
        _pickerProfile = [[TZImagePickerController alloc] initWithMaxImagesCount: 9 delegate: self];
        _pickerProfile.allowPickingOriginalPhoto = NO;
        _pickerProfile.allowPickingVideo = YES;
    }
    return _pickerProfile;
}

@end
