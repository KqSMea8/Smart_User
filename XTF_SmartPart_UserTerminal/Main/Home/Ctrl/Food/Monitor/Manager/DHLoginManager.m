//
//  DHLoginManager.m
//  DataAdapterExample_Example
//
//  Created by 32943 on 2018/1/31.
//  Copyright © 2018年 ly. All rights reserved.
//

#import "DHLoginManager.h"
#import "DHDataCenter.h"
#import "DSSPlatformDataAdapterUser.h"

@interface DHLoginManager()
@property (nonatomic, strong) DSSPlatformDataAdapterUser *userAdapter;
@end

static DHLoginManager* g_loginManager = nil;

@implementation DHLoginManager
+ (DHLoginManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_loginManager = [[self alloc] init];
    });
    return g_loginManager;
}

+ (void)unSharedInstance {
    if (g_loginManager) {
        g_loginManager = nil;
    }
}

- (instancetype)init {
    self = [super init];
    if (self)
    {
        _userAdapter = [[DSSPlatformDataAdapterUser alloc] init];
       // _userAdapter.core = [DHDataCenter sharedInstance].coreAdapter;
        _userAdapter.remoteNotifyBlock = ^(ADAPTER_NOTIFY_ACTION action, id content) {
            //TODO
            switch (action) {
                case ADAPTER_NOTIFY_ACTION_SERVER_DISCONNECT:
                    NSLog(@"服务断线");
                    break;
                case ADAPTER_NOTIFY_ACTION_USER_LOCKED:
                    NSLog(@"用户已锁定");
                    break;
                case ADAPTER_NOTIFY_ACTION_USER_DELETE:
                    NSLog(@"用户已删除");
                    break;
                case ADAPTER_NOTIFY_ACTION_USER_LOGIN_TIME_EXPIRE:
                   NSLog(@"登录超时");
                    break;
                case ADAPTER_NOTIFY_ACTION_SERVER_CONNECTED:
                   NSLog(@"服务已连接");
                    break;
                case ADAPTER_NOTIFY_ACTION_SERVER_CONNECTING:
                    NSLog(@"服务连接中");
                    break;
                case ADAPTER_NOTIFY_ACTION_SERVER_LOGOUT:
                   NSLog(@"服务已注销");
                    break;
                default:
                    break;
            }
        };
    }
    
    return self;
}

- (DSSUserInfo *)loginWithUserName:(NSString *)userName Password:(NSString *)password error:(NSError **)error {
        _userInfo = [_userAdapter login:userName byPassword:password error:error];
    return _userInfo;
}

- (DSSUserInfo *)getUserInfo:(NSError **)error {
    return _userInfo;
}

- (BOOL)logout:(NSError **)error {
    int ret = [_userAdapter logout:error];
    [[DHDeviceManager sharedInstance] afterLoginOutExcute:_userInfo];
    [DHDeviceManager unSharedInstance];
     _userInfo = nil;
    return ret;
}

- (BOOL)modifyPassword:(NSString *)newPassword error:(NSError **)error {
    return [_userAdapter modifyPassword:newPassword error:error];
}


@end
