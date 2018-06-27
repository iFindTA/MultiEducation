//
//  MEBabyArchiveProfile.m
//  MultiEducation
//
//  Created by nanhu on 2018/6/1.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBabyArchiveProfile.h"
#import "MEStudentsPanel.h"
#import "MEBabyInfoContent.h"
#import "MEParentInfoContent.h"
#import "MEBabyIndexVM.h"
#import "MebabyIndex.pbobjc.h"
#import "MEBabyIndexVM.h"
#import "MebabyIndex.pbobjc.h"
#import "MEBabyArchivesVM.h"
#import <TZImagePickerController.h>
#import "MEQiniuUtils.h"
#import "MEBabyInfoHeader.h"
#import "MEArchivesView.h"
#import "MEParentsInfoView.h"

#define COMPONENT_WIDTH adoptValue(320)
#define COMPONENT_HEIGHT adoptValue(480)

@interface MEBabyArchiveProfile () <TZImagePickerControllerDelegate> {
    GuStudentArchivesPb *_originArchivesPb;
    GuStudentArchivesPb *_curArchivesPb;
    BOOL _whetherEditArchives;  //用于判断pop时是否提示
    NSString *_selectedStudentPortrait; //从相册选中的头像
}

@property (nonatomic, strong) NSDictionary *params;

@property (nonatomic, strong) MEStudentsPanel *panel;
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) MEBaseScene *scrollContent;

@property (nonatomic, strong) MEBabyInfoContent *babyContent;
@property (nonatomic, strong) MEParentInfoContent *parentContent;

@property (nonatomic, strong) TZImagePickerController *pickerProfile;

@property (nonatomic, strong) UINavigationItem *item;

@end

@implementation MEBabyArchiveProfile

- (id)__initWithParams:(NSDictionary *)params {
    self = [super init];
    if (self) {
        _params = [NSDictionary dictionaryWithDictionary:params];
    }
    return self;
}

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

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.currentUser.userType == MEPBUserRole_Parent) {
        [self loadDataOfBabyArchives: 0];
    }
    
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *back = [MEKits barWithUnicode: @"\U0000e6e2" color: UIColorFromRGB(ME_THEME_COLOR_TEXT) target: self action: @selector(didBackItemTouchEvent)];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"宝宝档案"];
    _item = item;
    item.leftBarButtonItems = @[spacer, back];
    UIBarButtonItem *confirm = [MEKits barWithTitle: @"确认" color: UIColorFromRGB(ME_THEME_COLOR_TEXT) target: self action: @selector(putBabyArchives2Server)];
    item.rightBarButtonItems = @[confirm, spacer];
    [self.navigationBar pushNavigationItem:item animated:true];
    
    [self.view addSubview: self.scroll];
    [self.scroll addSubview: self.scrollContent];
    [self.scrollContent addSubview: self.babyContent];
    [self.scrollContent addSubview: self.parentContent];
    
    //layout
    if (self.currentUser.userType == MEPBUserRole_Parent) {
        [self.scroll mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(COMPONENT_HEIGHT);
            make.left.mas_equalTo(adoptValue(10.f));
            make.centerY.mas_equalTo(self.view.mas_centerY);
            make.width.mas_equalTo(MESCREEN_WIDTH - adoptValue(10));
        }];
    } else {
        [self configureStudentPanel];
        [self.scroll mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(COMPONENT_HEIGHT);
            make.top.mas_equalTo(self.panel.mas_bottom);
            make.left.mas_equalTo(adoptValue(10.f));
            make.width.mas_equalTo(MESCREEN_WIDTH - adoptValue(10));
        }];
    }
    
    [self.scrollContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scroll);
        make.height.mas_equalTo(COMPONENT_HEIGHT);
        make.width.greaterThanOrEqualTo(@0);
    }];
    
    [self.babyContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.scrollContent);
        make.bottom.mas_equalTo(self.scrollContent).mas_offset(-10);
        make.width.mas_equalTo(COMPONENT_WIDTH);
    }];
    [self.babyContent layoutIfNeeded];
    self.babyContent.layer.shadowColor = UIColorFromRGB(0x878787).CGColor;
    self.babyContent.layer.shadowOpacity = 0.6f;
    self.babyContent.layer.shadowOffset = CGSizeMake(-2.f, 6.0f);
    self.babyContent.layer.shadowRadius = 6.0f;
    self.babyContent.layer.masksToBounds = NO;

    [self.parentContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.babyContent.mas_right).mas_offset(17.f);
        make.top.mas_equalTo(self.scrollContent);
        make.bottom.mas_equalTo(self.scrollContent).mas_offset(-10);
        make.width.mas_equalTo(COMPONENT_WIDTH);
    }];
    self.parentContent.layer.shadowColor = UIColorFromRGB(0x878787).CGColor;
    self.parentContent.layer.shadowOpacity = 0.6f;
    self.parentContent.layer.shadowOffset = CGSizeMake(-2.f, 6.0f);
    self.parentContent.layer.shadowRadius = 6.0f;
    self.parentContent.layer.masksToBounds = NO;
    
    [self.scrollContent mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.parentContent.mas_right).mas_offset(17.f);
    }];
}

