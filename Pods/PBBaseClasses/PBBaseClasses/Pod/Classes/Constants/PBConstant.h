//
//  PBConstant.h
//  PBBaseClasses
//
//  Created by nanhujiaju on 2017/9/8.
//  Copyright © 2017年 nanhujiaju. All rights reserved.
//

#ifndef PBConstant_h
#define PBConstant_h

static const int PB_SIDE_OFF_WIDTH                      =       60;
static const int PB_BOUNDARY_MARGIN                     =       15;
static const int PB_CONTENT_MARGIN                      =       10;
static const int PB_NAVIBAR_HEIGHT                      =       44;
static const int PB_STATUSBAR_HEIGHT                    =       20;
static const int PB_STATUSBAR_HEIGHT_X                  =       44;
static const int PB_NAVIBAR_ITEM_SIZE                   =       31;
static const int PB_TABBAR_HEIGHT                       =       49;
static const int PB_TABBAR_HEIGHT_X                     =       83;
static const int PB_DESC_COUNTS                         =       60;
static const int PB_CUSTOM_SEARCHBAR_HEIGHT             =       35;
static const int PB_CUSTOM_BTN_HEIGHT                   =       40;
static const int PB_CUSTOM_TFD_HEIGHT                   =       40;
static const int PB_CUSTOM_LAB_HEIGHT                   =       21;
static const int PB_CUSTOM_CELL_HEIGHT                  =       55;
static const int PB_CUSTOM_LINE_HEIGHT                  =       1;
static const int PB_FEEDBACK_CRS_MAX                    =       300;
static const int PB_CORNER_RADIUS                       =       4;
static const int PB_REFRESH_INTERVAL                    =       600;
static const int PB_REFRESH_PAGESIZE                    =       20;
static const int PB_TEXT_PADDING                        =       8;

static const int PB_NICK_MIN_LEN                        =       2;
static const int PB_NICK_MAX_LEN                        =       10;
static const int PB_PASSWD_MIN_LEN                      =       6;
static const int PB_PASSWD_MAX_LEN                      =       16;

/* custom fonts */
static const CGFloat PBFontTitleSize                    =       15.f;
static const CGFloat PBFontSubSize                      =       13.f;
/* font offset for device iPhone6+ */
static const int PB_FONT_OFFSET                         =       2;

static NSString * PB_DEFAULT_TEXT_FONT                  =       @"Helvetica-Light";

// global theme
static NSString * PB_BASE_BG_STRING                     =       @"#FFFFFF";

/* custom color hex or string value */
static unsigned int PB_NAVIBAR_TINT_HEX                 =       0xFFFFFF;
static NSString * PB_NAVIBAR_TINT_STRING                =       @"#FFFFFF";

static unsigned int PB_NAVIBAR_BARTINT_HEX              =       0x414B55;
static NSString * PB_NAVIBAR_BARTINT_STRING             =       @"#414B55";

static unsigned int PB_NAVIBAR_SHADOW_HEX               =       0xE8E8E8;

static unsigned int PB_TABBAR_TINT_HEX                  =       0xFF423A;
static NSString * PB_TABBAR_TINT_STRING                 =       @"#FF423A";

static unsigned int PB_BTN_BG_IN_TINT_HEX               =       0x66C3FA;
static NSString * PB_BTN_BG_IN_TINT_STRING              =       @"#66C3FA";

static unsigned int PB_BTN_BG_EN_TINT_HEX               =       0x25A9F1;
static NSString * PB_BTN_BG_EN_TINT_STRING              =       @"#25A9F1";

static unsigned int PB_BTN_TITLE_IN_TINT_HEX            =       0xEFF0F2;
static NSString * PB_BTN_TITLE_IN_TINT_STRING           =       @"#EFF0F2";

static unsigned int PB_BTN_TITLE_EN_TINT_HEX            =       0xEFF0F2;
static NSString * PB_BTN_TITLE_EN_TINT_STRING           =       @"#EFF0F2";

/* title custom common color*/
static unsigned int PB_TITLE_CM_HEX                     =       0xC7C7C7;
static NSString * PB_TITLE_CM_STRING                    =       @"#C7C7C7";

static unsigned int PB_SUBTITLE_CM_HEX                  =       0x878787;
static NSString * PB_SUBTITLE_CM_STRING                 =       @"#878787";

static unsigned int PB_TIME_CM_HEX                      =       0xCBCBCB;
static NSString * PB_TIME_CM_STRING                     =       @"#CBCBCB";

//seperate line
static unsigned int PB_SEPERATE_LINE_HEX                =       0xE8E7EC;
static NSString * PB_SEPERATE_LINE_STRING               =       @"#E8E7EC";

/* iconfonts */
static NSString * PB_NAVI_ICON_BACK                     =       @"\U0000e600";
static NSString * PB_NAVI_ICON_CANCEL                   =       @"\U0000e605";

//regix
static NSString * PB_REGEXP_PASSWD                      =       @"^[A-Za-z0-9!^@#$`~%&*/_-{}()<>\":;,.']+$";
static NSString * PB_REGEXP_PHONE                       =       @"^(1[3-9][0-9](?: ))(\\d{4}(?: )){2}$";
//usr
static NSString * PB_USR_AUTO_LOGOUT_KEY                =       @"PBUSRAUTOLOGOUTKEY";
static NSString * PB_UI_DESIGN_REFRENCE                 =       @"6";

//scheme
static NSString * PB_SAFE_SCHEME                        =       @"FLK";
static NSString * const PB_INIT_METHOD_NONE             =       @"init";
static NSString * const PB_INIT_METHOD_PARAMS           =       @"initWithParams:";
static NSString * const PB_OBJC_CMD_TARGET              =       @"cmdTarget";

//chat
static const int PB_CHAT_TOOLBAR_HEIGHT                 =       40;
static const int PB_CHAT_KEYBOARD_HEIGHT                =       216;
static const int PB_CHAT_TIME_PROMOT_FONT               =       11;
static const int PB_CHAT_CONTENT_FONT                   =       14;

/**
 登录相关的常量定义
 */
FOUNDATION_EXTERN NSString * const PB_STORAGE_DB_NAME;
FOUNDATION_EXTERN NSString * const PB_ORG_KEYCHAIN_ACCESSGROUP;
FOUNDATION_EXTERN NSString * const PB_ENT_KEYCHAIN_ACCESSGROUP;

FOUNDATION_EXTERN NSString * const PB_CLIENT_DID_AUTHORIZED_NOTIFICATION;
FOUNDATION_EXTERN NSString * const PB_CLIENT_DID_UNAUTHORIZED_NOTIFICATION;

/**
 国际化 定义
 */
static NSString * const PBBASECLASSES_TBL                      =   @"PBBaseClasses";
#define PBBASECLASSESString(k) NSLocalizedStringFromTable(k, PBBASECLASSES_TBL, nil)

#endif /* PBConstant_h */
