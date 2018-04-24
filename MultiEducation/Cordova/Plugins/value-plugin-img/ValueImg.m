
#import "MEKits.h"
#import "ValueImg.h"
#import "MEQiniuUtils.h"
#import "MEFileQuryVM.h"
#import <XHImageViewer/XHImageViewer.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <XHImageViewer/UIImageView+XHURLDownload.h>
#import <TZImagePickerController/TZImagePickerController.h>

@interface ValueImg () <XHImageViewerDelegate, TZImagePickerControllerDelegate, UploadImagesCallBack>

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
    [SVProgressHUD showInfoWithStatus:@"处理中..."];
    weakify(self)
    PBBACK(^{
        [MEKits handleUploadPhotos:photos assets:assets checkDiskCap:false completion:^(NSArray <NSDictionary*>* _Nullable images) {
            strongify(self)
            [self prepareFileMd54Query:images];
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
 预处理文件md5 处理完毕后询问后台服务器
 */
- (void)prepareFileMd54Query:(NSArray<NSDictionary*>*)images {
    if (images) {
        //拼接mds字符串
        NSMutableString *md5Strings = [NSMutableString stringWithCapacity:0];
        for (NSDictionary *map in images) {
            [md5Strings appendFormat:@"%@,", map[@"md5"]];
        }
        NSRange range = NSMakeRange(0, md5Strings.length - 1);
        NSString *md5String = md5Strings.copy;
        if (md5Strings.length > 0) {
            md5String = [md5Strings substringWithRange:range];
        }
        [self previewQueryOnlineServerWhetherFilesExist:md5String images:images];
    } else {
        [self endImagePickerActionWithNoResult:nil];
    }
}

- (void)previewQueryOnlineServerWhetherFilesExist:(NSString *)md5Files images:(NSArray<NSDictionary*>*)images {
    if (md5Files.length > 0) {
        MEFileQuryVM *vm = [[MEFileQuryVM alloc] init];
        MEPBQNFile *file = [[MEPBQNFile alloc] init];
        file.fileMd5Str = md5Files;
        [vm postData:[file data] hudEnable:false success:^(NSData * _Nullable resObj) {
            
        } failure:^(NSError * _Nonnull error) {
            
        }];
    }
}

- (void)uploadUserAvatar:(UIImage *)avatar {
    
}

- (void)uploadImageSuccess:(QNResponseInfo *)info key:(NSString *)key resp:(NSDictionary *)resp {
    
}

- (void)uploadImageFail:(QNResponseInfo *)info key:(NSString *)key resp:(NSDictionary *)resp {
    
}

@end
