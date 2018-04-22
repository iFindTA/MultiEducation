#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>

@interface ValueClose : CDVPlugin {

}
//接口方法， command.arguments[0]获取前端传递的参数
- (void)execute:(CDVInvokedUrlCommand*)command;

@end
