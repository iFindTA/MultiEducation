//
//  METCPService.m
//  MultiEducation
//
//  Created by nanhu on 2018/4/17.
//  Copyright © 2018年 niuduo. All rights reserved.
//

#import "MEKits.h"
#import "METCPService.h"
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

@interface METCPService() <GCDAsyncSocketDelegate>

@property (nonatomic, strong) GCDAsyncSocket *socket;
@property (nonatomic, copy) void(^connectCallback)(NSError *_Nullable);
@property (nonatomic, copy) void(^systemDataCallback)(NSData *_Nullable);

@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) NSMutableArray *serverArray;
@property (nonatomic, assign) int failServerIndex;

@property (nonatomic, strong) NSMutableArray <MESocketSlice*>*msgQueue;

@end

static METCPService *instance = nil;

@implementation METCPService

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
        _receivedData = [NSMutableData data];
        _failServerIndex = 0;
        self.serverArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark --- Connect Socket-TCP

- (void)connect2Host:(NSString *)host port:(uint8_t)port completion:(void (^)(NSError * _Nullable))completion {
    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    self.socket.IPv4PreferredOverIPv6 = NO;
    //Socket连接
    NSError *err = nil;
    self.serverArray = [NSMutableArray arrayWithObject:@{@"host":host,@"port":@(port)}];
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

#pragma mark --- Socket-TCP Delegate

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    //读取服务器传回的数据
    [_receivedData appendData:data];
    NSRange range = [self readRawVarint32:_receivedData];
    if (range.length > 0 && ((range.length + range.location) <= _receivedData.length)) {
        NSData *cmdData = [_receivedData subdataWithRange:NSMakeRange(range.location, range.length)];
        [_receivedData replaceBytesInRange:NSMakeRange(0, range.length + range.location) withBytes:NULL length:0];
        //判断是服务器直接发送还是有请求响应
        if (_receivedData.length != 6) {
            NSError *err;
            MECarrierPB *signedCarrier = [MECarrierPB parseFromData:cmdData error:&err];
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
        } else {
            if (self.systemDataCallback) {
                self.systemDataCallback(_receivedData.copy);
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
    NSLog(@"已经连接到服务器：%@", host);
    //重新登录
    _failServerIndex = -1;
    [self.socket readDataWithTimeout:-1 tag:kGENERAL_TAG];
    if (self.connectCallback) {
        self.connectCallback(nil);
    }
    //TODO://发送心跳包
    
}

/**
 * 与服务器连接断开/失败
 */
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    NSLog(@"与服务器断开连接，由于：%@", err);
    _failServerIndex += 1;
    if (self.connectCallback) {
        self.connectCallback(err);
    }
    if ((_failServerIndex + 1) > self.serverArray.count) {
        _failServerIndex = 0;
    }
    //需要重连
    NSDictionary *dic = self.serverArray[(NSUInteger) _failServerIndex];
    NSString *server = dic[@"host"];
    int port = [dic[@"port"] intValue];
    [self.socket connectToHost:server onPort:port withTimeout:3 error:&err];
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
    [sendData appendData:data];
    //发送
    [self.socket writeData:sendData withTimeout:-1 tag:kGENERAL_TAG];
}

@end
