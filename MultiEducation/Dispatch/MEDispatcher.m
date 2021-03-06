//
//  MEDispatcher.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/5.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "VKMsgSend.h"
#import "MEDispatcher.h"
#import <objc/runtime.h>
#import "AppDelegate.h"
#import "MENotFoundProfile.h"
#import <PBMediator/PBRunner.h>
#import "MEBaseTabBarProfile.h"
#import "MEBaseNavigationProfile.h"
#import <NSURL+QueryDictionary/NSURL+QueryDictionary.h>

static NSMutableDictionary *cachedTarget;

@implementation MEDispatcher

+ (NSString * _Nullable)fetchInitializedMethod4Class:(Class)cls {
    if (!cls) {
        return nil;
    }
    NSMutableArray <NSString *>*allMethods = [NSMutableArray arrayWithCapacity:0];
    //获取方法列表
    unsigned int mothCout_f =0;
    Method* mothList_f = class_copyMethodList(cls,&mothCout_f);
    for(int i=0;i<mothCout_f;i++) {
        Method temp_f = mothList_f[i];
        //        int arguments = method_getNumberOfArguments(temp_f);
        //        const char* encoding =method_getTypeEncoding(temp_f);
        //        SEL name_f = method_getName(temp_f);
        const char* name_s =sel_getName(method_getName(temp_f));
        NSString *sel_name = [NSString stringWithUTF8String:name_s];
        //NSLog(@"方法名：%@,参数个数：%d,编码方式：%@",[NSString stringWithUTF8String:name_s],arguments,[NSString stringWithUTF8String:encoding]);
        [allMethods addObject:sel_name];
    }
    free(mothList_f);
    NSString *initMethod = nil;
    for (NSString * tmp in allMethods ) {
        if ([tmp hasPrefix:@"__initWith"]) {
            initMethod = tmp;
            break;
        }
    }
    return initMethod;
}

+ (AppDelegate *)app {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

//获取Window当前显示的ViewController
+ (UIViewController*)currentViewController {
    //获得当前活动窗口的根视图
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1) {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}

/**
 根据type决定是从根视图切换 还是从当前显示的视图切换 默认根视图
 */
+ (UIViewController *)fetchStartNavigationProfile4Type:(NSString *)type {
    //空值 root 或用户未登录均返回根视图
    if (type.length == 0 || [type isEqualToString:@"root"] || !self.app.curUser) {
        return self.app.winProfile;
    }
    if ([type isEqualToString:@"cur"]) {
        UIViewController *profile = [self currentViewController];
        return profile;
    }
    
    return self.app.winProfile;
}

+ (UIViewController *)generateNotFoundProfile {
    MENotFoundProfile *profile = [[MENotFoundProfile alloc] init];
    return profile;
}

+ (NSError *)errorWirhInfo:(NSString *)info {
    NSString *alert = [NSString stringWithFormat:@"MEDispatcher Error: %@", info];
    return [NSError errorWithDomain:alert code:-1000 userInfo:nil];
}

+ (NSError * _Nullable)openURL:(NSURL *)url withParams:(NSDictionary *)params {
    NSError *err = nil;
    if (url.absoluteString.length == 0) {
        err = [self errorWirhInfo:@"url route params error!"];
        return err;
    }
    //pre deal with params
    NSMutableDictionary *passParams = [NSMutableDictionary dictionaryWithCapacity:0];
    if (params) {
        [passParams addEntriesFromDictionary:params];
    }
    /**
     * profile://(alert:// or do://)root(cur代表当前显示的profile)@className/initMethod,?p=v&p=v#code(xib/sb)
     */
    //parser url
    NSString *scheme = [url scheme];
    if ([scheme isEqualToString:@"profile"]) {
        //呈现新的页面
        
        //step1 解析class
        NSString *clsString = [url host];
        if (clsString.length == 0) {
            err = [self errorWirhInfo:@"url route host error!"];
            goto error_occour;
        }
        
        //step3 查询创建方式 code/xib/sb 默认code 创建实例
        NSString *createType = [url fragment];
        UIViewController *profile = nil;
        if ([createType isEqualToString:@"xib"]) {
            
        } else if ([createType isEqualToString:@"sb"]) {
            
        } else {
            // 代码创建实例
            NSDictionary *queryParams = [url uq_queryDictionary];
            if (queryParams.allKeys.count > 0) {
                [passParams addEntriesFromDictionary:queryParams];
            }
            // 查找出初始化方法
            NSString *initMethod = [url path];
            NSString *regString = @"^(__initWith).*$";
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regString];
            if (![predicate evaluateWithObject:regString]) {
                if (passParams.allKeys.count == 0) {
                    //如果没有传递参数 则忽略初始化方法 直接指定为默认init
                    initMethod = @"init";
                } else {
                    //有参数则查找是否定义了初始化方法
                    Class cls = NSClassFromString(clsString);
                    if (cls) {
                        NSString *queryMethod = [self fetchInitializedMethod4Class:cls];
                        if (queryMethod.length > 0 || [queryMethod hasSuffix:@":"]) {
                            //找到了相关的方法
                            initMethod = queryMethod.copy;
                        } else {
                            err = [self errorWirhInfo:@"url route path or host error!"];
                            goto error_occour;
                        }
                    }
                }
            }
            
            if (clsString && initMethod) {
                NSError *error = nil;
                id aDester = [clsString pb_generateInstanceByInitMethod:initMethod withError:&error,passParams];
                //id aDester = [self performTarget:clsString action:initMethod params:params shouldCacheTarget:false];
                //id aDester = [clsString VKCallClassAllocInitSelectorName:initMethod error:&error, passParams];
                if (!error && aDester != nil) {
                    if ([aDester isKindOfClass:[UIViewController class]]) {
                        profile = (UIViewController *)aDester;
                    }
                }else{
                    NSLog(@"error:%@",error.localizedDescription);
                    err = [self errorWirhInfo:@"url route params error!"];
                    goto error_occour;
                }
            }
        }
        if (!profile) {
            profile = [self generateNotFoundProfile];
        }
        //step4 display
        NSString *root = [url user];
        UIViewController *startTarget = [self fetchStartNavigationProfile4Type:root];
        Class naviClass = [UINavigationController class];
        if ([startTarget isKindOfClass:naviClass] || [startTarget isMemberOfClass:naviClass]) {
            UINavigationController *naviTarget = (UINavigationController *)startTarget;
            [naviTarget pushViewController:profile animated:true];
        } else if (startTarget.navigationController) {
            [startTarget.navigationController pushViewController:profile animated:true];
        } else {
            [startTarget presentViewController:profile animated:true completion:nil];
        }
    } else if ([scheme isEqualToString:@"alert"]) {
        //弹框
    } else if ([scheme isEqualToString:@"do"]) {
        //静默做一些事情
    } else if ([scheme isEqualToString:@"kickout"]){
        //用户被顶替 登出
        NSString *msg = [params pb_stringForKey:@"alert"];
        [self.app passiveLogout:msg];
    } else {
        //TODO:上报error
    }
    
error_occour:{
    return err;
}
    
    return nil;
}

