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
#define ME_APP_ENV                                                      @"dev"
//#define ME_APP_BASE_HOST                                                @"http://192.168.1.199:8080"
#define ME_APP_BASE_HOST                                                @"http://v2.api.x16.com:443"
#define ME_WEB_SERVER_HOST                                              @"http://ost.x16.com/open/res"
#define ME_CORDOVA_SERVER_HOST                                          @"http://v2.api.x16.com:443"
#define ME_UMENG_APPKEY                                                 @"56fa2db6e0f55ace0f0030c5"
//#define ME_RONGIM_APPKEY                                                @"mgb7ka1nm4whg"//dev
#define ME_RONGIM_APPKEY                                                @"6tnym1br64577"//
#define ME_AMAP_APPKEY                                                  @"c8c05f28b018e10ff4dfab5569c3894c"
#else
#define ME_APP_ENV                                                      @"lan"
#define ME_APP_BASE_HOST                                                @"http://v2.api.x16.com:443"
#define ME_WEB_SERVER_HOST                                              @"http://ost.x16.com/open/res"
#define ME_CORDOVA_SERVER_HOST                                          @"http://v2.api.x16.com:443"
#define ME_UMENG_APPKEY                                                 @"5aa770eaa40fa32b340000e1"
#define ME_RONGIM_APPKEY                                                @"6tnym1br64577"//prod
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
#define ME_THEME_COLOR_BG_GRAY                                          0xF5F5F5
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

#define ME_ICONFONT_EMPTY_HOLDER                                        @"\U0000e673"

#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define MESCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define MESCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define MESCREEN_SCALE [[UIScreen mainScreen] scale]

#define ME_HEIGHT_NAVIGATIONBAR                                          44
#define ME_HEIGHT_TABBAR                                                 50
#define ME_LAYOUT_BOUNDARY                                               20
#define ME_LAYOUT_MARGIN                                                 10
#define ME_LAYOUT_OFFSET                                                  2
#define ME_LAYOUT_SUBBAR_HEIGHT                                          40
#define ME_LAYOUT_ICON_HEIGHT                                            30
#define ME_LAYOUT_LINE_HEIGHT                                            1
#define ME_LAYOUT_CORNER_RADIUS                                           4

//以6为标准
#define adoptValue(a) (a*(MESCREEN_WIDTH/375.0))

#define LIMIT_UPLOAD_KEY @"limit_upload_key"

#define QRCODE_URL @"http://app.chinaxqjy.com"

#define ME_USER_SIGNIN_PROFILE                                              @"MELoginProfile"//用户授权界面
#define ME_SIGNIN_DID_SHOW_VISITOR_FUNC                                     @"ME_SIGNIN_DID_SHOW_VISITOR_FUNC"//登录界面显示随便逛逛
#define ME_SIGNIN_SHOULD_GOBACKSTACK_AFTER_SIGNIN                           @"ME_SIGNIN_SHOULD_GOBACKSTACK_AFTER_SIGNIN"//登录成功后是否返回 是则返回 否则跳转主界面
#define ME_DISPATCH_KEY_CALLBEFORE                                          @"ME_DISPATCH_KEY_CALLBEFORE"//登录前执行
#define ME_DISPATCH_KEY_CALLBACK                                            @"ME_DISPATCH_KEY_CALLBACK"//登录后执行
#define ME_USER_DID_INITIATIVE_LOGOUT                                       @"ME_USER_DID_INITIATIVE_LOGOUT"//用户是否主动登出
#define ME_APPLICATION_APNE_TOKEN                                           @"ME_APPLICATION_APNE_TOKEN"//用户token

#define ME_CORDOVA_KEY_TITLE                                                @"ME_CORDOVA_KEY_TITLE"//cordova title
#define ME_CORDOVA_KEY_STARTPAGE                                            @"ME_CORDOVA_KEY_STARTPAGE"//cordova start page

//tabbar item image size
#define ME_TABBAR_ITEM_IMAGE_SIZE                                           30.f

#define ME_INDEX_STORY_ITEM_NUMBER_PER_LINE                                 2
#define ME_INDEX_STORY_ITEM_HEIGHT                                          140
#define ME_INDEX_CSTORY_ITEM_TITLE_HEIGHT                                   170

#pragma mark -- regular
#define ME_REGULAR_MOBILE_LENGTH                                            11
#define ME_REGULAR_PASSWD_LEN_MAX                                           12
#define ME_REGULAR_PASSWD_LEN_MIN                                           6
#define ME_REGULAR_CODE_LEN_MIN                                             4
#define ME_REGULAR_CODE_LEN_MAX                                             8
#define ME_REGULAR_CLASSNO_LEN_MIX                                          5
#define ME_REGULAR_CLASSNO_LEN_MAX                                          10
#define ME_REGULAR_MOBILE                                                   @"^1+[3578]+\\d{9}"
#define ME_REGULAR_URL                                                      @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)"

#define QN_VIDEO_FIRST_FPS_URL @"?vframe/jpg/offset/0"

#define ME_PAGING_SIZE                                                      20//默认分页20
#define ME_EMPTY_PROMPT_TITLE                                               @"Oops！"
#define ME_EMPTY_PROMPT_DESC                                                @"服务器貌似在睡觉，您稍等我去叫醒它..."
#define ME_EMPTY_PROMPT_NETWORK                                             @"您貌似断开了互联网链接，请检查网络稍后重试！"
#define ME_EMPTY_PROMPT_OFFSET                                              -20

#define ME_ALERT_INFO_TITILE                                                @"提示"
#define ME_ALERT_INFO_ITEM_OK                                               @"知道了"
#define ME_ALERT_INFO_ITEM_CANCEL                                           @"取消"
#define ME_ALERT_INFO_NONE_CLASS                                            @"您还没有关联班级，请先关联班级！"
#define ME_TOAST_BOTTOM_SCALE                                               0.85

#define ME_USER_SESSION_TOKEN_REFRESH_INTERVAL                              (60*10UL)//刷新token时间间隔

#pragma mark --- Type enums

typedef NS_ENUM(NSUInteger, MEDisplayStyle) {
    MEDisplayStyleAuthor                        =   1   <<  0,//显示用户授权中心
    MEDisplayStyleVisitor                       =   1   <<  1,//显示游客模式 只有首页内容
    MEDisplayStyleMainSence                     =   1   <<  2//显示主页面
};

typedef NS_ENUM(NSUInteger, MEProfileType) {
    MEProfileTypeSB                         =   1   <<  0,
    MEProfileTypeXIB                        =   1   <<  1,//xib创建
    MEProfileTypeCODE                       =   1   <<  2//code创建
};

#endif /* MEMacros_h */
