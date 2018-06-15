//
//  METCPService.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/17.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEKits.h"
#import "METCPService.h"
#import "MEHeartBeatVM.h"
#import "Mecarrier.pbobjc.h"

typedef void (^tcpSuccessCallback)(NSData * _Nullable);
typedef void (^tcpFailureCallback)(NSError * _Nullable);


@interface MESocketSlice : NSObject

@property (nonatomic, copy) NSString *msg_uid;
@property (nonatomic, copy) tcpSuccessCallback success;
@property (nonatomic, copy) tcpFailureCallback failure;

@end

@implementation MESocketSlice

@end

//Socket标识
#define kGENERAL_TAG 0x153

#define ME_TCP_SERVER_RETRY_MAX_COUNT                                       5

@interface METCPService() <GCDAsyncSocketDelegate>

@property (nonatomic, strong) GCDAsyncSocket *socket;
@property (nonatomic, copy) void(^connectCallback)(NSError *_Nullable);
@property (nonatomic, copy) void(^systemDataCallback)(NSData *_Nullable);

@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) NSMutableArray *serverArray;
@property (nonatomic, assign) int serverIndex;

@property (nonatomic, strong) NSMutableArray <MESocketSlice*>*msgQueue;

/**
 是否主动退出
 */
@property (nonatomic, assign) BOOL whetherInitiativeLogout;
@property (nonatomic, strong, nullable) NSTimer *timer;
@property (nonatomic, assign) int serverRetryCounts;

@end

static METCPService *instance = nil;

@implementation METCPService

- (void)dealloc {
    [self clearTimer];
}

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[self alloc] init];
        }
    });
    return instance;
}

//初始化重写
- (id)init {
    self = [super init];
    if (self) {
        _serverIndex = 0;
        _serverRetryCounts = 0;
        _whetherInitiativeLogout = false;
    }
    return self;
}


#pragma mark --- lazy getter

- (NSMutableData *)receivedData {
    if (!_receivedData) {
        _receivedData = [NSMutableData data];
    }
    return _receivedData;
}

- (NSMutableArray *)serverArray {
    if (!_serverArray) {
        _serverArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _serverArray;
}

- (void)addServerHost:(NSString *)host port:(uint16_t)port {
    [self.serverArray addObject:@{ @"host": host, @"port": @(port)}];
}

#pragma mark --- Connect Socket-TCP

- (void)connectWithcompletion:(void (^)(NSError * _Nullable))completion {
    if (self.socket.isConnected) {
        return;
    }
    if (self.serverArray.count == 0) {
        NSLog(@"socket套接字服务器地址列表空！");
        return;
    }
    //Socket连接
    NSError *err = nil;
    NSDictionary *server = self.serverArray[0];
    NSString *host = server[@"host"];
    uint16_t port = [server[@"port"] unsignedIntegerValue];
    //NSDictionary *dic = self.serverArray[];
    if ([self.socket connectToHost:host onPort:port withTimeout:3 error:&err]) {
        //read data
        [self.socket readDataWithTimeout:-1 tag:kGENERAL_TAG];
    }
    self.connectCallback = [completion copy];
    if (completion) {
        completion(err);
    }
}

- (void)disconnect {
    self.whetherInitiativeLogout = true;
    [self.socket disconnect];
}

- (void)handleSystemSocketData:(void (^)(NSData * _Nullable))completion {
    self.systemDataCallback = [completion copy];
}

#pragma mark --- lazy loading

- (GCDAsyncSocket *)socket {
    if (!_socket) {
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        _socket.IPv4PreferredOverIPv6 = false;
    }
    return _socket;
}

#pragma mark --- Socket-TCP Delegate

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    //读取服务器传回的数据
    [self.receivedData appendData:data];
    NSRange range = [self readRawVarint32:self.receivedData];
    if (range.length > 0 && ((range.length + range.location) <= self.receivedData.length)) {
        NSData *cmdData = [self.receivedData subdataWithRange:NSMakeRange(range.location, range.length)];
        [self.receivedData replaceBytesInRange:NSMakeRange(0, range.length + range.location) withBytes:NULL length:0];
        //判断是服务器直接发送还是有请求响应
        if (self.receivedData.length != 6) {
            NSError *err;
            MECarrierPB *signedCarrier = [MECarrierPB parseFromData:cmdData error:&err];
            //处理是否为系统通知
            NSString *cmdCode = signedCarrier.cmdCode;
            //系统通知
            if (cmdCode.length > 0 && [cmdCode isEqualToString:@"FSC_NOTIFY_POST"]) {
                NSString *reqCode = signedCarrier.reqCode;
                if (reqCode.length > 0 && [reqCode isEqualToString:@"NOTIFY_KICK_OUT"]) {
                    //账号被顶替
                    NSString *msg = PBFormat(@"您的%@账号在其他设备上登录，如果这不是您的操作，您的密码有可能已泄露，请重新登录后修改密码。", [NSBundle pb_displayName]);
                    //self.accountKickoutCallback(true, msg);
                    
                    NSString *routeUrlString = PBFormat(@"kickout://root@%@/", ME_USER_SIGNIN_PROFILE);
                    NSDictionary *param = @{@"alert":msg};
                    [MEDispatcher openURL:[NSURL URLWithString:routeUrlString] withParams:param];
                }
            } else {
                MESocketSlice *slice = [self fetchSliceCallback4Uid:signedCarrier.token];
                if (slice) {
                    if (err) {
                        slice.failure(err);
                    } else {
                        slice.success(signedCarrier.source);
                    }
                    [self.msgQueue removeObject:slice];
                } else {
                    if (self.systemDataCallback) {
                        self.systemDataCallback(signedCarrier.source);
                    }
                }
            }
        } else {
            if (self.systemDataCallback) {
                self.systemDataCallback(self.receivedData.copy);
            }
        }
    }
    [self.socket readDataWithTimeout:-1 tag:kGENERAL_TAG];
}

