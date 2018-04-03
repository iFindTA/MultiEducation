//
//  PBBaseProfile.h
//  PBBaseClasses
//
//  Created by nanhujiaju on 2017/9/8.
//  Copyright © 2017年 nanhujiaju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBConstant.h"
#import <PBKits/PBKits.h>
#import "PBNavigationBar.h"
#import <PBMediator/PBMediator.h>
#import <SVProgressHUD/SVProgressHUD.h>

/**
 FLK Base Classes
 *
 *  Dependency:
 *  <PBKits>
 *  <PBMediator>
 *  <WZLBadge>
 *  <SVProgressHUD>
 *  -- <SAMKeychain>:need for subclass
 *  -- <Masonry>:no nedeed, but can install previously for user
 *
 */
@interface PBBaseProfile : UIViewController

NS_ASSUME_NONNULL_BEGIN

/**
 indicate self wether initialized, default is no
 */
@property (nonatomic, assign, readonly) BOOL wetherInited;

/**
 indicate wether self should response on other button touch event
 */
@property (nonatomic, assign) BOOL busy;

/**
 the custom navigationBar, adjust for iOS11.0+
 */
@property (nonatomic, strong, readonly) PBNavigationBar *navigationBar;

/**
 whether self.view is visible
 
 @return result
 */
- (BOOL)isVisible;

/**
 end input mode
 */
- (void)endEditingMode;

#pragma mark -- navigationBar item

/**
 custom navigationBar instance and bind the instance to self.navigationBar
 
 @return naviBar
 */
- (UINavigationBar *)initializedNavigationBar;

/**
 hidden custom navigationBar, move bar outof screen to headtop!
 */
- (void)hiddenNavigationBar;

/**
 change the color of navigationBar's shadow image
 
 @param color for shadow image
 */
- (void)changeNavigationBarShadow2Color:(UIColor *)color;

/**
 navigationBar item
 
 @return the bar item
 */
- (UIBarButtonItem *)barSpacer;

/**
 generate navigationBar back item
 
 @param backTitle title for item
 @param img : title image of unicode, default is \U0000e6e2
 @return : bar item
 */
- (UIBarButtonItem *)backBarButtonItem:(NSString * _Nullable)backTitle withIconUnicode:(NSString * _Nullable)img;

/**
 generate navigationBar back item
 
 @param backTitle title for item
 @param img unicode for img
 @param target for callee
 @param selector for callee
 @return bar item
 */
- (UIBarButtonItem *)backBarButtonItem:(NSString * _Nullable)backTitle withIconUnicode:(NSString * _Nullable)img withTarget:(nullable id)target withSelector:(nullable SEL)selector;

/**
 generate navigationBar normal item
 
 @param iconCode code for item
 @param target for callee
 @param selector for callee
 @return bar item
 */
- (UIBarButtonItem *)barWithIconUnicode:(NSString *)iconCode withTarget:(nullable id)target withSelector:(nullable SEL)selector;

/**
 default pop stack or dismiss event
 */
- (void)defaultGoBackStack;

#pragma mark -- user interface jump hirenic

/**
 make the navigation stack back to the class
 
 @param aClass the class
 */
- (void)backStack2Class:(Class)aClass;

/**
 replace self by the class in current navigation stacks
 
 @param aClass the class to show
 */
- (void)replaceStack4Class:(Class)aClass;

/**
 replace self by the instance in current navigation stacks
 
 @param aInstance the class's instance
 */
- (void)replaceStack4Instance:(UIViewController *)aInstance;

#pragma mark -- handle networking error

/**
 resume one selector while the selector need usr's authorization, and usr authorization successfully!
 */
- (void)resumeCMDWhileAfterUsrAuthorizeSuccess NS_REQUIRES_SUPER;

/**
 handle the error while network activity
 
 @param error the error
 */
- (void)handleNetworkingActivityError:(NSError *)error;

/**
 global alert show
 */
- (void)showAlertWithTitle:(NSString * _Nullable)title withMsg:(NSString * _Nullable)msg whetherShowOK:(BOOL)okShow whetherShowCancel:(BOOL)cancelShow withOKItem:(NSString * _Nullable)ok withOKCompletion:(void(^_Nullable)())okBlock withCancelCompletion:(void(^_Nullable)())cancelBlock;

@end

FOUNDATION_EXPORT CGFloat pb_expectedStatusBarHeight();

FOUNDATION_EXPORT void pb_adjustsScrollViewInsets(UIScrollView * scrollView);

NS_ASSUME_NONNULL_END
