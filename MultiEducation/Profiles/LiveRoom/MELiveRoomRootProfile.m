//
//  MELiveRoomRootProfile.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/18.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MELiveClassVM.h"
#import <MJRefresh/MJRefresh.h>
#import "MELiveRoomRootProfile.h"

@interface MELiveRoomRootProfile ()

/**
 当前用户是否是老师
 */
@property (nonatomic, assign) BOOL whetherTeacherRole;

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) MEPBClassLive *dataLive;

@end

@implementation MELiveRoomRootProfile

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
    
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *back = [self backBarButtonItemWithIconUnicode:@"\U0000e6e2" color:pbColorMake(ME_THEME_COLOR_TEXT)];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"直播课堂"];
    item.leftBarButtonItems = @[spacer, back];
    [self.navigationBar pushNavigationItem:item animated:true];
    //角色判断
    self.whetherTeacherRole = ((self.currentUser.userType == 1) && (!self.currentUser.isTourist));
    
    [self __initLiveRoomSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    if (!self.dataLive) {
        [self loadLiveClassRoomData];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- initiazlized subviews

- (void)__initLiveRoomSubviews {
    
}

#pragma mark --- fetch network data

- (uint64_t)fetchCurrentClassID {
    __block uint64_t class_id = 0;
    if (self.currentUser.userType == MEPBUserRole_Teacher) {
        //老师
        TeacherPb *teacher = self.currentUser.teacherPb;
        NSArray <MEPBClass*>*classes = teacher.classPbArray.copy;
        //老师 目前策略直接取第一个class
        MEPBClass *cls = classes.firstObject;
        class_id = cls.id_p;
    } else if (self.currentUser.userType == MEPBUserRole_Parent) {
        //家长
        ParentsPb *parent = self.currentUser.parentsPb;
        NSArray<StudentPb*>*studdents = parent.studentPbArray.copy;
        uint64_t currentStudnetID = parent.cutStudenId;
        [studdents enumerateObjectsUsingBlock:^(StudentPb * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.id_p == currentStudnetID) {
                class_id = obj.classId;
            }
        }];
    }
    return class_id;
}

- (void)loadLiveClassRoomData {
    //当前class_id
    uint64_t class_id = [self fetchCurrentClassID];
    MELiveClassVM *vm = [[MELiveClassVM alloc] init];
    MEPBClassLive *live = [[MEPBClassLive alloc] init];
    [live setClassId:class_id];
    weakify(self)
    [vm postData:[live data] hudEnable:true success:^(NSData * _Nullable resObj) {
        NSError *err;strongify(self)
        MEPBClassLive *liveRoom = [MEPBClassLive parseFromData:resObj error:&err];
        if (err) {
            [self handleTransitionError:err];
        } else {
            self.dataLive = liveRoom;
        }
    } failure:^(NSError * _Nonnull error) {
        strongify(self)
        [self handleTransitionError:error];
    }];
}

- (void)rebuildLiveRoomSubviews {
    
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
