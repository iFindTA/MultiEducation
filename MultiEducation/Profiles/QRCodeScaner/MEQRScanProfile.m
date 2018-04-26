//
//  MEQRScanProfile.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/23.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "VKMsgSend.h"
#import "MEQRScanProfile.h"
#import <SCLAlertView-Objective-C/SCLAlertView.h>

#pragma mark -- PBLineAnimateView

@interface PBLineAnimator : UIImageView {
    int num;
    BOOL down;
    NSTimer * timer;
    
    BOOL isAnimating;
}

@property (nonatomic,assign) CGRect animationRect;

/**
 *  开始扫码线动画
 *
 *  @param animationRect 显示在parentView中得区域
 *  @param parentView    动画显示在UIView
 *  @param image     扫码线的图像
 */
- (void)startAnimatingWithRect:(CGRect)animationRect InView:(UIView*)parentView Image:(UIImage*)image;

/**
 *  停止动画
 */
- (void)stopAnimating;

@end

@implementation PBLineAnimator

- (void)stepAnimation {
    if (!isAnimating) {
        return;
    }
    
    CGFloat leftx = _animationRect.origin.x + 5;
    CGFloat width = _animationRect.size.width - 10;
    
    self.frame = CGRectMake(leftx, _animationRect.origin.y + 8, width, 8);
    
    self.alpha = 0.0;
    
    self.hidden = NO;
    
    __weak __typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:3 animations:^{
        CGFloat leftx = _animationRect.origin.x + 5;
        CGFloat width = _animationRect.size.width - 10;
        
        weakSelf.frame = CGRectMake(leftx, _animationRect.origin.y + _animationRect.size.height - 8, width, 4);
        
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [weakSelf performSelector:@selector(stepAnimation) withObject:nil afterDelay:0.3];
    }];
}

- (void)startAnimatingWithRect:(CGRect)animationRect InView:(UIView *)parentView Image:(UIImage*)image {
    if (isAnimating) {
        return;
    }
    
    isAnimating = YES;
    
    
    self.animationRect = animationRect;
    down = YES;
    num =0;
    
    CGFloat centery = CGRectGetMinY(animationRect) + CGRectGetHeight(animationRect)/2;
    CGFloat leftx = animationRect.origin.x + 5;
    CGFloat width = animationRect.size.width - 10;
    
    self.frame = CGRectMake(leftx, centery+2*num, width, 2);
    self.image = image;
    
    [parentView addSubview:self];
    
    [self startAnimating_UIViewAnimation];
    
}

- (void)startAnimating_UIViewAnimation {
    [self stepAnimation];
}

- (void)startAnimating_NSTimer {
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(scanLineAnimation) userInfo:nil repeats:YES];
}

-(void)scanLineAnimation {
    CGFloat centery = CGRectGetMinY(_animationRect) + CGRectGetHeight(_animationRect)/2;
    CGFloat leftx = _animationRect.origin.x + 5;
    CGFloat width = _animationRect.size.width - 10;
    
    if (down) {
        num++;
        
        self.frame = CGRectMake(leftx, centery+2*num, width, 2);
        
        if (centery+2*num > (CGRectGetMinY(_animationRect) + CGRectGetHeight(_animationRect) - 5 ) ) {
            down = NO;
        }
    } else {
        num --;
        self.frame = CGRectMake(leftx, centery+2*num, width, 2);
        if (centery+2*num < (CGRectGetMinY(_animationRect) + 5 ) )
        {
            down = YES;
        }
    }
}

- (void)dealloc {
    [self stopAnimating];
}