- (NSRange)readRawVarint32:(NSMutableData *)data {
    int loc = 0;
    if (data.length == 0) {
        return NSMakeRange(0, 0);
    }
    signed char tmp = [self readByte:loc++ data:data];
    if (tmp >= 0) {
        return NSMakeRange(1, tmp);
    } else {
        int result = tmp & 127;
        if ((tmp = [self readByte:loc++ data:data]) >= 0) {
            result |= tmp << 7;
        } else {
            result |= (tmp & 127) << 7;
            if ((tmp = [self readByte:loc++ data:data]) >= 0) {
                result |= tmp << 14;
            } else {
                result |= (tmp & 127) << 14;
                if ((tmp = [self readByte:loc++ data:data]) >= 0) {
                    result |= tmp << 21;
                } else {
                    result |= (tmp & 127) << 21;
                    result |= (tmp = [self readByte:loc data:data]) << 28;
                    if (tmp < 0) {
                        return NSMakeRange(0, 0);
                    }
                }
            }
        }
        return NSMakeRange(loc, result);
    }
}

- (Byte)readByte:(int)loc data:(NSMutableData *)data {
    Byte buffer[1];
    [data getBytes:buffer range:NSMakeRange(loc, 1)];
    return buffer[0];
}

/**
 * 服务器连接成功
 */
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"已经连接到服务器：%@--%lld", host, port);
    //重新登录
    _serverIndex = 0;
    [self clearTimer];
    [self.socket readDataWithTimeout:-1 tag:kGENERAL_TAG];
    if (self.connectCallback) {
        self.connectCallback(nil);
    }
    //发送心跳包
    [self sendTCPHeartBeat];
}

- (void)sendTCPHeartBeat {
    MECarrierPB *heartBeat = [[MECarrierPB alloc] init];
    heartBeat.cmdCode = @"HEARTBEAT";
    heartBeat.cmdVersion = @"1";
    heartBeat.sessionToken = [MEKits fetchCurrentUserSessionToken];
    NSData *cmdData = [heartBeat data];
    NSMutableData *sendData = [NSMutableData data];
    NSMutableData *headData = [self writeRawVarint32:cmdData.length];
    [sendData appendData:headData];
    [sendData appendData:cmdData];
    //发送
    [self.socket writeData:sendData withTimeout:-1 tag:kGENERAL_TAG];
}

