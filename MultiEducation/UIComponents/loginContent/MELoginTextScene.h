//
//  MELoginTextScene.h
//  fsc-ios-wan
//
//  Created by iketang_imac01 on 2018/4/11.
//  Copyright © 2018年 laborc. All rights reserved.
//

#import "MEBaseScene.h"

typedef NS_ENUM(NSUInteger, TextSceneActionType) {
    TextSceneActionTypeTextChange                                  =   1   <<  0,//输入文字变化
    TextSceneActionTypeCodeBtnClick                                =   1   <<  1,//点击获取验证码
};

typedef NS_ENUM(NSUInteger, TextSceneType) {
    TextSceneTypeAccNum                                  =   1   <<  0,//账户
    TextSceneTypeCodeGet                                 =   1   <<  1,//点击获取验证码
    TextSceneTypeScrNum                                  =   1   <<  2,//密码
};

typedef void (^MELoginTextBtnClick)(TextSceneActionType actionType, TextSceneType textType, NSString *text);

@interface MELoginTextScene : MEBaseScene <UITextFieldDelegate>

@property (nonatomic, copy) MELoginTextBtnClick loginTextClick;

@property (nonatomic, assign) TextSceneType textType;

- (instancetype)initWithImageNme:(NSString *)imgName andPlaceHolder:(NSString *)placeHolder andCodeBtnTitle:(NSString *)btnTitle;

- (void)setCodeBtnTitle:(NSString *)btnTitle;

@end