- (void)checkWhetherTextChanged {
    [self setCurrentStudentArchivesPb];
    if (_curArchivesPb.gender != _originArchivesPb.gender || ![_curArchivesPb.studentPortrait isEqualToString: _originArchivesPb.studentPortrait] || _curArchivesPb.birthday != _originArchivesPb.birthday || ![_curArchivesPb.studentName isEqualToString: _originArchivesPb.studentName] || _curArchivesPb.height != _originArchivesPb.height || _curArchivesPb.weight != _originArchivesPb.weight || ![_curArchivesPb.petName isEqualToString: _originArchivesPb.petName] || ![_curArchivesPb.nation isEqualToString: _originArchivesPb.nation] || ![_curArchivesPb.zodiac isEqualToString: _originArchivesPb.zodiac] || ![_curArchivesPb.bloodType isEqualToString: _originArchivesPb.bloodType] || _curArchivesPb.leftVision != _originArchivesPb.leftVision || _curArchivesPb.rightVision != _originArchivesPb.rightVision || _curArchivesPb.hemoglobin != _originArchivesPb.hemoglobin || ![_curArchivesPb.homeAddress isEqualToString: _originArchivesPb.homeAddress] || ![_curArchivesPb.fatherName isEqualToString: _originArchivesPb.fatherName] || ![_curArchivesPb.fatherMobile isEqualToString: _originArchivesPb.fatherMobile] || ![_curArchivesPb.fatherWorkUnit isEqualToString: _originArchivesPb.fatherWorkUnit] || ![_curArchivesPb.motherName isEqualToString: _originArchivesPb.motherName] || ![_curArchivesPb.motherMobile isEqualToString: _originArchivesPb.motherMobile] || ![_curArchivesPb.motherWorkUnit isEqualToString: _originArchivesPb.motherWorkUnit] || ![_curArchivesPb.warnItem isEqualToString: _originArchivesPb.warnItem]) {
        _whetherEditArchives = true;
    } else {
        _whetherEditArchives = false;
    }
}