- (void)stopAnimating {
    if (isAnimating) {
        
        isAnimating = NO;
        
        if (timer != nil) {
            [timer invalidate];
            timer = nil;
        }
        
        [self removeFromSuperview];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

@end

#pragma mark -- PBScanView

@interface PBScanView : UIView

@property (nonatomic, assign) CGRect scanRetangleRect;
/**
 @brief  启动相机时 菊花等待
 */
@property (nonatomic, strong, nullable) UIActivityIndicatorView* activityView;

/**
 @brief  启动相机中的提示文字
 */
@property (nonatomic, strong, nullable) UILabel *labelReadying;

@property (nonatomic, strong, nullable) PBLineAnimator *lineAnimator;

- (void)startDeviceReadyingWithText:(NSString*)text;
- (void)stopDeviceReadying;
- (void)startScanAnimation;
- (void)stopScanAnimation;

@end

@implementation PBScanView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    int XRetangleLeft = 60;
    
    CGSize sizeRetangle = CGSizeMake(self.frame.size.width - XRetangleLeft*2, self.frame.size.width - XRetangleLeft*2);
    CGFloat whRatio = 1;
    //if (!isScanRetangelSquare)
    if (whRatio != 1) { //宽高比 正方形为1
        CGFloat w = sizeRetangle.width;
        CGFloat h = w / whRatio;
        
        NSInteger hInt = (NSInteger)h;
        h  = hInt;
        
        sizeRetangle = CGSizeMake(w, h);
    }
    
    //扫码区域Y轴最小坐标
    CGFloat centerUpOffset = -20.f;
    CGFloat YMinRetangle = self.frame.size.height / 2.0 - sizeRetangle.height/2.0 - centerUpOffset;
    CGFloat YMaxRetangle = YMinRetangle + sizeRetangle.height;
    CGFloat XRetangleRight = self.frame.size.width - XRetangleLeft;
    
    
    NSLog(@"frame:%@",NSStringFromCGRect(self.frame));
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //custom property
    BOOL isNeedShowRetangle = true;
    UIColor *colorRetangleLine = [UIColor whiteColor];
    UIColor *notRecoginitonArea = [UIColor colorWithRed:0. green:.0 blue:.0 alpha:.5];
    
    //非扫码区域半透明
    {
        //设置非识别区域颜色
        
        const CGFloat *components = CGColorGetComponents(notRecoginitonArea.CGColor);
        
        
        CGFloat red_notRecoginitonArea = components[0];
        CGFloat green_notRecoginitonArea = components[1];
        CGFloat blue_notRecoginitonArea = components[2];
        CGFloat alpa_notRecoginitonArea = components[3];
        
        
        CGContextSetRGBFillColor(context, red_notRecoginitonArea, green_notRecoginitonArea,
                                 blue_notRecoginitonArea, alpa_notRecoginitonArea);
        
        //填充矩形
        
        //扫码区域上面填充
        CGRect rect = CGRectMake(0, 0, self.frame.size.width, YMinRetangle);
        CGContextFillRect(context, rect);
        
        
        //扫码区域左边填充
        rect = CGRectMake(0, YMinRetangle, XRetangleLeft,sizeRetangle.height);
        CGContextFillRect(context, rect);
        
        //扫码区域右边填充
        rect = CGRectMake(XRetangleRight, YMinRetangle, XRetangleLeft,sizeRetangle.height);
        CGContextFillRect(context, rect);
        
        //扫码区域下面填充
        rect = CGRectMake(0, YMaxRetangle, self.frame.size.width,self.frame.size.height - YMaxRetangle);
        CGContextFillRect(context, rect);
        //执行绘画
        CGContextStrokePath(context);
    }
    
    if (isNeedShowRetangle) {
        //中间画矩形(正方形)
        CGContextSetStrokeColorWithColor(context, colorRetangleLine.CGColor);
        CGContextSetLineWidth(context, 1);
        
        CGContextAddRect(context, CGRectMake(XRetangleLeft, YMinRetangle, sizeRetangle.width, sizeRetangle.height));
        
        //CGContextMoveToPoint(context, XRetangleLeft, YMinRetangle);
        //CGContextAddLineToPoint(context, XRetangleLeft+sizeRetangle.width, YMinRetangle);
        
        CGContextStrokePath(context);
        
    }
    //扫描区域
    self.scanRetangleRect = CGRectMake(XRetangleLeft, YMinRetangle, sizeRetangle.width, sizeRetangle.height);
    
    
    //画矩形框4格外围相框角
    //相框角的宽度和高度
    int wAngle = 18;
    int hAngle = 18;
    //4个角的 线的宽度
    CGFloat linewidthAngle = 2;// 经验参数：6和4
    
    //画扫码矩形以及周边半透明黑色坐标参数
    CGFloat diffAngle = 0.0f;
    //diffAngle = linewidthAngle / 2; //框外面4个角，与框有缝隙
    //diffAngle = linewidthAngle/2;  //框4个角 在线上加4个角效果
    //diffAngle = 0;//与矩形框重合
    
    diffAngle = -linewidthAngle/2;
    UIColor *colorAngle = [UIColor colorWithRed:0./255 green:200./255. blue:20./255. alpha:1.0];
    CGContextSetStrokeColorWithColor(context, colorAngle.CGColor);
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, linewidthAngle);
    
    
    //
    CGFloat leftX = XRetangleLeft - diffAngle;
    CGFloat topY = YMinRetangle - diffAngle;
    CGFloat rightX = XRetangleRight + diffAngle;
    CGFloat bottomY = YMaxRetangle + diffAngle;
    
    //左上角水平线
    CGContextMoveToPoint(context, leftX-linewidthAngle/2, topY);
    CGContextAddLineToPoint(context, leftX + wAngle, topY);
    
    //左上角垂直线
    CGContextMoveToPoint(context, leftX, topY-linewidthAngle/2);
    CGContextAddLineToPoint(context, leftX, topY+hAngle);
    
    
    //左下角水平线
    CGContextMoveToPoint(context, leftX-linewidthAngle/2, bottomY);
    CGContextAddLineToPoint(context, leftX + wAngle, bottomY);
    
    //左下角垂直线
    CGContextMoveToPoint(context, leftX, bottomY+linewidthAngle/2);
    CGContextAddLineToPoint(context, leftX, bottomY - hAngle);
    
    
    //右上角水平线
    CGContextMoveToPoint(context, rightX+linewidthAngle/2, topY);
    CGContextAddLineToPoint(context, rightX - wAngle, topY);
    
    //右上角垂直线
    CGContextMoveToPoint(context, rightX, topY-linewidthAngle/2);
    CGContextAddLineToPoint(context, rightX, topY + hAngle);
    
    
    //右下角水平线
    CGContextMoveToPoint(context, rightX+linewidthAngle/2, bottomY);
    CGContextAddLineToPoint(context, rightX - wAngle, bottomY);
    
    //右下角垂直线
    CGContextMoveToPoint(context, rightX, bottomY+linewidthAngle/2);
    CGContextAddLineToPoint(context, rightX, bottomY - hAngle);
    
    CGContextStrokePath(context);
}