#pragma mark --- Util Kit Methods

+ (NSString * _Nullable)convertMap2QueryString:(NSDictionary *)map sort:(BOOL)sort {
    if (map) {
        return [map uq_URLQueryStringWithSortedKeys:sort];
    }
    return nil;
}

+ (NSURL * _Nullable)profileUrlWithClass:(NSString *)cls initMethod:(NSString *)method params:(NSDictionary *)params instanceType:(uint)type {
    NSURL *url = nil;
    if (cls.length == 0) {
        return url;
    }
    if (method.length == 0) {
        method = @"";
    }
    NSString *queryString = @"";
    if (params.allKeys.count > 0) {
        queryString = [self convertMap2QueryString:params sort:true].copy;
    }
    NSString *fragment = @"code";
    if (type & MEProfileTypeSB) {
        fragment = @"sb";
    } else if (type & MEProfileTypeXIB) {
        fragment = @"xib";
    }
    //assemble
    NSString *urlString;
    if (!queryString || queryString.length == 0) {
        urlString = [NSString stringWithFormat:@"profile://root@%@/%@#%@", cls, method, fragment];
    } else {
        urlString = [NSString stringWithFormat:@"profile://root@%@/%@?%@#%@", cls, method, queryString, fragment];
    }
    
    url = [NSURL URLWithString:urlString];
    
    return url;
}

#pragma mark


+ (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget {
    
    NSString *targetClassString = targetName.copy;
    NSString *actionString = actionName.copy;
    Class targetClass;
    
    //NSObject *target = self.cachedTarget[targetClassString];
    NSObject *target = nil;
    if (target == nil) {
        targetClass = NSClassFromString(targetClassString);
        target = [targetClass alloc];
    }
    
    SEL action = NSSelectorFromString(actionString);
    
    if (target == nil) {
        // 这里是处理无响应请求的地方之一，这个demo做得比较简单，如果没有可以响应的target，就直接return了。实际开发过程中是可以事先给一个固定的target专门用于在这个时候顶上，然后处理这种请求的
        return nil;
    }
    
    if ([target respondsToSelector:action]) {
        return [self safePerformAction:action target:target params:params];
    } else {
        NSLog(@"error for call");
    }
    return nil;
}

#pragma mark - private methods
+ (id)safePerformAction:(SEL)action target:(NSObject *)target params:(NSDictionary *)params
{
    
    NSMethodSignature* methodSig = [target methodSignatureForSelector:action];
    if(methodSig == nil) {
        return nil;
    }
    const char* retType = [methodSig methodReturnType];
    
    if (strcmp(retType, @encode(void)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        return nil;
    }
    
    if (strcmp(retType, @encode(NSInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(BOOL)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        BOOL result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(CGFloat)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        CGFloat result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(NSUInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSUInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
}

@end