- (void)setCurrentStudentArchivesPb {
    //gender
    if ([self.babyContent.header.genderView.title isEqualToString: @"男"]) {
        _curArchivesPb.gender = 1;
    } else {
        _curArchivesPb.gender = 2;
    }
    
    //portrait
    if (![_selectedStudentPortrait isEqualToString: @""]) {
        _curArchivesPb.studentPortrait = _selectedStudentPortrait;
    }
    
    //birthday
    int64_t birth = [MEKits DateString2TimeStampWithFormatter: @"yyyy-MM-dd" dateStr: self.babyContent.header.birthView.title];
    
    _curArchivesPb.birthday = birth < 0 ? 0 : birth;
    
    //name
    _curArchivesPb.studentName = self.babyContent.header.nameView.title;
    
    //height
    _curArchivesPb.height = [self.babyContent.heightView.title intValue];
    
    //weight
    _curArchivesPb.weight = [self.babyContent.weightView.title intValue];
    
    //nickname
    if ([self whetherNeedPutToServer: self.babyContent.nickView.title]) {
        _curArchivesPb.petName = self.babyContent.nickView.title;
    }
    
    //nation
    if ([self whetherNeedPutToServer: self.babyContent.nationView.title]) {
        _curArchivesPb.nation = self.babyContent.nationView.title;
    }
    
    //blood
    if ([self whetherNeedPutToServer: self.babyContent.bloodView.title]) {
        _curArchivesPb.bloodType = self.babyContent.bloodView.title;
    }
    
    //zodiac
    if ([self whetherNeedPutToServer: self.babyContent.zodiacView.title]) {
        _curArchivesPb.zodiac = self.babyContent.zodiacView.title;
    }
    
    //left eye
    _curArchivesPb.leftVision = [self.babyContent.leftEyeView.title floatValue];
    
    //right eye
    _curArchivesPb.rightVision = [self.babyContent.rightEyeView.title floatValue];
    
    //HGB
    _curArchivesPb.hemoglobin = [self.babyContent.HGBView.title intValue];
    
    //home address
    if ([self whetherNeedPutToServer: self.babyContent.addressView.title]) {
        _curArchivesPb.homeAddress = self.babyContent.addressView.title;
    }
    
    //dadname
    if ([self whetherNeedPutToServer: self.parentContent.dadView.nameTextField.text]) {
        _curArchivesPb.fatherName = self.parentContent.dadView.nameTextField.text;
    }
    
    //dadphone
    if ([self whetherNeedPutToServer: self.parentContent.dadView.phoneTextField.text]) {
        _curArchivesPb.fatherMobile = self.parentContent.dadView.phoneTextField.text;
    }
    
    //dad address
    if ([self whetherNeedPutToServer: self.parentContent.dadView.addressTextField.text]) {
        _curArchivesPb.fatherWorkUnit = self.parentContent.dadView.addressTextField.text;
    }
    
    //momname
    if ([self whetherNeedPutToServer: self.parentContent.momView.nameTextField.text]) {
        _curArchivesPb.motherName = self.parentContent.momView.nameTextField.text;
    }
    
    //momphone
    if ([self whetherNeedPutToServer: self.parentContent.momView.phoneTextField.text]) {
        _curArchivesPb.motherMobile = self.parentContent.momView.phoneTextField.text;
    }
    
    //mom address
    if ([self whetherNeedPutToServer: self.parentContent.momView.addressTextField.text]) {
        _curArchivesPb.motherWorkUnit = self.parentContent.momView.addressTextField.text;
    }
    
    //tip
    if (![self.parentContent.tipTextView.text isEqualToString: WARN_ITEM_DEFAULT_PLACEHOLDER]) {
        _curArchivesPb.warnItem = self.parentContent.tipTextView.text;
    } else {
        _curArchivesPb.warnItem = @"";
    }
}

- (void)didBackItemTouchEvent {
    [self checkWhetherTextChanged];
    if (!_whetherEditArchives) {
        [self.navigationController popViewControllerAnimated: true];
        return;
    }
    UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"提示" message: @"您有未提交的修改信息，确定离开吗？" preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *certain = [UIAlertAction actionWithTitle: @"保存" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self putBabyArchives2Server];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle: @"离开" style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated: true];
    }];
    [controller addAction: certain];
    [controller addAction: cancel];
    [self presentViewController: controller animated: true completion: nil];
}