- (void)startDeviceReadyingWithText:(NSString*)text {
    int XRetangleLeft = 60;
    
    CGSize sizeRetangle = CGSizeMake(self.frame.size.width - XRetangleLeft*2, self.frame.size.width - XRetangleLeft*2);
    
    //    if (!_viewStyle.isNeedShowRetangle) {
    //
    //        CGFloat w = sizeRetangle.width;
    //        CGFloat h = w / _viewStyle.whRatio;
    //
    //        NSInteger hInt = (NSInteger)h;
    //        h  = hInt;
    //
    //        sizeRetangle = CGSizeMake(w, h);
    //    }
    
    //扫码区域Y轴最小坐标
    CGFloat centerUpOffset = -20.f;
    CGFloat YMinRetangle = self.frame.size.height / 2.0 - sizeRetangle.height/2.0 - centerUpOffset;
    
    //设备启动状态提示
    if (!_activityView) {
        self.activityView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_activityView setCenter:CGPointMake(XRetangleLeft +  sizeRetangle.width/2 - 50, YMinRetangle + sizeRetangle.height/2)];
        
        [_activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self addSubview:_activityView];
        
        CGRect labelReadyRect = CGRectMake(_activityView.frame.origin.x + _activityView.frame.size.width + 10, _activityView.frame.origin.y, 100, 30);
        self.labelReadying = [[UILabel alloc]initWithFrame:labelReadyRect];
        _labelReadying.backgroundColor = [UIColor clearColor];
        _labelReadying.textColor  = [UIColor whiteColor];
        _labelReadying.font = [UIFont systemFontOfSize:18.];
        _labelReadying.text = text;
        
        [self addSubview:_labelReadying];
        
        [_activityView startAnimating];
    }
    
}

