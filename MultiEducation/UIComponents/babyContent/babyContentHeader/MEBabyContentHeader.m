//
//  MEBabyContentHeader.m
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/13.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBabyContentHeader.h"
#import "Meclass.pbobjc.h"
#import "MEBabyIndexVM.h"
#import <SVProgressHUD.h>

@implementation MEBabyContentHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
 
    [self addTapGesture];
}

- (void)addTapGesture {
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(babyContentHeaderTapEvent)];
    [self addGestureRecognizer: tapGes];
}

//if userRole == teacher && user.teacherPb.classArray > 1 , push to select class profile , else push to babyPhotoProfile
- (void)babyContentHeaderTapEvent {
    if (self.currentUser.userType == MEPBUserRole_Teacher) {
        if (self.currentUser.teacherPb.classPbArray.count > 1) {
            NSString *urlString = @"profile://root@METeacherMultiClassTableProfile/";
            NSDictionary *params = @{@"pushUrlStr": @"profile://root@MEBabyPhotoProfile/", @"title": @"宝宝相册"};
            NSError * err = [MEDispatcher openURL:[NSURL URLWithString:urlString] withParams: params];            [MEKits handleError:err];
        } else {
            if (self.currentUser.teacherPb.classPbArray.count > 0) {
                MEPBClass *classPb = self.currentUser.teacherPb.classPbArray[0];
                [self gotoBabyPhotoProfile: classPb];
            } else {
                [MEKits makeToast: ME_ALERT_INFO_NONE_CLASS];
            }
        }
    } else if(self.currentUser.userType == MEPBUserRole_Gardener) {
        if (self.currentUser.deanPb.classPbArray.count > 1) {
            NSString *urlString = @"profile://root@METeacherMultiClassTableProfile/";
            NSDictionary *params = @{@"pushUrlStr": @"profile://root@MEBabyPhotoProfile/", @"title": @"宝宝相册"};
            NSError * err = [MEDispatcher openURL:[NSURL URLWithString:urlString] withParams: params];            [MEKits handleError:err];
        } else {
            if (self.currentUser.deanPb.classPbArray.count > 0) {
                MEPBClass *classPb = self.currentUser.deanPb.classPbArray[0];
                [self gotoBabyPhotoProfile: classPb];
            } else {
                [MEKits makeToast: ME_ALERT_INFO_NONE_CLASS];
            }
        }
    } else {
        GuIndexPb *indexPb = [MEBabyIndexVM fetchSelectBaby];
        MEPBClass *classPb = [[MEPBClass alloc] init];
        if (indexPb) {
            NSInteger classId = indexPb.studentArchives.classId;
            classPb.id_p = classId;
        } else {
            classPb = self.currentUser.parentsPb.classPbArray[0];
        }
        [self gotoBabyPhotoProfile: classPb];
    }
}

- (void)gotoBabyPhotoProfile:(MEPBClass *)classPb {
    void (^DidChangePhotoCallback)(void) = ^() {
        if (self.DidChangePhotoCallback) {
            self.DidChangePhotoCallback();
        }
    };
    //埋点
    [MobClick event:Buried_CLASS_ALBUM];
    NSDictionary *params = @{@"classPb": classPb, @"title": @"宝宝相册", ME_DISPATCH_KEY_CALLBACK: DidChangePhotoCallback};
    NSString *urlString =@"profile://root@MEBabyPhotoProfile";
    NSError * err = [MEDispatcher openURL:[NSURL URLWithString:urlString] withParams:params];
    [MEKits handleError:err];
    
}
@end
