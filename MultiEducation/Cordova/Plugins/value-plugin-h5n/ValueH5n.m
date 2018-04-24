#import "MEKits.h"
#import "ValueH5n.h"

@implementation ValueH5n

- (void)nav:(CDVInvokedUrlCommand *)command {
    NSArray <NSString*>*args = command.arguments;
    if (args.count > 0) {
        NSString *destRoute = args.firstObject;
        NSString *urlString = @"profile://root@METemplateProfile/__initWithParams:#code";
        NSURL * routeUrl = [NSURL URLWithString:urlString];
        NSDictionary *params = @{ME_CORDOVA_KEY_TITLE:@"园所公告", ME_CORDOVA_KEY_STARTPAGE:destRoute};
        NSError * err = [MEDispatcher openURL:routeUrl withParams:params];
        [MEKits handleError:err];
    }
}

@end