- (void)stopDeviceReadying {
    if (_activityView) {
        
        [_activityView stopAnimating];
        [_activityView removeFromSuperview];
        [_labelReadying removeFromSuperview];
        
        self.activityView = nil;
        self.labelReadying = nil;
    }
}


/**
 *  开始扫描动画
 */
- (void)startScanAnimation {
    //线动画
    if (!self.lineAnimator) {
        self.lineAnimator = [[PBLineAnimator alloc] init];
    }
    UIImage *img = [UIImage imageNamed:@"qr_scan_line"];
    [self.lineAnimator startAnimatingWithRect:self.scanRetangleRect
                                       InView:self
                                        Image:img];
}

/**
 *  结束扫描动画
 */
- (void)stopScanAnimation {
    [self.lineAnimator stopAnimating];
}

@end

#pragma mark -- PBScanResult

@interface PBScanResult : NSObject

/**
 @brief  条码字符串
 */
@property (nonatomic, copy) NSString * codeInfo;
/**
 @brief  扫码码的类型,AVMetadataObjectType  如AVMetadataObjectTypeQRCode，AVMetadataObjectTypeEAN13Code等
 如果使用ZXing扫码，返回类型也已经转换成对应的AVMetadataObjectType
 */
@property (nonatomic, copy) NSString* codeType;

@end

@implementation PBScanResult

@end

#pragma mark -- PBScanEngine
@class PBScanEngine;
@protocol PBScanEngineDelegate <NSObject>

/**
 callback for engine
 
 @param engine that scan
 @param error null for successful!
 */
- (void)scanEngine:(PBScanEngine *)engine didScanQRCodeWithError:(NSError * _Nullable)error;

@end

@import AVFoundation;
@interface PBScanEngine : NSObject <AVCaptureMetadataOutputObjectsDelegate> {
    BOOL bNeedScanResult;
}

@property (nonatomic, copy, nullable) NSString *scanResult;
//扫码结果
@property (nonatomic, strong) NSMutableArray<PBScanResult *> *arrayResult;

@property (nonatomic, weak) id<PBScanEngineDelegate> scanDelegate;

//AV Params Configure
@property (assign, nonatomic) AVCaptureDevice * device;
@property (strong, nonatomic) AVCaptureDeviceInput * input;
@property (strong, nonatomic) AVCaptureMetadataOutput * output;
@property (strong, nonatomic) AVCaptureSession * session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;//拍照

/**
 @brief  视频预览显示视图
 */
@property (nonatomic,weak)UIView *videoPreView;

/**
 initialization method for scan engine
 
 @param preview for display preview-image in camera
 @param scanRect for scan scope, CGRectZero for full-screen scan
 @return engine
 */
- (instancetype)initWithPreview:(UIView *)preview withScanRect:(CGRect)scanRect;

@end

@implementation PBScanEngine

- (instancetype)initWithPreview:(UIView *)preview withScanRect:(CGRect)scanRect {
    self = [super init];
    if (self) {
        [self configureWithPreview:preview withRect:scanRect];
    }
    return self;
}

