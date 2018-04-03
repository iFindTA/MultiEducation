//
//  PBNetService.m
//  FLKNetServicePro
//
//  Created by nanhujiaju on 2017/7/19.
//  Copyright © 2017年 nanhu. All rights reserved.
//

#import "PBNetService.h"
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

@interface PBNetService ()

@property (nonatomic, assign, readwrite) PBNetState netState;

@end

static PBNetService * instance = nil;

static NSString *globalHostString = nil;
//正常响应的情况下的code
unsigned int const PB_NETWORK_RESPONSE_CODE_SUCCESS =       0;
static NSString *kNetworkPingHost                   =       @"www.baidu.com";

static NSString *kNetworkDisable                    =       @"当前网络不可用，请检查网络设置！";
static NSString *kNetworkWorking                    =       @"请稍后...";

@implementation PBNetService

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
            instance = [[PBNetService alloc] initWithBaseURL:[NSURL URLWithString:globalHostString]];
        }
    });
    return instance;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        //request serializer, can be set with HTTP's header
        AFJSONRequestSerializer *req_serial = [AFJSONRequestSerializer serializer];
        //req_serial.timeoutInterval = configuration.timeoutInterval;
        //[req_serial setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        //[req_serial setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        req_serial.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", nil];
        self.requestSerializer = req_serial;
        //*
        //response serializer, can be set with HTTP's accept type
        AFJSONResponseSerializer *res_serial = [AFJSONResponseSerializer serializer];
        //res_serial.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/plain", @"text/javascript",@"text/html", nil];
        //res_serial.acceptableStatusCodes = [NSIndexSet indexSetWithIndex:400];
        self.responseSerializer = res_serial;
        //*/
        
        //双向认证 安全设置
        NSSet *certs = [AFSecurityPolicy certificatesInBundle:[NSBundle mainBundle]];
        //security policy
        AFSecurityPolicy *sec_policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
        //允许非权威机构颁发的证书
        sec_policy.allowInvalidCertificates = true;
        //验证域名一致性
        sec_policy.validatesDomainName = false;
        sec_policy.pinnedCertificates = certs;
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

- (BOOL)wetherRequestCanContinueWithView:(UIView * _Nullable)view withHudEnable:(BOOL)hud {
    //step 1: check the network state
    if (![self netvalid]) {
        excuteInMainThread(^{
            [SVProgressHUD showErrorWithStatus:kNetworkDisable];
        });
        return false;
    }
    
    //step 2:check wether there is a view should disable while networking
    if (view != nil) {
        view.userInteractionEnabled = false;
    }
    //step 3: display the hud while netwoking
    if (hud) {
        excuteInMainThread(^{
            [SVProgressHUD showWithStatus:kNetworkWorking];
        });
    }
    
    return true;
}

#pragma mark -- handle request response

- (void (^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject))successOnRequestWithSuccess:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success andFailure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure withInterface:(UIView *)weakView hudEnable:(BOOL)hud {
    
    void (^response)(NSURLSessionDataTask * _Nonnull, id _Nullable) = ^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject){
        //parser response
        if (success) {
            success(task, responseObject);
        }
        
        //reuse user interface acton
        if (weakView) {
            weakView.userInteractionEnabled = true;
        }
        //dismiss the hud
        if (hud) {
            excuteInMainThread(^{
                [SVProgressHUD dismiss];
            });
        }
    };
    
    return response;
}

- (void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureOnRequestWithFailure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure withInterface:(UIView *)weakView hudEnable:(BOOL)hud {
    
    void (^response)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull) = ^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error){
        //reuse user interface acton
        if (weakView) {
            weakView.userInteractionEnabled = true;
        }
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

#pragma mark -- Public Request Methods --
- (void)GET:(NSString *)path parameters:(id)params class:(Class)cls view:(UIView *)view hudEnable:(BOOL)hud progress:(void (^)(NSProgress * _Nonnull progress))downProgress success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    
    //step 1: check the network state
    if (![self wetherRequestCanContinueWithView:view withHudEnable:hud]) {
        //408 request time out!
        NSError *error = [NSError errorWithDomain:kNetworkDisable code:408 userInfo:nil];
        if (failure) {
            failure(nil, error);
        }
        return;
    }
    __weak typeof(view) weakView = view;
    //step 4: make url session data task
    void (^sucessResponse)(NSURLSessionDataTask * _Nonnull, id _Nullable) = [self successOnRequestWithSuccess:success andFailure:failure withInterface:weakView hudEnable:hud];
    void (^failureResponse)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull) = [self failureOnRequestWithFailure:failure withInterface:weakView hudEnable:hud];
    NSURLSessionDataTask *dataTask = [super GET:path parameters:params progress:downProgress success:sucessResponse failure:failureResponse];
    //step 5: store the vcr's class charator for canceling action some where.
    if (cls != nil) {
        dataTask.pb_taskIdentifier = [NSString stringWithFormat:@"class_%@_request", NSStringFromClass(cls)];
    }
}

