#import "ValueEnv.h"

@implementation ValueEnv

- (void)getEnvData:(CDVInvokedUrlCommand *)command {
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:envProperties];
    [self.commandDelegate runInBackground:^{
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
    //[[NSNotificationCenter defaultCenter] postNotificationName:MSG_SNS_UNREAD_COUNT object:nil];
}

+ (void)setKey:(NSString *)key value:(NSString *)value {
    if (envProperties == nil) {
        envProperties = [[NSMutableDictionary alloc] init];
    }
    envProperties[key] = value;
}

@end
