//
//  MEContactInfoProfile.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/25.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEContactInfoProfile.h"
#import "MeclassMember.pbobjc.h"

@interface MEContactInfoProfile ()

@property (nonatomic, strong) NSDictionary *params;

@end

@implementation MEContactInfoProfile

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIColor *backColor = UIColorFromRGB(ME_THEME_COLOR_TEXT);
    UIBarButtonItem *spacer = [MEKits barSpacer];
    UIBarButtonItem *backItem = [MEKits backBarWithColor:backColor target:self withSelector:@selector(defaultGoBackStack)];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"详细资料"];
    item.leftBarButtonItems = @[spacer, backItem];
    [self.navigationBar pushNavigationItem:item animated:true];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    [self rebuildContactMemberInfoSubviews];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- rebuild ui

- (MEBaseScene *)assembleBlankSectionBackgroundScene4Height:(CGFloat)height whetherInfo:(BOOL)info {
    CGRect bounds = CGRectMake(0, 0, MESCREEN_WIDTH, height);
    MEBaseScene *scene = [[MEBaseScene alloc] initWithFrame:bounds];
    if (!info) {
        scene.backgroundColor = UIColorFromRGB(0xF3F3F3);
    }
    return scene;
}

- (void)rebuildContactMemberInfoSubviews {
    MEClassMember *member = [self.params objectForKey:@"member"];
    if (member) {
        CGFloat sectionHeight = ME_LAYOUT_MARGIN * 2;
        MEBaseScene *scene = [self assembleBlankSectionBackgroundScene4Height:sectionHeight whetherInfo:false];
        [self.view addSubview:scene];
        [scene makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.navigationBar.mas_bottom);
            make.left.right.equalTo(self.view);
            make.height.equalTo(sectionHeight);
        }];
        sectionHeight = ME_HEIGHT_TABBAR + ME_LAYOUT_ICON_HEIGHT;
        MEBaseScene *infoScene = [self assembleBlankSectionBackgroundScene4Height:sectionHeight whetherInfo:true];
        [self.view addSubview:infoScene];
        [infoScene makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(scene.mas_bottom);
            make.left.right.equalTo(self.view);
            make.height.equalTo(sectionHeight);
        }];
        //avatar
        UIImage *placeHolder = [UIImage imageNamed:@"appicon_placeholder"];
        NSString *avatarUrlString = member.portrait;
        avatarUrlString = [MEKits imageFullPath:avatarUrlString];
        MEBaseImageView *icon = [[MEBaseImageView alloc] initWithFrame:CGRectZero];
        icon.layer.cornerRadius = ME_LAYOUT_ICON_HEIGHT * 0.5;
        icon.layer.masksToBounds = true;
        [icon sd_setImageWithURL:[NSURL URLWithString:avatarUrlString] placeholderImage:placeHolder];
        [infoScene addSubview:icon];
        [icon makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(infoScene.mas_centerY);
            make.left.equalTo(infoScene).offset(ME_LAYOUT_BOUNDARY);
            make.width.height.equalTo(ME_LAYOUT_ICON_HEIGHT);
        }];
        //name
        NSString *name = PBAvailableString(member.name);
        UIFont *font = UIFontPingFangSCMedium(METHEME_FONT_TITLE);
        UIColor *fontColor = UIColorFromRGB(ME_THEME_COLOR_TEXT);
        MEBaseLabel *label = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
        label.font = font;
        label.textColor = fontColor;
        label.text = name;
        [infoScene addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(infoScene.mas_centerY);
            make.left.equalTo(icon.mas_right).offset(ME_LAYOUT_MARGIN);
        }];
        //gender
        //NSString *genderIconName = (member.gender == 1)?@"contact_icon_male":@"contact_icon_female";
        NSString *genderIconName = (member.gender == 1)?@"\U0000e616":@"\U0000e627";
        NSUInteger iconSize = ME_LAYOUT_MARGIN * 3/MESCREEN_SCALE;
        UIColor *iconColor = (member.gender == 1)?UIColorFromRGB(0x609EE1):UIColorFromRGB(0xE15256);
        UIImage *genderIcon = [UIImage pb_iconFont:nil withName:genderIconName withSize:iconSize withColor:iconColor];
        MEBaseImageView *gender = [[MEBaseImageView alloc] initWithFrame:CGRectZero];
        gender.image = genderIcon;
        [infoScene addSubview:gender];
        [gender makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(infoScene.mas_centerY);
            make.left.equalTo(label.mas_right).offset(ME_LAYOUT_MARGIN);
            make.width.height.equalTo(ME_LAYOUT_MARGIN*3);
        }];
        //分割线
        sectionHeight = ME_LAYOUT_MARGIN * 2;
        scene = [self assembleBlankSectionBackgroundScene4Height:sectionHeight whetherInfo:false];
        [self.view addSubview:scene];
        [scene makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(infoScene.mas_bottom);
            make.left.right.equalTo(self.view);
            make.height.equalTo(sectionHeight);
        }];
        //资料 学校
        font = UIFontPingFangSC(METHEME_FONT_SUBTITLE);
        MEBaseScene *lastScene = nil;
        NSString *schoolName = PBAvailableString(member.schoolName);
        if (schoolName.length > 0) {
            sectionHeight = ME_LAYOUT_SUBBAR_HEIGHT;
            infoScene = [self assembleBlankSectionBackgroundScene4Height:sectionHeight whetherInfo:true];
            [self.view addSubview:infoScene];
            [infoScene makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo((lastScene==nil)?scene.mas_bottom:lastScene.mas_bottom);
                make.left.right.equalTo(self.view);
                make.height.equalTo(sectionHeight);
            }];
            MEBaseLabel *preLabel = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
            preLabel.font = font;
            preLabel.textColor = fontColor;
            preLabel.text = @"学校";
            [infoScene addSubview:preLabel];
            [preLabel makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(infoScene).offset(ME_LAYOUT_BOUNDARY);
                make.top.bottom.equalTo(infoScene);
                make.width.equalTo(ME_HEIGHT_TABBAR);
            }];
            MEBaseLabel *infoLabel = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
            infoLabel.font = font;
            infoLabel.textColor = fontColor;
            infoLabel.text = schoolName;
            [infoScene addSubview:infoLabel];
            [infoLabel makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(preLabel.mas_right);
                make.top.bottom.right.equalTo(infoScene);
            }];
            
            lastScene = infoScene;
        }
        //资料 班级
        NSString *className = PBAvailableString([self.params pb_stringForKey:@"classTitle"]);
        if (className.length > 0) {
            sectionHeight = ME_LAYOUT_SUBBAR_HEIGHT;
            infoScene = [self assembleBlankSectionBackgroundScene4Height:sectionHeight whetherInfo:true];
            [self.view addSubview:infoScene];
            [infoScene makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo((lastScene==nil)?scene.mas_bottom:lastScene.mas_bottom);
                make.left.right.equalTo(self.view);
                make.height.equalTo(sectionHeight);
            }];
            MEBaseLabel *preLabel = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
            preLabel.font = font;
            preLabel.textColor = fontColor;
            preLabel.text = @"班级";
            [infoScene addSubview:preLabel];
            [preLabel makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(infoScene).offset(ME_LAYOUT_BOUNDARY);
                make.top.bottom.equalTo(infoScene);
                make.width.equalTo(ME_HEIGHT_TABBAR);
            }];
            MEBaseLabel *infoLabel = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
            infoLabel.font = font;
            infoLabel.textColor = fontColor;
            infoLabel.text = className;
            [infoScene addSubview:infoLabel];
            [infoLabel makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(preLabel.mas_right);
                make.top.bottom.right.equalTo(infoScene);
            }];
            
            lastScene = infoScene;
        }
        //资料 学生
        NSString *studentName = PBAvailableString(member.studentName);
        if (studentName.length > 0) {
            sectionHeight = ME_LAYOUT_SUBBAR_HEIGHT;
            infoScene = [self assembleBlankSectionBackgroundScene4Height:sectionHeight whetherInfo:true];
            [self.view addSubview:infoScene];
            [infoScene makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo((lastScene==nil)?scene.mas_bottom:lastScene.mas_bottom);
                make.left.right.equalTo(self.view);
                make.height.equalTo(sectionHeight);
            }];
            MEBaseLabel *preLabel = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
            preLabel.font = font;
            preLabel.textColor = fontColor;
            preLabel.text = @"学生";
            [infoScene addSubview:preLabel];
            [preLabel makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(infoScene).offset(ME_LAYOUT_BOUNDARY);
                make.top.bottom.equalTo(infoScene);
                make.width.equalTo(ME_HEIGHT_TABBAR);
            }];
            MEBaseLabel *infoLabel = [[MEBaseLabel alloc] initWithFrame:CGRectZero];
            infoLabel.font = font;
            infoLabel.textColor = fontColor;
            infoLabel.text = className;
            [infoScene addSubview:infoLabel];
            [infoLabel makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(preLabel.mas_right);
                make.top.bottom.right.equalTo(infoScene);
            }];
            
            lastScene = infoScene;
        }
        
        //发消息
        font = UIFontPingFangSCMedium(METHEME_FONT_TITLE);
        UIColor *bgColor = UIColorFromRGB(0x17a828);
        MEBaseButton *btn = [MEBaseButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = bgColor;
        btn.titleLabel.font = font;
        btn.layer.cornerRadius = ME_LAYOUT_CORNER_RADIUS;
        btn.layer.masksToBounds = true;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:@"发送消息" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(sendMessageTouchEvent) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo((lastScene==nil)?scene.mas_bottom:lastScene.mas_bottom).offset(ME_LAYOUT_BOUNDARY);
            make.left.equalTo(self.view).offset(ME_LAYOUT_BOUNDARY);
            make.right.equalTo(self.view).offset(-ME_LAYOUT_BOUNDARY);
            make.height.equalTo(ME_LAYOUT_SUBBAR_HEIGHT);
        }];
    }
}

#pragma mark --- User Touch Events

/**
 发送消息
 */
- (void)sendMessageTouchEvent {
    
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