- (void)loadDataOfBabyArchives:(NSInteger)stuId {
    if (self.currentUser.userType == MEPBUserRole_Parent) {
        GuIndexPb *indexBb = [MEBabyIndexVM fetchSelectBaby];
        GuStudentArchivesPb *pb = [[GuStudentArchivesPb alloc] init];
        pb.studentId = indexBb.studentArchives.studentId;
        MEBabyArchivesVM *vm = [MEBabyArchivesVM vmWithPb: pb cmdCode: @"GU_STUDENT_ARCHIVES_GET"];
        [vm postData: [pb data] hudEnable: true success:^(NSData * _Nullable resObj) {
            GuStudentArchivesPb *pb = [GuStudentArchivesPb parseFromData: resObj error: nil];
            _curArchivesPb = pb;
            _originArchivesPb = [GuStudentArchivesPb parseFromData: resObj error: nil];
            _selectedStudentPortrait = pb.studentPortrait;
            [self.babyContent setData: pb];
            [self.parentContent setData: pb];
        } failure:^(NSError * _Nonnull error) {
            [self makeToast: error.description];
        }];
    } else {
        GuStudentArchivesPb *pb = [[GuStudentArchivesPb alloc] init];
        pb.studentId = stuId;
        MEBabyArchivesVM *vm = [MEBabyArchivesVM vmWithPb: pb cmdCode: @"GU_STUDENT_ARCHIVES_GET"];
        [vm postData: [pb data] hudEnable: true success:^(NSData * _Nullable resObj) {
            GuStudentArchivesPb *pb = [GuStudentArchivesPb parseFromData: resObj error: nil];
            _curArchivesPb = pb;
            NSLog(@"------birthday-----%lld", pb.birthday);
            _originArchivesPb = [GuStudentArchivesPb parseFromData: resObj error: nil];
            _selectedStudentPortrait = pb.studentPortrait;
            [self.babyContent setData: pb];
            [self.parentContent setData: pb];
        } failure:^(NSError * _Nonnull error) {
            [self makeToast: error.description];
        }];
    }
}

- (BOOL)whetherNeedPutToServer:(NSString *)text {
    if ([text isEqualToString: @""] || text == nil || [text isEqualToString: @"-"]) {
        return false;
    } else {
        return true;
    }
}

