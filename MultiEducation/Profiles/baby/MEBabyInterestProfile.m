//
//  MEBabyInterest.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/5/17.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBabyInterestProfile.h"
#import "MEBabyInterestingContent.h"
#import "Meuser.pbobjc.h"
#import "MEStudentsPanel.h"
#import "MEBabyIndexVM.h"
#import "Meclass.pbobjc.h"
#import "MEInterestListVM.h"
#import "MestuFun.pbobjc.h"
#import <MWPhotoBrowser.h>
#import "MEInterestNotFound.h"

#define CONTENT_HEIGHT MESCREEN_HEIGHT - ME_STUDENT_PANEL_HEIGHT - ME_HEIGHT_NAVIGATIONBAR - [MEKits statusBarHeight]

@interface MEBabyInterestProfile () <MWPhotoBrowserDelegate> {
    MEPBClass *_classPb;   //role == teacher || gardener
    int64_t _stuId;     //selected student's id ,if role == parent [MEBabyIndexVM fetchSelectBaby]
    BOOL _whetherSend4Month;    //本月是否已经发送过趣事趣影
}

@property (nonatomic, strong) GuFunPhotoPb *funPb;

@property (nonatomic, strong) MEBabyInterestingContent *content;
@property (nonatomic, strong) MEStudentsPanel *panel;

@property (nonatomic, strong) MEInterestNotFound *notfound;
@end

@implementation MEBabyInterestProfile

- (instancetype)__initWithParams:(NSDictionary *)params {
    if (self = [super init]) {
        _classPb = [params objectForKey: @"classPb"];
    }
    return self;
}

- (void)loadData {
    int64_t gradeId;
    if (self.currentUser.userType == MEPBUserRole_Parent) {
        gradeId = [MEBabyIndexVM fetchSelectBaby].gradeId;
    } else {
        gradeId = _classPb.gradeId;
    }
    
    GuFunPhotoPb *pb = [[GuFunPhotoPb alloc] init];
    pb.studentId = _stuId;
    pb.gradeId = gradeId;
    
    MEInterestListVM *vm = [MEInterestListVM vmWithPb: pb];
    weakify(self);
    [vm postData: [pb data] hudEnable: true success:^(NSData * _Nullable resObj) {
        strongify(self);
        GuFunPhotoListPb *pb = [GuFunPhotoListPb parseFromData: resObj error: nil];
        if (pb.funPhotoPbArray.count > 0) {
            self.notfound.hidden = true;
        } else {
            self.notfound.hidden = false;
        }
        self.content.items = pb.funPhotoPbArray;
        for (GuFunPhotoPb *photoPb in pb.funPhotoPbArray) {
            if (photoPb.month == [MEBabyIndexVM fetchSelectBaby].month) {
                _whetherSend4Month = true;
                return;
            }
        }
        _whetherSend4Month = false;
    } failure:^(NSError * _Nonnull error) {
        [MEKits handleError: error];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNavigation];
    if (self.currentUser.userType == MEPBUserRole_Parent) {
        _stuId = [MEBabyIndexVM fetchSelectBaby].studentArchives.studentId;
    }
    [self.view addSubview: self.content];
    [self.view addSubview: self.notfound];

    if (self.currentUser.userType == MEPBUserRole_Parent) {
        self.content.center = CGPointMake(MESCREEN_WIDTH / 2, MESCREEN_HEIGHT / 2);
        [self.notfound mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(240.f);
            make.height.mas_equalTo(250.f);
            make.center.mas_equalTo(self);
        }];
        [self loadData];
    } else {
        [self configureStudentPanel];
        CGFloat y = ME_HEIGHT_NAVIGATIONBAR + [MEKits statusBarHeight] + ME_STUDENT_PANEL_HEIGHT;
        self.content.frame = CGRectMake(0, y, MESCREEN_WIDTH, CONTENT_HEIGHT);
        [self.notfound mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(240.f);
            make.height.mas_equalTo(250.f);
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(self.navigationBar.mas_bottom).mas_offset(y);
        }];
    }
}

