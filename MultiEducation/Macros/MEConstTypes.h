#import <CoreGraphics/CoreGraphics.h>
/**
 * const var types
 * */

#define ME_THEME_COLOR_KEY                                      @"themeColor"
//#define ME_THEME_COLOR_VALUE                                    0xE15256
#define ME_THEME_COLOR_VALUE                                    0x609EE1
#define ME_TEXT_COLOR_GRAY                                      0xDDDDDD

#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_SCALE [[UIScreen mainScreen] scale]
//以6为标准
#define adoptValue(a) (a*(SCREEN_WIDTH/375.0))

static NSString * const ME_DISPATCH_KEY_CALLBACK                =   @"ME_DISPATCH_KEY_CALLBACK";
//tabbar item image size
static const CGFloat ME_TABBAR_ITEM_IMAGE_SIZE                  =   30.f;

typedef NS_ENUM(NSUInteger, MEDisplayStyle) {
    MEDisplayStyleAuthor                        =   1   <<  0,//显示用户授权中心
    MEDisplayStyleMainSence                     =   1   <<  1//显示主页面
};

typedef NS_ENUM(NSUInteger, MEUserRole) {
    MEUserRoleParent                        =   1   <<  0,  //家长
    MEUserRoleTeacher                       =   1   <<  1,  //老师
    MEUserRoleGardener                      =   1   <<  2   //园务
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