- (void)configureWithPreview:(UIView *)preview withRect:(CGRect)cropRect {
    self.videoPreView = preview;
    
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (!_device) {
        return;
    }
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    if ( !_input  )
        return ;
    
    
    bNeedScanResult = YES;
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    
    if (!CGRectEqualToRect(cropRect,CGRectZero)) {
        _output.rectOfInterest = cropRect;
    }
    
    // Setup the still image file output
    _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    AVVideoCodecJPEG, AVVideoCodecKey,
                                    nil];
    [_stillImageOutput setOutputSettings:outputSettings];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    // _session.
    
    // videoScaleAndCropFactor
    
    if ([_session canAddInput:_input]) {
        [_session addInput:_input];
    }
    
    if ([_session canAddOutput:_output]) {
        [_session addOutput:_output];
    }
    
    if ([_session canAddOutput:_stillImageOutput]) {
        [_session addOutput:_stillImageOutput];
    }
    
    
    
    
    // 条码类型 AVMetadataObjectTypeQRCode
    NSArray *objType = [self defaultMetaDataObjectTypes];
    _output.metadataObjectTypes = objType;
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    //_preview.frame =CGRectMake(20,110,280,280);
    
    CGRect frame = preview.frame;
    frame.origin = CGPointZero;
    _preview.frame = frame;
    [preview.layer insertSublayer:self.preview atIndex:0];
    
    
    AVCaptureConnection *videoConnection = [self connectionWithMediaType:AVMediaTypeVideo fromConnections:[[self stillImageOutput] connections]];
    //    CGFloat maxScale = videoConnection.videoMaxScaleAndCropFactor;
    CGFloat scale = videoConnection.videoScaleAndCropFactor;
    NSLog(@"%f",scale);
    //    CGFloat zoom = maxScale / 50;
    //    if (zoom < 1.0f || zoom > maxScale)
    //    {
    //        return;
    //    }
    //    videoConnection.videoScaleAndCropFactor += zoom;
    //    CGAffineTransform transform = videoPreView.transform;
    //    videoPreView.transform = CGAffineTransformScale(transform, zoom, zoom);
    
    //先进行判断是否支持控制对焦,不开启自动对焦功能，很难识别二维码。
    if (_device.isFocusPointOfInterestSupported &&[_device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        [_input.device lockForConfiguration:nil];
        [_input.device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        [_input.device unlockForConfiguration];
    }
}

#pragma mark -- Util Methods --

- (NSArray *)defaultMetaDataObjectTypes {
    NSMutableArray *types = [@[AVMetadataObjectTypeQRCode,
                               AVMetadataObjectTypeUPCECode,
                               AVMetadataObjectTypeCode39Code,
                               AVMetadataObjectTypeCode39Mod43Code,
                               AVMetadataObjectTypeEAN13Code,
                               AVMetadataObjectTypeEAN8Code,
                               AVMetadataObjectTypeCode93Code,
                               AVMetadataObjectTypeCode128Code,
                               AVMetadataObjectTypePDF417Code,
                               AVMetadataObjectTypeAztecCode] mutableCopy];
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_8_0)  {
        [types addObjectsFromArray:@[
                                     AVMetadataObjectTypeInterleaved2of5Code,
                                     AVMetadataObjectTypeITF14Code,
                                     AVMetadataObjectTypeDataMatrixCode
                                     ]];
    }
    
    return types;
}

