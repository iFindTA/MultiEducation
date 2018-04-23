//
//  MEEditUserDataProfile.h
//  MultiEducation
//
//  Created by 崔小舟 on 2018/4/22.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEBaseProfile.h"
 
typedef NS_ENUM(NSUInteger, MEEditType) {
    MEEditTypeNickName                                 =   1   <<  0,
    MEEditTypeGender                                   =   1   <<  1
};

@interface MEEditUserDataProfile : MEBaseProfile

@end
