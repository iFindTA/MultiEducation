//
//  PBService.m
//  PBNetService
//
//  Created by nanhu on 2018/4/5.
//  Copyright © 2018年 nanhujiaju. All rights reserved.
//

#import "PBService.h"
#import "NSURLSessionTask+PBHelper.h"
#import <SVProgressHUD/SVProgressHUD.h>

/**
 excute block func in main tread
 
 @param block to be excuted
 */
static void excuteInMainThread(void(^block)()) {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

@interface PBService ()

@property (nonatomic, assign, readwrite) PBNetState netState;

@end

static PBService * instance = nil;

static NSString *globalHostString = nil;
//正常响应的情况下的code
unsigned int const PB_NETWORK_RESPONSE_CODE_SUCCESS =       0;
static NSString *kNetworkPingHost                   =       @"www.baidu.com";

static NSString *kNetworkDisable                    =       @"当前网络不可用，请检查网络设置！";
static NSString *kNetworkWorking                    =       @"请稍后...";

@implementation PBService

+ (void)configBaseURL:(NSString *)url {
    NSAssert(url.length != 0, @"base url can not be nil!");
    globalHostString = url.copy;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        //TODO:custmize optional
    }
    return self;
}

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[PBService alloc] initWithBaseURL:[NSURL URLWithString:globalHostString]];
        }
    });
    return instance;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        //request serializer, can be set with HTTP's header
        AFHTTPRequestSerializer *req_serial = [AFHTTPRequestSerializer serializer];
        //req_serial.timeoutInterval = configuration.timeoutInterval;
        [req_serial setValue:@"application/x-protobuf" forHTTPHeaderField:@"Accept"];
        //[req_serial setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        req_serial.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", nil];
        self.requestSerializer = req_serial;
        //*
        //response serializer, can be set with HTTP's accept type
        AFHTTPResponseSerializer *res_serial = [AFHTTPResponseSerializer serializer];
        //res_serial.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/plain", @"text/javascript",@"text/html", nil];
        res_serial.acceptableContentTypes = [res_serial.acceptableContentTypes setByAddingObject:@"application/x-protobuf"];
        //res_serial.acceptableStatusCodes = [NSIndexSet indexSetWithIndex:400];
        self.responseSerializer = res_serial;
        //*/
        
        //双向认证 安全设置
        //NSSet *certs = [AFSecurityPolicy certificatesInBundle:[NSBundle mainBundle]];
        //security policy
        AFSecurityPolicy *sec_policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        //允许非权威机构颁发的证书
        sec_policy.allowInvalidCertificates = true;
        //验证域名一致性
        sec_policy.validatesDomainName = false;
        //sec_policy.pinnedCertificates = certs;
        self.securityPolicy = sec_policy;
        
        //check for ping
        NSString *pingH = kNetworkPingHost.copy;
        AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager managerForDomain:pingH];
        
        //check for timeout interval
        instance.requestSerializer.timeoutInterval = 30.f;
        
        //setup net check
        [manager startMonitoring];
        //usleep(150000);
        //instance.netState = FLKNetStateUnknown;
        AFNetworkReachabilityStatus status = [manager networkReachabilityStatus];
        [self updateNetworkState:status];
        __weak typeof(instance) weakSelf = instance;
        [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            [weakSelf updateNetworkState:status];
        }];
        
    }
    return self;
}

- (void)setAuthorization:(NSString *)info forKey:(NSString *)key {
    [self.requestSerializer setValue:info forHTTPHeaderField:key];
}

- (void)setAuthorizationWithUsername:(NSString *)username password:(NSString *)password {
    [self.requestSerializer setAuthorizationHeaderFieldWithUsername:username password:password];
}

#pragma mark -- network state changed

- (void)updateNetworkState:(AFNetworkReachabilityStatus)status {
    PBNetState aState = 1 << (status + 1);
    //NSLog(@"network state:%zd", aState);
    //check network balance when net state become avaliable from unavaliable
    if ((status &(PBNetStateViaWWAN|PBNetStateViaWiFi))
        && (self.netState & (PBNetStateUnknown|PBNetStateUnavaliable))) {
        self.netState = aState;
        //[self loadNetworkBalance];
        return;
    }
    self.netState = aState;
}

- (BOOL)netvalid {
    return /*(self.netState != FLKNetStateUnknown) &&//*/ (self.netState != PBNetStateUnavaliable);
}

#pragma mark -- request cancel method

- (void)cancelAllRequest {
    //url session's tasks include:dataTasks/uploadTasks/downloadTasks
    NSArray *tasks = self.tasks;
    if (tasks.count == 0) {
        return;
    }
    for (NSURLSessionDataTask *task in tasks) {
        [task cancel];
    }
}

