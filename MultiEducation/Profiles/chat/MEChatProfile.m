//
//  MEChatProfile.m
//  MultiEducation
//
//  Created by mac on 2018/4/20.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEChatProfile.h"
#import "MEChatVM.h"
#import <AVFoundation/AVFoundation.h>

static CGFloat VEDIO_WEIGHT = 120.f;

@interface MEChatProfile ()

@property (nonatomic, strong)   UIImagePickerController *pickerC;
@property (nonatomic, copy)     NSString *videoPathStr;
@property (nonatomic, strong)   NSURL *videoURL;
@property (nonatomic, strong)   UIView *bgView;

@end

@implementation MEChatProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- 扩展功能栏 ---
- (void)expandItemToPluginBoardView {
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"send_video"] title:@"拍摄" atIndex:3 tag:2001];
}

- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag {
    [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
    
    if (tag == 2001) {
        // 视频功能
        NSLog(@"视频功能....");
        [self openCamaro];
    }
}

// 开启摄像头,录制视频
- (void)openCamaro {
    
    // 如果拍摄的摄像头可用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // 将sourceType设为UIImagePickerControllerSourceTypeCamera代表拍照或拍视频
        _pickerC.sourceType = UIImagePickerControllerSourceTypeCamera;
        // 限定多媒体格式只为视频录制
        _pickerC.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*) kUTTypeMovie, (NSString*) kUTTypeVideo, nil];
        // 设置拍摄视频
        _pickerC.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
        // 设置拍摄高质量的视频
        _pickerC.videoQuality = UIImagePickerControllerQualityTypeHigh;
        // 设置最大录制时间
        _pickerC.videoMaximumDuration = 10;
        
    }else {
        NSLog(@"模拟器无法打开摄像头");
    }
    // 显示picker视图控制器
    [self presentViewController:_pickerC animated:YES completion:nil];
}

#pragma mark --- pickerController Delegate ---
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"结束成功,info=%@", info);
    // 获取用户拍摄的是照片还是视频
    NSString * mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage] && picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        // 判断是否为照片, 并且为刚拍摄的
        NSLog(@"照片,不做处理...");
    } else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        // 判断视频, 并且为刚拍摄的
        // 获取视频文件的url
        NSURL *mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
        __weak MEChatProfile *weakSelf = self;
        // 截取缩略图,设置消息内容大小
        UIImage *image = [MEChatVM thumbnailImageForVideo:mediaURL atTime:1];
        UIImage *contentImg = [MEChatVM imageCompressForSize:image targetSize:CGSizeMake(VEDIO_WEIGHT, VEDIO_WEIGHT)];
        weakSelf.videoPathStr = [NSString stringWithFormat:@"%@", mediaURL];

        // 转码从mov转码为mp4
        [self movFileTransformToMP4WithSourceUrl:mediaURL completion:^(NSString *Mp4FilePath) {
            // 不存入相册直接发送
            RCImageMessage *imageMsg = [[RCImageMessage alloc] init];
            imageMsg.imageUrl = weakSelf.videoPathStr;
            imageMsg.thumbnailImage = contentImg;
            [self sendMessage:imageMsg pushContent:@"视频"];
        }];
        
    }
    // 隐藏UIImagePickerController
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)movFileTransformToMP4WithSourceUrl:(NSURL *)sourceUrl completion:(void(^)(NSString *Mp4FilePath))comepleteBlock {
    /**
     *  mov格式转mp4格式
     */
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:sourceUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    NSLog(@"%@",compatiblePresets);
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
        
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *uniqueName = [NSString stringWithFormat:@"%@.mp4",[formatter stringFromDate:date]];
        NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString * resultPath = [documentPath stringByAppendingPathComponent:uniqueName];
        NSLog(@"output File Path : %@",resultPath);
        
        exportSession.outputURL = [NSURL fileURLWithPath:resultPath];
        //可以配置多种输出文件格式
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.shouldOptimizeForNetworkUse = YES;
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void) {
            //             dispatch_async(dispatch_get_main_queue(), ^{
            //                 [hud hideAnimated:YES];
            //             });
            switch (exportSession.status) {
                case AVAssetExportSessionStatusUnknown:
                    NSLog(@"AVAssetExportSessionStatusUnknown");
                    break;
                    
                case AVAssetExportSessionStatusWaiting:
                    NSLog(@"AVAssetExportSessionStatusWaiting");
                    break;
                    
                case AVAssetExportSessionStatusExporting:
                    NSLog(@"AVAssetExportSessionStatusExporting");
                    break;
                    
                case AVAssetExportSessionStatusCompleted:
                {
                    comepleteBlock(resultPath);
                    NSLog(@"mp4 file size:%lf MB",[NSData dataWithContentsOfURL:exportSession.outputURL].length/1024.f/1024.f);
                }
                    break;
                    
                case AVAssetExportSessionStatusFailed:
                    NSLog(@"AVAssetExportSessionStatusFailed");
                    break;
                    
                case AVAssetExportSessionStatusCancelled:
                    NSLog(@"AVAssetExportSessionStatusFailed");
                    break;
            }
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"用户取消的拍摄！");
    // 隐藏UIImagePickerController
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --- WillSendMessage ---
- (RCMessageContent *)willSendMessage:(RCMessageContent *)messageContent {
    if ([messageContent isKindOfClass:[RCImageMessage class]]) {
        RCImageMessage *imageMsg = (RCImageMessage *)messageContent;
        if (imageMsg.thumbnailImage.size.height == 120) {
            imageMsg.extra = self.videoPathStr;
            NSLog(@"imageMsg.extra=%@", imageMsg.extra);
            return imageMsg;
        }
    }
    return messageContent;
}

#pragma mark --- sendMedio 回调 ---
- (void)uploadMedia:(RCMessage *)message uploadListener:(RCUploadMediaStatusListener *)uploadListener {
    NSLog(@"message=%@, uploadListener=%@", message, uploadListener);
    
}

#pragma mark --- cell Delegate ---
- (void)didTapMessageCell:(RCMessageModel *)model {
    //    [super didTapMessageCell:model];
    if ([model.content isKindOfClass:[RCImageMessage class]]) {
        RCImageMessage *imageMsg = (RCImageMessage *)model.content;
        if (imageMsg.extra.length > 1) {
            NSLog(@"开始播放视频?! url=%@", imageMsg.extra);
            _videoPathStr = imageMsg.extra;
            [self playMov:imageMsg.extra];
            
        } else {
            [super didTapMessageCell:model];
        }
    } else {
        [super didTapMessageCell:model];
    }
    
}

- (void)didTapCellPortrait:(NSString *)userId {
    NSLog(@"点击头像,显示userID=%@", userId);
}

- (void)playMov:(NSString *)url {
    
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgView.backgroundColor = [UIColor lightGrayColor];
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        [window addSubview:_bgView];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToHidden:)];
    _bgView.userInteractionEnabled = YES;
    [_bgView addGestureRecognizer:tap];
    
}

- (void)tapToHidden:(UITapGestureRecognizer *)tap {
    if (_bgView) {
        [_bgView removeFromSuperview];
        _bgView = nil;
    }
    
}

@end
