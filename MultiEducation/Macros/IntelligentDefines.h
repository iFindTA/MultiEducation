//
//  IntelligentDefines.h
//  MultiIntelligent
//
//  Created by nanhu on 2018/6/21.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#ifndef IntelligentDefines_h
#define IntelligentDefines_h

#if DEBUG
#define ME_APP_ENV                                                      @"lan"
//#define ME_APP_BASE_HOST                                                @"http://192.168.1.199:8080"
#define ME_APP_BASE_HOST                                                @"http://101.132.33.243:443"
//#define ME_APP_BASE_HOST                                                @"http://v3.api.x16.com"
//#define ME_APP_BASE_HOST                                                @"https://v2.api.chinaxqjy.com"
#define ME_WEB_SERVER_HOST                                              @"http://ost.x16.com/open/res"
#define ME_UMENG_APPKEY                                                 @"5b2b61dff29d9803fc00002a"
#define ME_RONGIM_APPKEY                                                @"82hegw5u8yrnx"//
#else
#define ME_APP_ENV                                                      @"prod"
#define ME_APP_BASE_HOST                                                @"http://dv2.api.chinaxqjy.com:445"
#define ME_WEB_SERVER_HOST                                              @"http://ost.x16.com/open/res"
#define ME_UMENG_APPKEY                                                 @"5b2b61dff29d9803fc00002a"
#define ME_RONGIM_APPKEY                                                @"8w7jv4qb82oxy"//prod

#endif

#endif /* IntelligentDefines_h */