- (void)cancelRequestForClass:(Class)aClass {
    if (aClass == nil) {
        return;
    }
    //url session's tasks include:dataTasks/uploadTasks/downloadTasks
    NSArray *tasks = self.tasks;
    if (tasks.count == 0) {
        return;
    }
    NSString *classString = NSStringFromClass(aClass);
    for (NSURLSessionDataTask *task in tasks) {
        NSString *taskDesc = task.pb_taskIdentifier;
        if (taskDesc.length > 0 && [taskDesc rangeOfString:classString].location != NSNotFound) {
            [task cancel];
        }
    }
}

#pragma mark -- handle request pre start

- (BOOL)whetherRequestShouldContinueWithHudEnable:(BOOL)hud {
    //step 1: check the network state
    if (![self netvalid]) {
        excuteInMainThread(^{
            [SVProgressHUD showErrorWithStatus:kNetworkDisable];
        });
        return false;
    }
    
    //step 2: display the hud while netwoking
    if (hud) {
        excuteInMainThread(^{
            [SVProgressHUD showWithStatus:kNetworkWorking];
        });
    }
    
    return true;
}

/**
 针对国行启动无网
 */
- (void)challengePermissionWithResponse:(void (^)(id _Nullable, NSError * _Nullable))response {
    // 1.创建一个网络路径
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", kNetworkPingHost]];
    // 2.创建一个网络请求
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务：
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable res, NSError * _Nullable error) {
        NSLog(@"challenge with error:%@", error.localizedDescription);
        /*
         对从服务器获取到的数据data进行相应的处理：
         */
        NSDictionary *dict = nil;
        if (data != nil) {
            dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
        }
        if (response) {
            response(dict, error);
        }
    }];
    // 5.最后一步，执行任务（resume也是继续执行）:
    [sessionDataTask resume];
}

#pragma mark -- handle request response
- (void)test4Protobuf {
    NSString *test = @"hello,world";
    NSData *data = [test dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/app", self.baseURL.absoluteString]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-protobuf" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    //_manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURLSessionDataTask *task = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse *_Nonnull response, id _Nullable responseObject, NSError *_Nullable error) {
        NSLog(@"http resp %@----error:%@", responseObject, error.description);
        
    }];
    [task resume];
    
}

- (void)POSTData:(NSData *)data classIdentifier:(nonnull Class)cls hudEnable:(BOOL)hud success:(void (^ _Nullable)(NSURLSessionDataTask * _Nullable, id _Nullable))success failure:(void (^ _Nullable)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    //step 1: check the network state
    if (![self whetherRequestShouldContinueWithHudEnable:hud]) {
        //408 request time out!
        NSError *error = [NSError errorWithDomain:kNetworkDisable code:408 userInfo:nil];
        if (failure) {
            failure(nil, error);
        }
        return;
    }
    //step2 send request
    void (^successResponse)(NSURLSessionDataTask * _Nullable, id _Nullable) = [self successOnRequestWithSuccess:success andFailure:failure hudEnable:hud];
    void (^failureReponse)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull) = [self failureOnRequestWithFailure:failure hudEnable:hud];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/app", self.baseURL.absoluteString]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-protobuf" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    //_manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSURLSessionDataTask *dataTask = [self dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
#if DEBUG
        NSLog(@"http resp %@----error:%@", responseObject, error.description);
#endif
        if (error) {
            failureReponse(nil, error);
        } else {
            successResponse(nil, responseObject);
        }
    }];
    //step 5: store the vcr's class charator for canceling action some where.
    if (cls != nil) {
        dataTask.pb_taskIdentifier = [NSString stringWithFormat:@"class_%@_request", NSStringFromClass(cls)];
    }
    [dataTask resume];
}

#pragma mark -- handle request response block

- (void (^)(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject))successOnRequestWithSuccess:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success andFailure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure hudEnable:(BOOL)hud {
    
    void (^response)(NSURLSessionDataTask * _Nullable, id _Nullable) = ^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject){
        
        //dismiss the hud
        if (hud) {
            excuteInMainThread(^{
                [SVProgressHUD dismiss];
            });
        }
        if (success) {
            success(task, responseObject);
        }
    };
    
    return response;
}

- (void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureOnRequestWithFailure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure hudEnable:(BOOL)hud {
    
    void (^response)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull) = ^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error){
        
        //dismiss the hud
        if (hud) {
            excuteInMainThread(^{
                [SVProgressHUD dismiss];
            });
        }
        if (failure) {
            failure(task, error);
        }
    };
    
    return response;
}

@end
