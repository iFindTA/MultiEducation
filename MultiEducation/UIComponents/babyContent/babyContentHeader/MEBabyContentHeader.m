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
            NSError * err = [MEDispatcher openURL:[NSURL URLWithString:urlString] withParams: nil];
            [self handleTransitionError:err];
        } else {
            NSNumber *classId = [NSNumber numberWithInteger: self.currentUser.teacherPb.classPbArray[0].id_p];
            NSDictionary *params = @{@"classId": classId};
            NSString *urlString =@"profile://root@MEBabyPhotoProfile";
            NSError * err = [MEDispatcher openURL:[NSURL URLWithString:urlString] withParams:params];
            [self handleTransitionError:err];
        }
    } else if(self.currentUser.userType == MEPBUserRole_Gardener) {
        if (self.currentUser.deanPb.classPbArray.count > 1) {
            
            NSString *urlString = @"profile://root@METeacherMultiClassTableProfile/";
            NSError * err = [MEDispatcher openURL:[NSURL URLWithString:urlString] withParams: nil];
            [self handleTransitionError:err];
            
        } else {
            NSNumber *classId = [NSNumber numberWithInteger: self.currentUser.deanPb.classPbArray[0].id_p];
            NSDictionary *params = @{@"classId": classId};
            NSString *urlString =@"profile://root@MEBabyPhotoProfile";
            NSError * err = [MEDispatcher openURL:[NSURL URLWithString:urlString] withParams:params];
            [self handleTransitionError:err];
        }
    } else {
        
        GuIndexPb *indexPb = [MEBabyIndexVM fetchSelectBaby];
        NSNumber *classId;
        if (indexPb) {
            classId = [NSNumber numberWithLongLong: indexPb.studentArchives.classId];
        } else {
            classId = [NSNumber numberWithInteger: self.currentUser.parentsPb.classPbArray[0].id_p];
        }
        NSDictionary *params = @{@"classId": classId};
        NSString *urlString =@"profile://root@MEBabyPhotoProfile";
        NSError * err = [MEDispatcher openURL:[NSURL URLWithString:urlString] withParams:params];
        [self handleTransitionError:err];
    }
}

@end