/**
 * 与服务器连接断开/失败
 */
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    NSLog(@"与服务器断开连接，由于：%@", err);
    if (self.whetherInitiativeLogout) {
        NSLog(@"主动退出!");
        return;
    }
    
    if (self.connectCallback) {
        self.connectCallback(err);
    }
    //自动重连
    if (_serverRetryCounts >= ME_TCP_SERVER_RETRY_MAX_COUNT) {
        [self clearTimer];
        _timer = [NSTimer scheduledTimerWithTimeInterval:ME_TCP_SERVER_RETRY_MAX_COUNT target:self selector:@selector(retryConnect2TCPServer) userInfo:nil repeats:false];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        
        return;
    } else {
        //需要重连
        if ((_serverIndex + 1) > self.serverArray.count) {
            _serverIndex = 0;
        }
        NSDictionary *server = self.serverArray[(NSUInteger) _serverIndex];
        NSString *host = server[@"host"];
        uint16_t port = [server[@"port"] unsignedIntegerValue];
        [self.socket connectToHost:host onPort:port withTimeout:3 error:&err];
    }
    
    _serverRetryCounts += 1;
}

- (NSMutableData *)writeRawVarint32:(NSUInteger)value {
    NSMutableData *headData = [NSMutableData data];
    while (true) {
        if ((value & ~0x7F) == 0) {
            [headData appendData:[NSData dataWithBytes:&value length:1]];
            break;
        } else {
            Byte length = (Byte) ((value & 0x7F) | 0x80);
            [headData appendData:[NSData dataWithBytes:&(length) length:1]];
            value >>= 7;
        }
    }
    return headData;
}

- (void)clearTimer {
    if (self.timer) {
        if ([self.timer isValid]) {
            [self.timer invalidate];
        }
        _timer = nil;
    }
    _serverRetryCounts = 0;
}

- (void)retryConnect2TCPServer {
    _serverIndex += 1;
}

#pragma mark --- Write Binary Data to TCP Socket

- (NSMutableArray<MESocketSlice*>*)msgQueue {
    if (!_msgQueue) {
        _msgQueue = [NSMutableArray arrayWithCapacity:0];
    }
    return _msgQueue;
}

- (MESocketSlice *)fetchSliceCallback4Uid:(NSString *)uid {
    __block MESocketSlice *slice = nil;
    [self.msgQueue enumerateObjectsUsingBlock:^(MESocketSlice * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.msg_uid isEqualToString:uid]) {
            slice = obj;
            *stop = true;
        }
    }];
    return slice;
}

- (void)writeData:(NSData *)data hudEnable:(BOOL)hud success:(void (^)(NSData * _Nullable))success failure:(void (^)(NSError * _Nonnull))failure {
    //store msg to queue
    MESocketSlice *slice = [[MESocketSlice alloc] init];
    slice.msg_uid = [MEKits createUUID];
    slice.success = [success copy];
    slice.failure = [failure copy];
    [self.msgQueue addObject:slice];
    
    //send tcp data
    MECarrierPB *carrier = [[MECarrierPB alloc] init];
    /**
     *  uuid for unique request
     */
    //    NSString *uuidToken = [MEVM createUUID];
    //    [carrier setToken:uuidToken];
    /**
     *  cmdCode
     */
//    NSString *cmdCode = [self cmdCode];
//    [carrier setCmdCode:cmdCode];
    /**
     *  reqCode
     */
//    NSString *optCode = [self operationCode];
//    [carrier setReqCode:optCode];
    /**
     *  real binary data
     */
    [carrier setSource:data];
    //cmd version
    NSString *cmdVersion = @"1";
    [carrier setCmdVersion:cmdVersion];
    
    NSData *signedData = [carrier data];
    NSMutableData *sendData = [NSMutableData data];
    NSMutableData *headData = [self writeRawVarint32:signedData.length];
    [sendData appendData:headData];
    [sendData appendData:signedData];
    //发送
    [self.socket writeData:sendData withTimeout:-1 tag:kGENERAL_TAG];
}

@end