- (void)POST:(NSString *)path parameters:(id)params class:(Class)cls view:(UIView *)view hudEnable:(BOOL)hud success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    
    //step 1: check the network state
    if (![self wetherRequestCanContinueWithView:view withHudEnable:hud]) {
        //408 request time out!
        NSError *error = [NSError errorWithDomain:kNetworkDisable code:408 userInfo:nil];
        if (failure) {
            failure(nil, error);
        }
        return;
    }
    __weak typeof(view) weakView = view;
    //step 4: make url session data task
    void (^sucessResponse)(NSURLSessionDataTask * _Nonnull, id _Nullable) = [self successOnRequestWithSuccess:success andFailure:failure withInterface:weakView hudEnable:hud];
    void (^failureResponse)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull) = [self failureOnRequestWithFailure:failure withInterface:weakView hudEnable:hud];
    NSURLSessionDataTask *dataTask = [super POST:path parameters:params progress:nil success:sucessResponse failure:failureResponse];
    //step 5: store the vcr's class charator for canceling action some where.
    if (cls != nil) {
        dataTask.pb_taskIdentifier = [NSString stringWithFormat:@"class_%@_request", NSStringFromClass(cls)];
    }
}

- (void)PUT:(NSString *)path parameters:(id)params class:(Class)cls view:(UIView *)view hudEnable:(BOOL)hud success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    
    //step 1: check the network state
    if (![self wetherRequestCanContinueWithView:view withHudEnable:hud]) {
        //408 request time out!
        NSError *error = [NSError errorWithDomain:kNetworkDisable code:408 userInfo:nil];
        if (failure) {
            failure(nil, error);
        }
        return;
    }
    __weak typeof(view) weakView = view;
    //step 4: make url session data task
    void (^sucessResponse)(NSURLSessionDataTask * _Nonnull, id _Nullable) = [self successOnRequestWithSuccess:success andFailure:failure withInterface:weakView hudEnable:hud];
    void (^failureResponse)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull) = [self failureOnRequestWithFailure:failure withInterface:weakView hudEnable:hud];
    NSURLSessionDataTask *dataTask = [super PUT:path parameters:params success:sucessResponse failure:failureResponse];
    //step 5: store the vcr's class charator for canceling action some where.
    if (cls != nil) {
        dataTask.pb_taskIdentifier = [NSString stringWithFormat:@"class_%@_request", NSStringFromClass(cls)];
    }
}

- (void)DELETE:(NSString *)path parameters:(id)params class:(Class)cls view:(UIView *)view hudEnable:(BOOL)hud success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    //step 1: check the network state
    if (![self wetherRequestCanContinueWithView:view withHudEnable:hud]) {
        //408 request time out!
        NSError *error = [NSError errorWithDomain:kNetworkDisable code:408 userInfo:nil];
        if (failure) {
            failure(nil, error);
        }
        return;
    }
    __weak typeof(view) weakView = view;
    //step 4: make url session data task
    void (^sucessResponse)(NSURLSessionDataTask * _Nonnull, id _Nullable) = [self successOnRequestWithSuccess:success andFailure:failure withInterface:weakView hudEnable:hud];
    void (^failureResponse)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull) = [self failureOnRequestWithFailure:failure withInterface:weakView hudEnable:hud];
    NSURLSessionDataTask *dataTask = [super DELETE:path parameters:params success:sucessResponse failure:failureResponse];
    //step 5: store the vcr's class charator for canceling action some where.
    if (cls != nil) {
        dataTask.pb_taskIdentifier = [NSString stringWithFormat:@"class_%@_request", NSStringFromClass(cls)];
    }
}

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

@end
