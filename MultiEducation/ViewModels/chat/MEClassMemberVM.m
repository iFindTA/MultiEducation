//
//  MEClassMemberVM.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/24.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEClassMemberVM.h"

@implementation MEClassMemberVM

- (NSString *)cmdCode {
    return @"FSC_CLASS_USER_LIST";
}

+ (int64_t)fetchMaxTimestamp4ClassID:(int64_t)classID {
    int64_t timestamp = 0;
    MEPBUser *user = [self currentUser];
    NSString *sql = PBFormat(@"classId = %lld AND ownerId = %lld", classID, user.uid);
    NSArray<MEClassMember*>* members = [WHCSqlite query:MEClassMember.self where:sql order:@"by timestamp desc" limit:@"1"];
    if (members.count > 0) {
        timestamp = members.firstObject.timestamp;
    }
    
    return timestamp;
}

+ (NSArray<MEClassMember*>*)fetchClassMembers4ClassID:(int64_t)classID {
    MEPBUser *user = [self currentUser];
    NSString *sql = PBFormat(@"classId = %lld AND ownerId = %lld", classID, user.uid);
    NSArray<MEClassMember*>* members = [WHCSqlite query:MEClassMember.self where:sql];
    return members;
}

+ (BOOL)saveClassMembers:(NSArray<MEClassMember *> *)members {
    MEPBUser *user = [self currentUser];
    BOOL ret = true;
    for (MEClassMember *member in members) {
        if (member.status == 1) {
            member.ownerId = user.uid;
            ret &= [WHCSqlite insert:member];
        } else {
            NSString *sql = PBFormat(@"classId = %lld AND ownerId = %lld AND id_p = %lld", member.classId, user.uid, member.id_p);
            ret &= [WHCSqlite delete:MEClassMember.self where:sql];
        }
    }
    return ret;
}

+ (NSArray<MEClassMember*> *)fetchClassMember4MemberID:(ino64_t)mid {
    MEPBUser *user = [self currentUser];
    NSString *sql = PBFormat(@"id_p = %lld AND ownerId = %lld", mid, user.uid);
    NSArray<MEClassMember*>* members = [WHCSqlite query:MEClassMember.self where:sql];
    return members;
}

@end