- (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType fromConnections:(NSArray *)connections {
    for ( AVCaptureConnection *connection in connections ) {
        for ( AVCaptureInputPort *port in [connection inputPorts] ) {
            if ( [[port mediaType] isEqual:mediaType] ) {
                return connection;
            }
        }
    }
    return nil;
}

- (CGFloat)getVideoMaxScale {
    [_input.device lockForConfiguration:nil];
    AVCaptureConnection *videoConnection = [self connectionWithMediaType:AVMediaTypeVideo fromConnections:[[self stillImageOutput] connections]];
    CGFloat maxScale = videoConnection.videoMaxScaleAndCropFactor;
    [_input.device unlockForConfiguration];
    
    return maxScale;
}

- (void)setVideoScale:(CGFloat)scale {
    [_input.device lockForConfiguration:nil];
    
    AVCaptureConnection *videoConnection = [self connectionWithMediaType:AVMediaTypeVideo fromConnections:[[self stillImageOutput] connections]];
    
    CGFloat zoom = scale / videoConnection.videoScaleAndCropFactor;
    
    videoConnection.videoScaleAndCropFactor = scale;
    
    [_input.device unlockForConfiguration];
    
    CGAffineTransform transform = _videoPreView.transform;
    
    _videoPreView.transform = CGAffineTransformScale(transform, zoom, zoom);
}

- (void)setScanRect:(CGRect)scanRect {
    //识别区域设置
    if (_output) {
        _output.rectOfInterest = [self.preview metadataOutputRectOfInterestForRect:scanRect];
    }
}

- (void)changeScanType:(NSArray*)objType {
    _output.metadataObjectTypes = objType;
}

- (void)startScan {
    if ( _input && !_session.isRunning ) {
        [_session startRunning];
        bNeedScanResult = YES;
        
        [_videoPreView.layer insertSublayer:self.preview atIndex:0];
        
        // [_input.device addObserver:self forKeyPath:@"torchMode" options:0 context:nil];
    }
    bNeedScanResult = YES;
}

- (void)stopScan {
    bNeedScanResult = NO;
    if ( _input && _session.isRunning ) {
        bNeedScanResult = NO;
        [_session stopRunning];
    }
}

#pragma mark == AVCaptureMetadataOutputObjectsDelegate ==

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (!bNeedScanResult) {
        return;
    }
    
    bNeedScanResult = NO;
    //重置结果集
    if (!_arrayResult) {
        self.arrayResult = [NSMutableArray arrayWithCapacity:1];
    } else {
        [_arrayResult removeAllObjects];
    }
    
    //识别扫码类型
    for(AVMetadataObject *current in metadataObjects) {
        if ([current isKindOfClass:[AVMetadataMachineReadableCodeObject class]] ) {
            bNeedScanResult = NO;
            
            NSLog(@"type:%@",current.type);
            NSString *scannedResult = [(AVMetadataMachineReadableCodeObject *) current stringValue];
            if (scannedResult && ![scannedResult isEqualToString:@""]) {
                PBScanResult *result = [PBScanResult new];
                result.codeInfo = scannedResult;
                result.codeType = current.type;
                [_arrayResult addObject:result];
            }
            //测试可以同时识别多个二维码
        }
    }
    
    if (_arrayResult.count < 1) {
        bNeedScanResult = YES;
        return;
    }
    
    [self stopScan];
    if (self.scanDelegate && [self.scanDelegate respondsToSelector:@selector(scanEngine:didScanQRCodeWithError:)]) {
        [self.scanDelegate scanEngine:self didScanQRCodeWithError:nil];
    }
}

@end

@interface MEQRScanProfile ()<PBScanEngineDelegate>

@property (nullable, nonatomic, copy) void(^PBCodeScanCallBack)(NSError * _Nullable code);

@property (nonatomic, strong) PBScanView *scanView;
@property (nonatomic, strong) PBScanEngine *scanEngine;

@end

@implementation MEQRScanProfile

