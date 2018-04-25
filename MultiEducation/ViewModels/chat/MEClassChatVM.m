//
//  MEClassChatVM.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/25.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEClassChatVM.h"

@implementation MEClassChatVM

- (NSString *)cmdCode {
    return @"FSC_CLASS_SESSION_LIST";
}

+ (int64_t)fetchMaxClassSessionTimestamp4ClassID:(int64_t)classID {
    int64_t timestamp = 0;
    NSString *sql = PBFormat(@"classId = %lld", classID);
    NSArray<MECSession*>* sessions = [WHCSqlite query:MECSession.self where:sql order:@"by timestamp desc" limit:@"1"];
    if (sessions.count > 0) {
        timestamp = sessions.firstObject.timestamp;
    }
    
    return timestamp;
}

+ (NSArray<MECSession*>*)fetchClassChatSessions4ClassID:(int64_t)classID {
    NSString *sql = PBFormat(@"classId = %lld", classID);
    NSArray<MECSession*>* sessions = [WHCSqlite query:MECSession.self where:sql order:@"by timestamp desc" limit:@"1"];
    return sessions;
}

+ (BOOL)saveClassChatSessions:(NSArray<MECSession *> *)sessions {
    BOOL ret = true;
    for (MECSession *s in sessions) {
        NSString *sql = PBFormat(@"classId = %lld AND id_p = %lld", s.classId, s.id_p);
        NSArray<MECSession*>* exists = [WHCSqlite query:MECSession.self where:sql limit:@"1"];
        if (exists.count > 0) {
            NSString *value = PBFormat(@"name = %@, createdDate = %lld, user = %@, sessionStatus = %d", PBAvailableString(s.name), s.createdDate, s.userArray, s.sessionStatus);
            ret &= [WHCSqlite update:MECSession.self value:value where:sql];
        } else {
            ret &= [WHCSqlite insert:s];
        }
    }
    return ret;
}

+ (NSArray<MECSession*>*)fetchClassChatSession4SessionID:(int64_t)sid {
    NSString *sql = PBFormat(@"id_p = %lld", sid);
    NSArray<MECSession*>* sessions = [WHCSqlite query:MECSession.self where:sql];
    return sessions;
}

@end
