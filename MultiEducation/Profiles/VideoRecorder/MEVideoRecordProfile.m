//
//  MEVideoRecordProfile.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/9.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEVideoRecordProfile.h"
#import "MEProgressView.h"
#import "MEVideoPreview.h"
#import "MEVideoRecorder.h"

@interface MEVideoRecordProfile () <MEVideoRecorderDelegate, MEVideoPreviewDelegate>

//runtime params;
@property (nonatomic, strong) NSDictionary *params;

@property (nonatomic, strong) MEVideoRecorder *recorder;
//@property (nonatomic, strong) MEProgressView *progressView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UIButton * recordBtn, *cancelBtn, *exchangeBtn;
@property (assign, nonatomic) BOOL                    allowRecord;//允许录制

@property (nonatomic, assign) CGFloat videoDuration;
@property (nonatomic, strong) MEVideoPreview *videoPreview;

@property (nonatomic, copy) MEVideoRecordBlock callback;

@end

@implementation MEVideoRecordProfile

- (instancetype)__initWithParams:(NSDictionary *)params {
    self = [super init];
    if (self) {
        self.params = [NSDictionary dictionaryWithDictionary:params];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.allowRecord = YES;
    
    [self hiddenNavigationBar];
    self.sj_fadeArea = @[[NSValue valueWithCGRect:self.view.bounds]];
    
    //开始 暂停
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *startImg = [UIImage imageNamed:[self imageBundleName:@"record"]];
    UIImage *pauseImg = [UIImage imageNamed:[self imageBundleName:@"record_pause"]];
    [btn setImage:startImg forState:UIControlStateNormal];
    [btn setImage:pauseImg forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(recordVideoEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    self.recordBtn = btn;
    CGFloat btnSize = 80;
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view).offset(-20);
        make.width.height.equalTo(btnSize);
    }];
    //取消按钮
    UIImage *img = [UIImage pb_iconFont:nil withName:@"\U0000e628" withSize:20 withColor:[UIColor whiteColor]];
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setImage:img forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelVideoRecordEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    self.cancelBtn = cancelBtn;
    [cancelBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.centerY.equalTo(self.recordBtn.mas_centerY);
        make.width.height.equalTo(btnSize * 0.5);
    }];
    /*切换按钮
    img = [UIImage pb_iconFont:nil withName:@"\U0000e608" withSize:20 withColor:[UIColor whiteColor]];
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:img forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(exchangeCameraVideoRecordEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    self.exchangeBtn = btn;
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.width.height.equalTo(btnSize * 0.3);
    }];
    
    //*/
    //progress
    /*
    MEProgressView *progress = [[MEProgressView alloc] initWithFrame:CGRectZero];
    progress.progressColor = pbColorMake(0xF8302E);
    progress.progressBgColor =pbColorMake(0xBABABA);
    progress.backgroundColor = pbColorMake(0x000000);
    progress.loadProgress = 0.f;
    progress.loadProgressColor = [UIColor greenColor];
    [self.view addSubview:progress];
    self.progressView = progress;
    [progress makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(5);
    }];
     //*/
    UIProgressView *progress = [[UIProgressView alloc] initWithFrame:CGRectZero];
    progress.tintColor = pbColorMake(0xF8302E);
    progress.backgroundColor = pbColorMake(0xBABABA);
    progress.progress = 0.f;
    [self.view addSubview:progress];
    self.progressView = progress;
    [progress makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(5);
    }];
    
    //preview
    self.videoPreview = [[MEVideoPreview alloc] initWithFrame:CGRectZero];
    self.videoPreview.hidden = true;
    self.videoPreview.delegate = self;
    [self.view addSubview:self.videoPreview];
    [self.videoPreview makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (BOOL)prefersStatusBarHidden {
    return true;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.recorder shutdown];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_recorder == nil) {
        [self.recorder previewLayer].frame = self.view.bounds;
        [self.view.layer insertSublayer:[self.recorder previewLayer] atIndex:0];
    }
    [self.recorder startUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - set、get方法
- (MEVideoRecorder *)recorder {
    if (_recorder == nil) {
        _recorder = [[MEVideoRecorder alloc] init];
        _recorder.delegate = self;
    }
    return _recorder;
}

- (NSString *)imageBundleName:(NSString *)name {
    if (!name) {
        return name;
    }
    return [NSString stringWithFormat:@"MEVideoRecorder.bundle/%@", name];
}

#pragma mark -- RecordEngineDelegate
- (void)recordProgress:(CGFloat)progress {
    if (progress >= 1) {
        self.allowRecord = NO;
        //自动停止录制
        self.videoPreview.hidden = false;
        self.recordBtn.selected = self.cancelBtn.hidden = false;
        self.videoDuration = self.recorder.currentRecordTime;
        progress = 0.f;//重置为0
        /*
        [self.recorder resetRecorderWithHandler:^(NSString *path) {
            PBMAINDelay(PBANIMATE_DURATION, ^{
                [self.videoPreview autoPlayWithVideoPath:path];
                [self.videoPreview autoPlay];
            });
        }];
        //*/
        
        NSString *path = [self.recorder videoPath];
        [self.recorder stopCaptureHandler:^(UIImage *movieImage) {
            [self.videoPreview autoPlayWithVideoPath:path];
            [self.videoPreview autoPlay];
        }];
    }
    self.progressView.progress = progress;
}

#pragma mark --- Preview Delegate

- (void)didTouchRecallWithPreview:(MEVideoPreview *)preview {
    self.allowRecord = true;
    [self.videoPreview setHidden:true];
    [self.videoPreview resetVideoPreview];
}

- (void)didTouchEnsureWithPreview:(MEVideoPreview *)preview {
    self.allowRecord = true;
    [self.videoPreview setHidden:true];
    [self.videoPreview resetVideoPreview];
    void (^paramsCallback)(NSString *, CGFloat) = self.params[ME_DISPATCH_KEY_CALLBACK];
    if (paramsCallback) {
        paramsCallback(self.recorder.videoPath.copy, self.videoDuration);
    } else {
        if (self.callback) {
            self.callback(self.recorder.videoPath.copy, self.videoDuration);
        }
    }
    
    [self cancelVideoRecordEvent];
}

#pragma mark --- Touch Events

- (void)cancelVideoRecordEvent {
    if (self.isBeingPresented) {
        [self dismissViewControllerAnimated:true completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:true];
    }
}

- (void)exchangeCameraVideoRecordEvent {
    
}

/**
 更新其他控件状态
 */
- (void)updateOtherControlState:(BOOL)recording {
    //self.exchangeBtn.hidden = recording;
    self.cancelBtn.hidden = recording;
}

//开始和暂停录制事件
- (void)recordVideoEvent:(UIButton *)sender {
    if (self.allowRecord) {
        self.recordBtn.selected = !self.recordBtn.selected;
        if (self.recordBtn.selected) {
            if (self.recorder.isCapturing) {
                [self.recorder resumeCapture];
            }else {
                [self.recorder startCapture];
            }
        }else {
            self.videoDuration = self.recorder.currentRecordTime;
            PBMAINDelay(PBANIMATE_DURATION, ^{
                self.videoPreview.hidden = false;
                self.progressView.progress = 0.f;
            });
            
//            [self.recorder resetRecorderWithHandler:^(NSString *path) {
//                [self.videoPreview autoPlayWithVideoPath:path];
//                
//            }];
            NSString *path = [self.recorder videoPath];
            [self.recorder stopCaptureHandler:^(UIImage *movieImage) {
                [self.videoPreview autoPlayWithVideoPath:path];
                [self.videoPreview autoPlay];
            }];
        }
        [self updateOtherControlState:self.recordBtn.selected];
    }
}

#pragma mark --- handle callback

- (void)handleVideoRecordCallback:(MEVideoRecordBlock)block {
    self.callback = [block copy];
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
