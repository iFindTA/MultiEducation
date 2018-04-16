//
//  MEDispatcher.h
//  MultiEducation
//
//  Created by nanhu on 2018/4/5.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MEDispatcher : NSObject

/**
 将map转换为query string， 可按照字典排序
 */
+ (NSString * _Nullable)convertMap2QueryString:(NSDictionary * _Nonnull)map sort:(BOOL)sort;

/**
 profile 组建URL

 @param cls 类
 @param method 初始化方法 可传参数
 @param params 可以传递的参数
 @param type 创建类型 默认code 1<<2
 @return profile
 */
+ (NSURL * _Nullable)profileUrlWithClass:(NSString *_Nonnull)cls initMethod:(NSString * _Nullable)method params:(NSDictionary * _Nullable)params instanceType:(uint)type;

/**
 全局调度

 @param url
 profile://(alert:// or do://)root(cur代表当前显示的profile).className.code(xib/sb)/initMethod,?p=v&p=v#ancho
 @param params 可选,譬如弹框一般为了再次显示页面可以携带nextRoute=url参数
 @return 是否成功调用, nil代表成功
 */
+ (NSError * _Nullable)openURL:(NSURL * _Nonnull)url withParams:(NSDictionary * _Nullable)params;

+ (NSError * _Nullable)openURL:(NSURL * _Nonnull)url withCallback:(void(^)())block;



@end