- (void)putBabyArchives2Server {
    MEBabyArchivesVM *vm = [MEBabyArchivesVM vmWithPb: _curArchivesPb cmdCode: @"GU_STUDENT_ARCHIVES_PUT"];
    [self setCurrentStudentArchivesPb];
    
    if (self.currentUser.userType == MEPBUserRole_Parent) {
        if ([_curArchivesPb.fatherName isEqualToString: @""] || [_curArchivesPb.fatherMobile isEqualToString: @""] || [_curArchivesPb.fatherWorkUnit isEqualToString: @""] || [_curArchivesPb.motherName isEqualToString: @""] || [_curArchivesPb.motherMobile isEqualToString: @""] || [_curArchivesPb.motherWorkUnit isEqualToString: @""]) {
            [MEKits makeTopToast: @"请输入家长信息"];
            return;
        }
    }
    
    if ([_curArchivesPb.studentName isEqualToString: @""] || _curArchivesPb.studentName == nil) {
        [MEKits makeTopToast: @"请输入宝宝姓名！"];
        return;
    }
    
    if (_curArchivesPb.studentName.length >= 20) {
        [MEKits makeTopToast: @"请输入正确格式的宝宝名字"];
        return;
    }
    
    if (!PBIsEmpty(_curArchivesPb.fatherMobile)) {
        if (![_curArchivesPb.fatherMobile pb_isMatchRegexPattern: ME_REGULAR_MOBILE]) {
            [MEKits makeTopToast: @"请输入正确格式的爸爸手机号!"];
            return;
        }
    }
    
    if (!PBIsEmpty(_curArchivesPb.motherMobile)) {
        if (![_curArchivesPb.motherMobile pb_isMatchRegexPattern: ME_REGULAR_MOBILE]) {
            [MEKits makeTopToast: @"请输入正确格式的妈妈手机号!"];
            return;
        }
    }
    
    if (_curArchivesPb.height >= 161) {
        [MEKits makeTopToast: @"请输入正确的宝宝身高！"];
        return;
    }
    
    if (_curArchivesPb.weight >= 101) {
        [MEKits makeTopToast: @"请输入正确的宝宝体重！"];
        return;
    }
    
    if (_curArchivesPb.leftVision >= 5.4) {
        [MEKits makeTopToast: @"请输入正确的宝宝左眼视力！"];
        return;
    }
    
    if (_curArchivesPb.rightVision >= 5.4) {
        [MEKits makeTopToast: @"请输入正确的宝宝右眼视力！"];
        return;
    }

    weakify(self);
    [vm postData: [_curArchivesPb data] hudEnable: true success:^(NSData * _Nullable resObj) {
        strongify(self);
        _originArchivesPb = _curArchivesPb;
        [MEKits makeTopToast: @"修改宝宝档案成功！"];
        [self.panel updateStudent: _curArchivesPb.studentId name:_curArchivesPb.studentName avatar: _curArchivesPb.studentPortrait];
        _whetherEditArchives = false;
    } failure:^(NSError * _Nonnull error) {
        [MEKits makeToast: error.description];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    UIImage *image = photos[0];
    MEQiniuUtils *utils = [MEQiniuUtils sharedQNUploadUtils];
    weakify(self);
    [MEKits handleUploadPhotos: @[image] assets: assets checkDiskCap: NO completion:^(NSArray<NSDictionary *> * _Nullable images) {
        strongify(self);
        [utils uploadImages: images  callback:^(NSArray *succKeys, NSArray *failKeys, NSError *error) {
            NSString *portrait = succKeys[0];
            weakify(self);
            _selectedStudentPortrait = portrait;
            [self.babyContent changeBabyPortrait: portrait];
        }];
    }];
}

#pragma mark - lazyloading
- (UIScrollView *)scroll {
    if (!_scroll) {
        _scroll = [[UIScrollView alloc] initWithFrame: CGRectZero];
        _scroll.backgroundColor = [UIColor whiteColor];
        _scroll.showsHorizontalScrollIndicator = false;
        _scroll.pagingEnabled = true;
    }
    return _scroll;
}

- (MEBabyInfoContent *)babyContent {
    if (!_babyContent) {
        _babyContent = [[MEBabyInfoContent alloc] initWithFrame: CGRectZero];
        weakify(self);
        _babyContent.didTapPortraitCallback = ^{
            strongify(self);
            [self.navigationController presentViewController: self.pickerProfile animated: true completion: nil];
        };
    }
    return _babyContent;
}

- (MEParentInfoContent *)parentContent {
    if (!_parentContent) {
        _parentContent = [[MEParentInfoContent alloc] initWithFrame: CGRectZero];
    }
    return _parentContent;
}

- (MEBaseScene *)scrollContent {
    if (!_scrollContent) {
        _scrollContent = [[MEBaseScene alloc] initWithFrame: CGRectZero];
        _scrollContent.backgroundColor = [UIColor whiteColor];
    }
    return _scrollContent;
}

- (void)configureStudentPanel {
    _panel = [MEStudentsPanel panelWithSuperView: self.view topMargin: self.navigationBar];
    _panel.autoScrollNext = false;
    _panel.classID = [[self.params objectForKey: @"classId"] integerValue];
    _panel.gradeID = [[self.params objectForKey: @"gradeId"] integerValue];
    _panel.semester = [[self.params objectForKey: @"semester"] integerValue];

    [self.view insertSubview:_panel belowSubview: self.navigationBar];
    [self.view insertSubview:_panel aboveSubview: self.scroll];
    [_panel loadAndConfigure];
    
    //touch switch student callback
    weakify(self);
    _panel.callback = ^(int64_t sid, int64_t pre_sid) {
        NSLog(@"切换学生===从%lld切换到%lld", pre_sid, sid);
        strongify(self);
        [self loadDataOfBabyArchives: sid];
    };
    
    _panel.exchangeCallback = ^(int64_t sid, int64_t pre_sid, NSString *sName) {
//        NSLog(@"切换学生===从%lld切换到%lld", pre_sid, sid);
        strongify(self);
//        [self loadDataOfBabyArchives: sid];
        self.item.title = [NSString stringWithFormat: @"宝宝档案-%@", sName];
    };
}

- (TZImagePickerController *)pickerProfile {
    if (!_pickerProfile) {
        _pickerProfile = [[TZImagePickerController alloc] initWithMaxImagesCount: 1 delegate: self];
        _pickerProfile.allowPickingOriginalPhoto = NO;
        _pickerProfile.allowPickingVideo = YES;
    }
    return _pickerProfile;
}


@end
