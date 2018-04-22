#import "ValueClose.h"

@implementation ValueClose

- (void)execute:(CDVInvokedUrlCommand*)command {
    [self.viewController.navigationController popViewControllerAnimated:YES];
}

@end
