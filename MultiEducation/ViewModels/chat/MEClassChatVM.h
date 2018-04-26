//
//  MEClassChatVM.h
//  MultiEducation
//
//  Created by nanhu on 2018/4/25.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEVM.h"
#import "Mesession.pbobjc.h"
#import "MeclassChat.pbobjc.h"
#import "MesessionList.pbobjc.h"

@interface MEClassChatVM : MEVM

/**
 根据class ID 获取该班级班聊目前最大的时间戳
 */
+ (int64_t)fetchMaxClassSessionTimestamp4ClassID:(int64_t)classID;

/**
 根据class ID 获取班级所有班聊会话
 */
+ (NSArray<MECSession*>*)fetchClassChatSessions4ClassID:(int64_t)classID;

/**
 保存班级所有会话session
 */
+ (BOOL)saveClassChatSessions:(NSArray<MECSession*>*)sessions;

/**
 根据session ID 获取所有class session
 */
+ (NSArray<MECSession*>*)fetchClassChatSession4SessionID:(int64_t)sid;

@end
