
#import "MEKits.h"
#import "ValueImg.h"
#import "MEQiniuUtils.h"
#import "MEFileQuryVM.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <MWPhotoBrowser/MWPhotoBrowser.h>
#import <TZImagePickerController/TZImagePickerController.h>

@interface ValueImg () <TZImagePickerControllerDelegate, MWPhotoBrowserDelegate>

@property (nonatomic, strong, nullable) MWPhotoBrowser *photoBrowser;
@property (nonatomic, strong) NSMutableArray<MWPhoto*>*browserSource;

@property (nonatomic, strong, nullable) CDVInvokedUrlCommand *currentCmd;

@end

@implementation ValueImg

- (void)show:(CDVInvokedUrlCommand *)command {
    NSArray<NSString*>*args = command.arguments;
    if (args.count > 0) {
        [self.browserSource removeAllObjects];
        NSString *imgUrl = args.firstObject;
        NSLog(@"预览图片地址:%@", imgUrl);
        MWPhoto *photo = [[MWPhoto alloc] initWithURL:[NSURL URLWithString:imgUrl]];
        [self.browserSource addObject:photo];
        
        MWPhotoBrowser *photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate: self];
        //set options
        photoBrowser.displayActionButton = NO;//显示分享按钮(左右划动按钮显示才有效)
        photoBrowser.displayNavArrows = NO; //显示左右划动
        photoBrowser.displaySelectionButtons = NO; //是否显示选择图片按钮
        photoBrowser.alwaysShowControls = YES; //控制条始终显示
        photoBrowser.zoomPhotosToFill = YES; //是否自适应大小
        photoBrowser.enableGrid = NO;//是否允许网络查看图片
        photoBrowser.startOnGrid = NO; //是否以网格开始;
        photoBrowser.enableSwipeToDismiss = YES;
        photoBrowser.autoPlayOnAppear = NO;//是否自动播放视频
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:photoBrowser];
        [self.viewController.navigationController presentViewController: nav animated: true completion: nil];
    }
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:self.currentCmd.callbackId];
}

- (void)upload:(CDVInvokedUrlCommand *)command {
    NSArray*args = command.arguments;
    if (args.count > 0) {
        self.currentCmd = command;
        NSNumber *maxNumber = args.firstObject;
        TZImagePickerController *imagePickerProfile = [[TZImagePickerController alloc] initWithMaxImagesCount:maxNumber.integerValue delegate:self];
        imagePickerProfile.navigationBar.barTintColor = UIColorFromRGB(ME_THEME_COLOR_VALUE);
        imagePickerProfile.allowPickingVideo = false;
        if([maxNumber isEqualToNumber:@(-1)]){
            imagePickerProfile.showSelectBtn = false;
            imagePickerProfile.allowCrop = true;
        }
        [self.viewController presentViewController:imagePickerProfile animated:true completion:nil];
    }
}

#pragma mark --- lazy loading

- (MWPhotoBrowser *)photoBrowser {
    if (!_photoBrowser) {
        MWPhotoBrowser *photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate: self];
        //set options
        photoBrowser.displayActionButton = NO;//显示分享按钮(左右划动按钮显示才有效)
        photoBrowser.displayNavArrows = NO; //显示左右划动
        photoBrowser.displaySelectionButtons = NO; //是否显示选择图片按钮
        photoBrowser.alwaysShowControls = YES; //控制条始终显示
        photoBrowser.zoomPhotosToFill = YES; //是否自适应大小
        photoBrowser.enableGrid = NO;//是否允许网络查看图片
        photoBrowser.startOnGrid = NO; //是否以网格开始;
        photoBrowser.enableSwipeToDismiss = YES;
        photoBrowser.autoPlayOnAppear = NO;//是否自动播放视频
        _photoBrowser = photoBrowser;
    }
    return _photoBrowser;
}

- (NSMutableArray<MWPhoto*>*)browserSource {
    if (!_browserSource) {
        _browserSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _browserSource;
}

#pragma mark --- TZImage Picker Delegate

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    weakify(self)
    PBBACK(^{
        [SVProgressHUD showInfoWithStatus:@"处理中..."];
        [MEKits handleUploadPhotos:photos assets:assets checkDiskCap:false completion:^(NSArray <NSDictionary*>* _Nullable images) {
            strongify(self)
            [self uploadUserDidChooseAlbums:images];
        }];
    });
}

- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    [self endImagePickerActionWithNoResult:nil];
}

- (void)endImagePickerActionWithNoResult:(NSError *)err {
    CDVPluginResult *result;
    if (err) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:@{@"msg":err.domain}];
    } else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT];
    }
    [self.commandDelegate sendPluginResult:result callbackId:self.currentCmd.callbackId];
    [SVProgressHUD dismiss];
}

#pragma mark --- QiNiu Upload && Callbacks

/**
 调用上传接口
 */
- (void)uploadUserDidChooseAlbums:(NSArray<NSDictionary*>*)images {
    [SVProgressHUD showInfoWithStatus:@"上传中..."];
    weakify(self)
    [[MEQiniuUtils sharedQNUploadUtils] uploadImages:images callback:^(NSArray *succKeys, NSArray *failKeys, NSError *error) {
        strongify(self)
        if (error) {
            [self endImagePickerActionWithNoResult:error];
        } else {
            NSDictionary *dicResult = @{@"msg" : [self arrayToJsonString:succKeys]};
            NSLog(@"msg:%@", dicResult[@"msg"]);
            CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dicResult];
            [self.commandDelegate sendPluginResult:result callbackId:self.currentCmd.callbackId];
        }
        
        [SVProgressHUD dismiss];
    }];
}

- (NSString *)arrayToJsonString:(NSArray<NSString *> *)array {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

#pragma mark --- MWPhotoBrowser Delegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    NSUInteger counts = self.browserSource.count;
    return counts;
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.browserSource.count) {
        return self.browserSource[index];
    }
    return nil;
}

@end
