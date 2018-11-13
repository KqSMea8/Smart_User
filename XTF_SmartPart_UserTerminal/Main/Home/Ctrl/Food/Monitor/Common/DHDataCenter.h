//
//  DHDataCenter.h
//  DataAdapterExample_Example
//
//  Created by 32943 on 2018/1/31.
//  Copyright © 2018年 ly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSSPlatformDataAdapterCore.h"
#import "DHDeviceManager.h"

@interface DHDataCenter : NSObject
@property (nonatomic, strong) DSSPlatformDataAdapterCore *coreAdapter;
@property (nonatomic, strong) TreeNode *selectNode;
+ (DHDataCenter *)sharedInstance;

/**
 设置ip和端口
 set ip and port
 
 @param hostIp ip
 @param port port
 */
- (void)setHost:(NSString *)hostIp port:(int)port;

/**
 获取ip地址
 get ip

 @return ip
 */
- (NSString *)getHost;

/**
 获取端口
 get port

 @return port
 */
- (int)getPort;

/**
 获取登录token（云基线）
 get login token

 @return token
 */
- (NSString *)getLoginToken;
@end
