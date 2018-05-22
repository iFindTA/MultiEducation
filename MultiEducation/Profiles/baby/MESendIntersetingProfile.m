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
#import "MEBabyIntersetingSelectView.h"
#import "Meclass.pbobjc.h"
#import "MestuFun.pbobjc.h"
#import "MEStuInterestVM.h"
#import "MEBabyIndexVM.h"
#import "MEQiniuUtils.h"
#import "MEStudentModel.h"

@interface MESendIntersetingProfile () <TZImagePickerControllerDelegate> {
    MEPBClass *_classPb;
    int64_t _stuId;
    
    NSArray *_submitPhotos;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) MESendIntersetContent *content;
@property (nonatomic, strong) TZImagePickerController *pickerProfile;

@end

@implementation MESendIntersetingProfile

- (instancetype)__initWithParams:(NSDictionary *)params {
    self = [super init];
    if (self) {
        self.didSubmitStuInterestCallback = [params objectForKey: ME_DISPATCH_KEY_CALLBACK];
        _classPb = [params objectForKey: @"classPb"];
        _stuId = [[params objectForKey: @"stuId"] longLongValue];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNavigation];
    [self.view addSubview: self.scrollView];
    [self.scrollView addSubview: self.content];

    //layout
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.navigationBar.mas_bottom);
    }];
    
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scrollView);
        make.width.mas_equalTo(self.scrollView);
        make.bottom.mas_equalTo(self.content.bottomView);
    }];
}

- (void)customNavigation {
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle: @"趣事趣影"];
    item.leftBarButtonItem = [MEKits defaultGoBackBarButtonItemWithTarget: self];
    item.rightBarButtonItem = [MEKits barWithTitle: @"发送" color: [UIColor whiteColor] target: self action: @selector(didSubmitButtonTouchEvent)];
    [self.navigationBar pushNavigationItem: item animated: false];
}

- (void)didSubmitButtonTouchEvent {
    if ([[self.content getInterestTitle]  isEqualToString: @""]) {
        [SVProgressHUD showErrorWithStatus: @"请输入标题"];
        return;
    }
    
    if ([[self.content getInterestContext]  isEqualToString: @""]) {
        [SVProgressHUD showErrorWithStatus: @"请输入内容"];
        return;
    }
    
    if (self.currentUser.userType == MEPBUserRole_Parent) {
        if (_stuId == 0) {
            if ([self.content getInterestingStuArr].count == 0) {
                [SVProgressHUD showErrorWithStatus: @"选择学生失败"];
                return;
            }
        }
    } else {
        if ([self.content getInterestingStuArr].count == 0) {
            [SVProgressHUD showErrorWithStatus: @"请选择学生"];
            return;
        }
    }
    
    if (_submitPhotos.count == 0) {
        [SVProgressHUD showErrorWithStatus: @"请选择图片"];
        return;
    }
    
    MEQiniuUtils *utils = [MEQiniuUtils sharedQNUploadUtils];
    [utils uploadImages: _submitPhotos callback:^(NSArray *succKeys, NSArray *failKeys, NSError *error) {
        if (error) {
            [MEKits handleError: error];
            return;
        }
        
        if (succKeys.count == 0) {
            [SVProgressHUD showErrorWithStatus: @"上传图片失败，请重新选择"];
            return;
        }
        
        GuFunPhotoPb *pb = [[GuFunPhotoPb alloc] init];
        pb.month = [MEBabyIndexVM fetchSelectBaby].month;
        pb.title = [self.content getInterestTitle];
        pb.funText = [self.content getInterestContext];
        
        if (self.currentUser.userType == MEPBUserRole_Parent) {
            pb.gradeId = [MEBabyIndexVM fetchSelectBaby].gradeId;
            GuFunPhotoStudentPb *stuPb = [[GuFunPhotoStudentPb alloc] init];
            stuPb.studentId = _stuId;
            [pb.studentListArray addObject: stuPb];
        } else {
            pb.gradeId = _classPb.gradeId;
            NSArray <MEStudentModel *> *stuArr = [self.content getInterestingStuArr];
            NSMutableArray <GuFunPhotoStudentPb *> *stuListArr = [NSMutableArray array];
            for (MEStudentModel *model in stuArr) {
                GuFunPhotoStudentPb *stuPb = [[GuFunPhotoStudentPb alloc] init];
                stuPb.studentId = model.stuId;
                [stuListArr addObject: stuPb];
            }
            pb.studentListArray = stuListArr;
        }
        
        for (NSString *key in succKeys) {
            GuFunPhotoImgPb *imgPb = [[GuFunPhotoImgPb alloc] init];
            imgPb.imgPath = key;
            [pb.imgListArray addObject: imgPb];
        }
        
        MEStuInterestVM *vm = [MEStuInterestVM vmWithPb: pb];
        [vm postData: [pb data] hudEnable: true success:^(NSData * _Nullable resObj) {
            [self.navigationController popViewControllerAnimated: true];
            if (self.didSubmitStuInterestCallback) {
                self.didSubmitStuInterestCallback();
            }
        } failure:^(NSError * _Nonnull error) {
            [MEKits handleError: error];
        }];
    }];
    
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    weakify(self);
    [self.content.selectedImages removeAllObjects];
    [self.content.selectedImages addObjectsFromArray: assets];
    [MEKits handleUploadPhotos: photos assets: assets checkDiskCap: NO completion:^(NSArray<NSDictionary *> * _Nullable images) {
        strongify(self);
        [self.content didSelectImagesOrVideo: images];
        self.pickerProfile = nil;
        _submitPhotos = images;
    }];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    weakify(self);
    [self.content.selectedImages removeAllObjects];
    
    [[TZImageManager manager] getVideoOutputPathWithAsset:asset presetName:AVAssetExportPreset640x480 success:^(NSString *outputPath) {
        strongify(self);
        NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
        NSData *data = [NSData dataWithContentsOfFile: outputPath];
        weakify(self);
        [MEKits handleUploadVideos: @[data] checkDiskCap: NO completion:^(NSArray<NSDictionary *> * _Nullable videos) {
            strongify(self);
            
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dic in videos) {
                NSMutableDictionary *video = [NSMutableDictionary dictionaryWithDictionary: dic];
                [video setObject: UIImageJPEGRepresentation(coverImage, 0.3f) forKey: @"coverImage"];
                [arr addObject: video];
            }
            
            [self.content didSelectImagesOrVideo: arr];
            self.pickerProfile = nil;
            _submitPhotos = videos;
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
        _content.semester = _classPb.semester;
        _content.classId = _classPb.id_p;
        _content.gradeId = _classPb.gradeId;
        [_content customSubviews];
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
        
        _pickerProfile.selectedAssets = self.content.selectedImages;
    }
    return _pickerProfile;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}

@end
