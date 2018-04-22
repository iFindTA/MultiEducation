#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>

static NSMutableDictionary* envProperties = nil;

@interface ValueEnv : CDVPlugin {

}

+ (void)setKey:(NSString *)key value:(NSString *)value;

//接口方法， command.arguments[0]获取前端传递的参数
- (void)getEnvData:(CDVInvokedUrlCommand*)command;

@end