- (PBNavigationBar *)initializedNavigationBar {
    if (!self.navigationBar) {
        //customize settings
        UIColor *tintColor = pbColorMake(ME_THEME_COLOR_TEXT);
        UIColor *barTintColor = pbColorMake(0xFFFFFF);//影响背景
        UIFont *font = [UIFont boldSystemFontOfSize:PBFontTitleSize + PBFONT_OFFSET];
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:tintColor, NSForegroundColorAttributeName,font,NSFontAttributeName, nil];
        CGRect barBounds = CGRectZero;
        PBNavigationBar *naviBar = [[PBNavigationBar alloc] initWithFrame:barBounds];
        naviBar.barStyle  = UIBarStyleBlack;
        //naviBar.backgroundColor = [UIColor redColor];
        UIImage *bgImg = [UIImage pb_imageWithColor:barTintColor];
        [naviBar setBackgroundImage:bgImg forBarMetrics:UIBarMetricsDefault];
        UIImage *lineImg = [UIImage pb_imageWithColor:pbColorMake(PB_NAVIBAR_SHADOW_HEX)];
        [naviBar setShadowImage:lineImg];// line
        naviBar.barTintColor = barTintColor;
        naviBar.tintColor = tintColor;//影响item字体
        [naviBar setTranslucent:false];
        [naviBar setTitleTextAttributes:attributes];//影响标题
        
        return naviBar;
    }
    
    return self.navigationBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIColor *backColor = UIColorFromRGB(ME_THEME_COLOR_TEXT);
    UIBarButtonItem *spacer = [MEKits barSpacer];
    UIBarButtonItem *backItem = [MEKits defaultGoBackBarButtonItemWithTarget:self];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"扫一扫"];
    item.leftBarButtonItems = @[spacer, backItem];
    [self.navigationBar pushNavigationItem:item animated:true];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.scanView = [[PBScanView alloc] initWithFrame:self.view.bounds];
    [self.view insertSubview:self.scanView belowSubview:self.navigationBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scanView startDeviceReadyingWithText:@"相机启动中..."];
    //不延时，可能会导致界面黑屏并卡住一会
    [self performSelector:@selector(startScanAction) withObject:nil afterDelay:ME_ANIMATION_DURATION];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.scanEngine stopScan];
    [self.scanView stopScanAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clearResources {
    [self.scanView stopDeviceReadying];
}

- (void)alertWithError:(NSString *)error {
    UIAlertController *alertProfile = [UIAlertController alertControllerWithTitle:nil message:error preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertProfile addAction:action];
    [self presentViewController:alertProfile animated:true completion:^{
        
    }];
}

- (void)startScanAction {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted) {
        [self clearResources];
        [self alertWithError:@"请到设置隐私中开启本程序相机权限!"];
        return;
    } else if (status == AVAuthorizationStatusNotDetermined){
        
    }
    [self clearResources];
    
    UIView *videoView = [[UIView alloc] initWithFrame:self.view.bounds];
    videoView.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:videoView atIndex:0];
    //__weak __typeof(self) weakSelf = self;
    if (!self.scanEngine) {
        CGRect cropRect = CGRectZero;//全屏扫描
        //NSString *codeTyoe = AVMetadataObjectTypeQRCode;
        //AVMetadataObjectTypeITF14Code 扫码效果不行,另外只能输入一个码制，虽然接口是可以输入多个码制
        self.scanEngine = [[PBScanEngine alloc] initWithPreview:videoView withScanRect:cropRect];
        //[_scanObj setNeedCaptureImage:_isNeedScanImage];
        self.scanEngine.scanDelegate = self;
    }
    [self.scanEngine startScan];
    
    [self.scanView startScanAnimation];
    self.view.backgroundColor = [UIColor clearColor];
}

#pragma mark -- PBScanEngineDelegate

- (void)scanEngine:(PBScanEngine *)engine didScanQRCodeWithError:(NSError *)error {
    [self.scanView stopScanAnimation];
    PBScanResult *ret = [[engine arrayResult] firstObject];
    //        NSError *error = [NSError errorWithDomain:ret.codeInfo code:0 userInfo:nil];
    //        NSLog(@"扫描结果:%@", ret.codeInfo);
    [self handleQRScanResult:ret];
}

- (void)handleQRScanResult:(PBScanResult *)result {
//    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
//    [alert showWaiting:@"已处理" subTitle:@"loading" closeButtonTitle:nil duration:10];
    
    NSString *info = PBAvailableString(result.codeInfo);
    NSDictionary *params = nil;
    NSString *urlString = nil;NSDictionary * jsonMap = nil;
    NSData *data = [info dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        jsonMap = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    }
    UIViewController *profile;NSString *initMethod = @"__initWithParams:";NSString *destClassString;
    if (jsonMap) {
        NSString *type = [jsonMap pb_stringForKey:@"type"];
        if ([type isEqualToString:@"user"]) {
            
        } else if ([type isEqualToString:@"CHILDREN_TRAIN"]
                   ||[type isEqualToString:@"TEACHER_TRAIN"]
                   ||[type isEqualToString:@"TEACH_VIDEO"]
                   ||[type isEqualToString:@"ITEM"]) {
            
        } else if ([type isEqualToString:@"MEMBER"]) {
            
        } else {
            params = @{@"info":info};
            urlString = @"profile://root@MEQRResultProfile";
        }
    } else if ([info pb_isMatchRegexPattern:ME_REGULAR_URL]) {
        //whether url
        params = @{@"title":@"扫描结果", @"url":info};
        destClassString = @"MEBrowserProfile";
    }
    NSError *err;
    if (destClassString.length == 0) {
        destClassString = @"MEQRResultProfile";
        params = @{@"info":@"扫描结果不做处理！"};
    }
    profile = [destClassString VKCallClassAllocInitSelectorName:initMethod error:&err, params, nil];
    //urlString = @"profile://root@MEBrowserProfile";
    [self replaceStack4Instance:profile];
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
