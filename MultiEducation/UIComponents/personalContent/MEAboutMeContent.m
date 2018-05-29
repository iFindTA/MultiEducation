//
//  MEAboutMeContent.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/23.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEAboutMeContent.h"

@implementation MEAboutMeContent

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"]lastObject];
    self.appIcon.image = [UIImage imageNamed: icon];
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSString *buildVersion = [infoDic pb_stringForKey:@"CFBundleVersion"];
    NSString *env;
#if DEBUG
    env = @"dev";
#else
    env = @"prod";
#endif
    self.appVersion.text = [NSString stringWithFormat: @"多元幼教%@-%@-%@", appVersion, buildVersion, env];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(qrCodeTapEvent)];
    self.qrCodeShare.userInteractionEnabled = YES;
    [self.qrCodeShare addGestureRecognizer: tapGes];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy";
    
    NSString *year = [formatter stringFromDate: [NSDate date]];
    
    self.cpyRightLab.text = [NSString stringWithFormat: @"Copyright @ %@", year];
}

- (void)qrCodeTapEvent {
    NSString *urlStr = @"profile://root@MEQRCodeShareProfile/";
    NSError *error = [MEDispatcher openURL: [NSURL URLWithString: urlStr] withParams: nil];
    [MEKits handleError: error];
}

- (IBAction)agreementAndProtocolTouchEvent:(MEBaseButton *)sender {
    NSLog(@"使用条款和隐私");
}





@end
