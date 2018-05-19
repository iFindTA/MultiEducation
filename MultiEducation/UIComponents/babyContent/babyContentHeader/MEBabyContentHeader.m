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
            NSInteger classId = self.currentUser.teacherPb.classPbArray[0].id_p;
            [self gotoBabyPhotoProfile: classId];
        }
    } else if(self.currentUser.userType == MEPBUserRole_Gardener) {
        if (self.currentUser.deanPb.classPbArray.count > 1) {
            NSString *urlString = @"profile://root@METeacherMultiClassTableProfile/";
            NSDictionary *params = @{@"pushUrlStr": @"profile://root@MEBabyPhotoProfile/", @"title": @"宝宝相册"};
            NSError * err = [MEDispatcher openURL:[NSURL URLWithString:urlString] withParams: params];            [MEKits handleError:err];
            
        } else {
            NSInteger classId =  self.currentUser.deanPb.classPbArray[0].id_p;
            [self gotoBabyPhotoProfile: classId];
        }
    } else {
        GuIndexPb *indexPb = [MEBabyIndexVM fetchSelectBaby];
        NSInteger classId;
        if (indexPb) {
            classId = indexPb.studentArchives.classId;
        } else {
            classId = self.currentUser.parentsPb.classPbArray[0].id_p;
        }
        [self gotoBabyPhotoProfile: classId];
    }
}

- (void)gotoBabyPhotoProfile:(NSInteger)classId {
    void (^DidChangePhotoCallback)(void) = ^() {
        if (self.DidChangePhotoCallback) {
            self.DidChangePhotoCallback();
        }
    };
    //埋点
    [MobClick event:Buried_CLASS_ALBUM];
    NSDictionary *params = @{@"classId": [NSNumber numberWithInteger: classId], @"title": @"宝宝相册", ME_DISPATCH_KEY_CALLBACK: DidChangePhotoCallback};
    NSString *urlString =@"profile://root@MEBabyPhotoProfile";
    NSError * err = [MEDispatcher openURL:[NSURL URLWithString:urlString] withParams:params];
    [MEKits handleError:err];
    
}
@end
