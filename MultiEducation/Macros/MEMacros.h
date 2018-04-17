//
//  MEMacros.h
//  MultiEducation
//
//  Created by nanhu on 2018/4/12.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#ifndef MEMacros_h
#define MEMacros_h

#if DEBUG
#define ME_APP_BASE_HOST                                                @"http://192.168.1.199:8080"
#define ME_UMENG_APPKEY                                                 @"56fa2db6e0f55ace0f0030c5"
#define ME_RONGIM_APPKEY                                                @"c9kqb3rdcoywj"
#define ME_AMAP_APPKEY                                                  @"c8c05f28b018e10ff4dfab5569c3894c"
#else
#define ME_APP_BASE_HOST                                                @"http://192.168.1.199"
#define ME_UMENG_APPKEY                                                 @"5aa770eaa40fa32b340000e1"
#define ME_RONGIM_APPKEY                                                @"6tnym1br64577"
#define ME_AMAP_APPKEY                                                  @"6507a4c9c1d533612e9ec728ffa0a4b1"

#endif

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//#define ME_THEME_COLOR_VALUE                                          0xE15256
#define ME_THEME_COLOR_VALUE                                            0x609EE1
#define ME_THEME_COLOR_TEXT                                             0x333333
#define ME_THEME_COLOR_TEXT_GRAY                                        0x666666
#define ME_THEME_COLOR_LINE                                             0xEEEEEE
#define ME_ANIMATION_DURATION                                           0.25f

#define UIFontPingFangSC(f)             [UIFont fontWithName:@"PingFangSC-Regular" size:f]
#define UIFontPingFangSCBold(f)         [UIFont fontWithName:@"PingFangSC-SemiBold" size:f]
#define UIFontPingFangSCMedium(f)       [UIFont fontWithName:@"PingFangSC-Medium" size:f]
#define UIFontSystem(f)                 [UIFont systemFontOfSize:f]
#define UIFontSystemBold(f)             [UIFont boldSystemFontOfSize:f]
#define UIFontIconFont(f)               [UIFont fontWithName:@"iconfont" size:f]
#define METHEME_FONT_LARGETITLE                                         18.f
#define METHEME_FONT_TITLE                                              15.f
#define METHEME_FONT_SUBTITLE                                           13.f
#define METHEME_FONT_NAVIGATION                                         22.f

#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define MESCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define MESCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define MESCREEN_SCALE [[UIScreen mainScreen] scale]

#define ME_HEIGHT_STATUSBAR                                              20
#define ME_HEIGHT_NAVIGATIONBAR                                          44
#define ME_HEIGHT_TABBAR                                                 50
#define ME_LAYOUT_BOUNDARY                                               20
#define ME_LAYOUT_MARGIN                                                  5
#define ME_LAYOUT_SUBBAR_HEIGHT                                          40
#define ME_LAYOUT_ICON_HEIGHT                                            30
#define ME_LAYOUT_LINE_HEIGHT                                            1

//以6为标准
#define adoptValue(a) (a*(MESCREEN_WIDTH/375.0))

#define LIMIT_UPLOAD_KEY @"limit_upload_key"

#define ME_DISPATCH_KEY_CALLBEFORE                                          @"ME_DISPATCH_KEY_CALLBEFORE"//登录前执行
#define ME_DISPATCH_KEY_CALLBACK                                            @"ME_DISPATCH_KEY_CALLBACK"//登录后执行
#define ME_USER_DID_INITIATIVE_LOGOUT                                       @"ME_USER_DID_INITIATIVE_LOGOUT"//用户是否主动登出

//tabbar item image size
#define ME_TABBAR_ITEM_IMAGE_SIZE                                           30.f

#define ME_INDEX_STORY_ITEM_NUMBER_PER_LINE                                 2
#define ME_INDEX_STORY_ITEM_HEIGHT                                          120
#define ME_INDEX_CSTORY_ITEM_TITLE_HEIGHT                                   150

#pragma mark -- regular
#define ME_REGULAR_MOBILE_LENGTH                                            11
#define ME_REGULAR_PASSWD_LEN_MAX                                           12
#define ME_REGULAR_PASSWD_LEN_MIN                                           6
#define ME_REGULAR_CODE_LEN_MIN                                             4
#define ME_REGULAR_CODE_LEN_MAX                                             8
#define ME_REGULAR_CLASSNO_LEN_MIX                                          5
#define ME_REGULAR_CLASSNO_LEN_MAX                                          10
#define ME_REGULAR_MOBILE                                                   @"^1+[3578]+\\d{9}"

#pragma mark --- Type enums

typedef NS_ENUM(NSUInteger, MEDisplayStyle) {
    MEDisplayStyleAuthor                        =   1   <<  0,//显示用户授权中心
    MEDisplayStyleVisitor                       =   1   <<  1,//显示游客模式 只有首页内容
    MEDisplayStyleMainSence                     =   1   <<  2//显示主页面
};

typedef NS_ENUM(NSUInteger, MEUserRole) {
    MEUserRoleVisitor                       =   1   <<  0,  //游客
    MEUserRoleParent                        =   1   <<  1,  //家长
    MEUserRoleTeacher                       =   1   <<  2,  //老师
    MEUserRoleGardener                      =   1   <<  3   //园务
};
/**
 user state
 */
typedef NS_ENUM(NSUInteger, MEUserState) {
    MEUserStateOffline                      =   1   <<  0,
    MEUserStateBusy                         =   1   <<  1,
    MEUserStateOnline                       =   1   <<  2
};

typedef NS_ENUM(NSUInteger, MEProfileType) {
    MEProfileTypeSB                         =   1   <<  0,
    MEProfileTypeXIB                        =   1   <<  1,//xib创建
    MEProfileTypeCODE                       =   1   <<  2//code创建
};

#endif /* MEMacros_h */
