//
//  MEIMService.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/25.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEKits.h"
#import "MEIMService.h"
#import "AppDelegate.h"
#import "Meuser.pbobjc.h"
#import "MEClassChatVM.h"
#import "MEClassMemberVM.h"
#import <RongIMKit/RongIMKit.h>
#import <RongIMLib/RCStatusDefine.h>

@interface MEIMService () <RCIMUserInfoDataSource, RCIMGroupInfoDataSource, RCIMGroupMemberDataSource, RCIMReceiveMessageDelegate>

@end

static MEIMService *instance = nil;

@implementation MEIMService

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[self alloc] init];
        }
    });
    return instance;
}

- (AppDelegate *)app {
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

- (void)startRongIMService {
    MEPBUser *user = self.app.curUser;
    if (user.isTourist) {
        NSLog(@"当前用户为游客，不用开启融云IM服务！");
        return;
    }
    if (user.rcToken.length == 0) {
        NSLog(@"融云登录失败-------无效的容云token！");
        return ;
    }
    RCConnectionStatus status = [[RCIM sharedRCIM] getConnectionStatus];
    if (status == ConnectionStatus_UNKNOWN ||
        status == ConnectionStatus_Connecting ||
        status == ConnectionStatus_Connected) {
        NSLog(@"融云IM 状态无需重连！");
        //更新未读
        [self.app updateRongIMUnReadMessageCounts];
        return;
    }
    
    weakify(self)
    [[RCIM sharedRCIM] connectWithToken:user.rcToken success:^(NSString *userId) {
        NSLog(@"RongIM登录成功...userId:%@", userId);
        PBMAINDelay(ME_ANIMATION_DURATION, ^{
            strongify(self)
            NSString *portrait = [MEKits imageFullPath:user.portrait];
            [[RCIM sharedRCIM] setCurrentUserInfo:[[RCUserInfo alloc] initWithUserId:PBFormat(@"%lld", user.uid) name:user.name portrait:portrait]];
            [[RCIM sharedRCIM] setUserInfoDataSource:self];
            [[RCIM sharedRCIM] setGroupInfoDataSource:self];
            [[RCIM sharedRCIM] setGroupMemberDataSource:self];
            [[RCIM sharedRCIM] setReceiveMessageDelegate:self];
            //更新未读
            [self.app updateRongIMUnReadMessageCounts];
        });
    } error:^(RCConnectErrorCode status) {
        NSLog(@"登录失败,error status=%ld", (long)status);
    } tokenIncorrect:^{
        NSLog(@"token错误...");
    }];
}

- (void)stopRongIMService {
    [[RCIM sharedRCIM] disconnect:false];
}

#pragma mark --- 融云消息回调
/*!
 获取用户信息
 
 @param userId      用户ID
 @param completion  获取用户信息完成之后需要执行的Block [userInfo:该用户ID对应的用户信息]
 
 @discussion SDK通过此方法获取用户信息并显示，请在completion中返回该用户ID对应的用户信息。
 在您设置了用户信息提供者之后，SDK在需要显示用户信息的时候，会调用此方法，向您请求用户信息用于显示。
 */
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *userInfo))completion {
    MEPBUser *user = self.app.curUser;
    ino64_t fetch_uid = userId.longLongValue;
    RCUserInfo *userInfo = nil;
    if (fetch_uid == user.uid) {
        NSString *portrait = [MEKits imageFullPath:user.portrait];
        userInfo = [[RCUserInfo alloc] initWithUserId:PBFormat(@"%lld", user.uid) name:user.name portrait:portrait];
    } else {
        //获取班级成员
        NSArray<MEClassMember*>*members = [MEClassMemberVM fetchClassMember4MemberID:fetch_uid];
        if (members.count > 0) {
            MEClassMember *member = [members firstObject];
            NSString *avatar = [MEKits imageFullPath:member.portrait];
            userInfo = [[RCUserInfo alloc] initWithUserId:PBFormat(@"%lld", member.id_p) name:PBAvailableString(member.name) portrait:avatar];
        }
    }
    
    PBMAIN(^{
        if (completion) {
            completion(userInfo);
        }
    })
}

/*!
 获取群组信息
 
 @param groupId     群组ID
 @param completion  获取群组信息完成之后需要执行的Block [groupInfo:该群组ID对应的群组信息]
 
 @discussion SDK通过此方法获取用户信息并显示，请在completion的block中返回该用户ID对应的用户信息。
 在您设置了用户信息提供者之后，SDK在需要显示用户信息的时候，会调用此方法，向您请求用户信息用于显示。
 */
- (void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *groupInfo))completion {
    RCGroup *groupInfo = nil;
    NSArray<NSString *> *stringArray = [groupId componentsSeparatedByString:@"-"];
    NSString *groupType = stringArray[0];
    int64_t session_id = [stringArray[1] longLongValue];
    if ([groupType isEqualToString:@"CLASS"]) {
        NSArray<MECSession*>*sessions = [MEClassChatVM fetchClassChatSession4SessionID:session_id];
        for (MECSession *s in sessions) {
            if (s.id_p == session_id) {
                groupInfo = [[RCGroup alloc] initWithGroupId:groupId groupName:s.name portraitUri:@""];
                break;
            }
        }
    }
    PBMAIN(^{
        if (completion) {
            completion(groupInfo);
        }
    })
}

/*!
 获取当前群组成员列表的回调（需要实现用户信息提供者 RCIMUserInfoDataSource）
 
 @param groupId     群ID
 @param resultBlock 获取成功 [userIdList:群成员ID列表]
 */
- (void)getAllMembersOfGroup:(NSString *)groupId result:(void (^)(NSArray<NSString *> *userIdList))resultBlock {
    NSArray <NSString*>*userIDList = nil;
    NSArray<NSString *> *stringArray = [groupId componentsSeparatedByString:@"-"];
    NSString *groupType = stringArray[0];
    int64_t session_id = [stringArray[1] longLongValue];
    if ([groupType isEqualToString:@"CLASS"]) {
        //先根据session id找到classID
        NSArray<MECSession*>*clasSessions = [MEClassChatVM fetchClassChatSession4SessionID:session_id];
        int64_t class_id = 0;
        for (MECSession *s in clasSessions) {
            if (s.id_p == session_id) {
                class_id = s.classId;
                break;
            }
        }
        //再根据class ID 获取班级成员
        NSArray<MEClassMember*>*members = [MEClassMemberVM fetchClassMembers4ClassID:class_id];
        NSMutableArray <NSString*>*tmpIds = [NSMutableArray arrayWithCapacity:0];
        //拼接班级用户
        for (MEClassMember *m in members) {
            [tmpIds addObject:PBFormat(@"%lld", m.id_p)];
        }
        userIDList = tmpIds.copy;
    }
    PBMAIN(^{
        if (resultBlock) {
            resultBlock(userIDList);
        }
    })
}

#pragma mark --- 消息回调

- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
    //NSLog(@"收到了消息!");
    [self.app updateRongIMUnReadMessageCounts];
}

@end
