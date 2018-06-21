//
//  MulticastDefines.h
//  MultiEducation
//
//  Created by nanhu on 2018/6/21.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#ifndef MulticastDefines_h
#define MulticastDefines_h

#if DEBUG
#define ME_APP_ENV                                                      @"lan"
//#define ME_APP_BASE_HOST                                                @"http://192.168.1.199:8080"
#define ME_APP_BASE_HOST                                                @"http://101.132.33.243:443"
//#define ME_APP_BASE_HOST                                                @"http://v3.api.x16.com"
//#define ME_APP_BASE_HOST                                                @"https://v2.api.chinaxqjy.com"
#define ME_WEB_SERVER_HOST                                              @"http://ost.x16.com/open/res"
#define ME_UMENG_APPKEY                                                 @"56fa2db6e0f55ace0f0030c5"
//#define ME_RONGIM_APPKEY                                                @"mgb7ka1nm4whg"//dev
#define ME_RONGIM_APPKEY                                                @"6tnym1br64577"//
#else
#define ME_APP_ENV                                                      @"prod"
#define ME_APP_BASE_HOST                                                @"http://101.132.33.243:443"
#define ME_WEB_SERVER_HOST                                              @"http://ost.x16.com/open/res"
#define ME_UMENG_APPKEY                                                 @"5aa770eaa40fa32b340000e1"
#define ME_RONGIM_APPKEY                                                @"6tnym1br64577"//prod

#endif

#endif /* MulticastDefines_h */