- (void)customNavigation {
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle: @"趣事趣影"];
    item.leftBarButtonItem = [MEKits defaultGoBackBarButtonItemWithTarget: self];
    item.rightBarButtonItem = [MEKits barWithUnicode: @"\U0000e670" color: [UIColor whiteColor] target: self action: @selector(pushToSendBabyInterestingProfileItemTouchEvent)];
    [self.navigationBar pushNavigationItem: item animated: false];
}

- (void)pushToPhotoBrowser {
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
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: photoBrowser];
    
    [self.navigationController presentViewController: nav animated: true completion: nil];
}

- (void)pushToSendBabyInterestingProfileItemTouchEvent {
    for (GuFunPhotoPb *pb in self.content.items) {
        if (pb.month == [MEBabyIndexVM fetchSelectBaby].month) {
            [self makeToast: @"当月已发布过趣事趣影"];
            return;
        }
    }
    NSString *urlStr = @"profile://root@MESendIntersetingProfile";
    weakify(self);
    void (^didSubmitStuInterestCallback) (void) = ^ {
        strongify(self);
        [self loadData];
    };
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary: @{@"stuId": @(_stuId), ME_DISPATCH_KEY_CALLBACK: didSubmitStuInterestCallback}];
    if (_classPb) {
        [params setObject: _classPb forKey: @"classPb"];
    }
    NSError *error = [MEDispatcher openURL: [NSURL URLWithString: urlStr] withParams: params];
    [MEKits handleError: error];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.funPb.imgListArray.count;
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    NSString *urlStr;
    MWPhoto *photo;
    if ([self.funPb.imgListArray.firstObject.imgPath hasSuffix: @".mp4"]) {
        urlStr = [NSString stringWithFormat: @"%@/%@", self.currentUser.bucketDomain, self.funPb.imgListArray[index].imgPath];
        photo = [MWPhoto videoWithURL: [NSURL URLWithString: urlStr]];
    } else {
        urlStr = [NSString stringWithFormat: @"%@/%@", self.currentUser.bucketDomain, self.funPb.imgListArray[index].imgPath];
        photo = [MWPhoto photoWithURL: [NSURL URLWithString: urlStr]];

    }
    return photo;
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    [photoBrowser.navigationController dismissViewControllerAnimated: true completion: nil];
    photoBrowser = nil;
}

#pragma mark --- 配置头部
- (void)configureStudentPanel {
    GuIndexPb *index = [MEBabyIndexVM fetchSelectBaby];
    
    _panel = [MEStudentsPanel panelWithSuperView: self.view topMargin: self.navigationBar];
    _panel.autoScrollNext = false;
    _panel.classID = _classPb.id_p;
    _panel.gradeID = _classPb.gradeId;
    _panel.semester = _classPb.semester;
    _panel.month = index.month;
    _panel.type = 6;
    [self.view insertSubview:_panel belowSubview: self.navigationBar];
    [self.view insertSubview:_panel aboveSubview: self.content];

    [_panel loadAndConfigure];
    
    //touch switch student callback
    weakify(self);
    _panel.callback = ^(int64_t sid, int64_t pre_sid) {
        NSLog(@"切换学生===从%lld切换到%lld", pre_sid, sid);
        strongify(self);
        _stuId = sid;
        [self loadData];
    };

}

#pragma mark - lazyloading
- (MEBabyInterestingContent *)content {
    if (!_content) {
        _content = [[MEBabyInterestingContent alloc] initWithFrame: CGRectMake(0, ME_HEIGHT_NAVIGATIONBAR + [MEKits statusBarHeight], MESCREEN_WIDTH, CONTENT_HEIGHT)];
        _content.pagingEnabled = true;
        weakify(self);
        _content.gotoPhotoBrowserHandler = ^(GuFunPhotoPb *pb) {
            strongify(self);
            self.funPb = pb;
            [self pushToPhotoBrowser];
        };
    }
    return _content;
}

- (MEInterestNotFound *)notfound {
    if (!_notfound) {
        _notfound = [[MEInterestNotFound alloc] initWithFrame: CGRectZero];
        _notfound.hidden = true; weakify(self);
        _notfound.didSubmitCallback = ^{
            strongify(self);
            [self pushToSendBabyInterestingProfileItemTouchEvent];
        };
    }
    return _notfound;
}


@end
