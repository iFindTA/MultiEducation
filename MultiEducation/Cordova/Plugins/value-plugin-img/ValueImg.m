
#import "MEKits.h"
#import "ValueImg.h"
#import "MEQiniuUtils.h"
#import "MEFileQuryVM.h"
#import <XHImageViewer/XHImageViewer.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <XHImageViewer/UIImageView+XHURLDownload.h>
#import <TZImagePickerController/TZImagePickerController.h>

@interface ValueImg () <XHImageViewerDelegate, TZImagePickerControllerDelegate>

@property (nonatomic, strong, nullable) XHImageViewer *imageViewer;

@property (nonatomic, strong, nullable) CDVInvokedUrlCommand *currentCmd;

@end

@implementation ValueImg

- (void)show:(CDVInvokedUrlCommand *)command {
    NSArray<NSString*>*args = command.arguments;
    if (args.count > 0) {
        NSString *imgUrl = args.firstObject;
        UIImageView *imageview = [UIImageView imageViewWithURL:[NSURL URLWithString:imgUrl] autoLoading:true];
        [self.imageViewer showWithImageViews:@[imageview] selectedView:imageview];
    }
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

- (XHImageViewer *)imageViewer {
    if (!_imageViewer) {
        _imageViewer = [[XHImageViewer alloc] init];
        _imageViewer.delegate = self;
    }
    return _imageViewer;
}

#pragma mark --- Image Picker Delegate

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

@end
