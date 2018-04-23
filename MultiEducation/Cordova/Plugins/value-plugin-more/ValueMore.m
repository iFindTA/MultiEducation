//
//  ValueMore.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/23.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "ValueMore.h"
#import "MEHybridBaseProfile.h"

@implementation ValueMore

- (void)setingRightBtn:(CDVInvokedUrlCommand *)cmd {
    UIViewController *profile = self.viewController;
    MEHybridBaseProfile *hybridProfile = (MEHybridBaseProfile *)profile;
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    if (hybridProfile) {
        NSArray<NSString*>*args = cmd.arguments;
        if (args.count >= 2) {
            NSString *title = args.firstObject;
            NSString *action = args[1];
            [hybridProfile updateMoreActionTitle:title callbackMethod:action];
        }
        
    }
    [self.commandDelegate sendPluginResult:result callbackId:cmd.callbackId];
}

@end
