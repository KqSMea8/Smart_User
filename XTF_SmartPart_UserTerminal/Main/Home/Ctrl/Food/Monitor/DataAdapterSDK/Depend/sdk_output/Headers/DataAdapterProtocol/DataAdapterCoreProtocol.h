//
//  DataAdapterCoreProtocol.h
//  Pods
//
//  Created by zyx on 17/2/14.
//
//

#import <Foundation/Foundation.h>
#import "DHModuleEventDefine.h"
/**
 *  需要实现的基本协议
 *  need implement protocol
 */
@protocol DataAdapterCoreProtocol<NSObject>

+ (instancetype)shareInstance;
/**
 *  平台信息
 *  Platform Info
 *
 *  @param host 平台地址  ip
 *  @param port  平台端口  port
 *  @param phoneSN 硬件唯一编号: 设置--通用--关于本机--IMEI  IMEI
 *  (区别于[UIDevice currentDevice].identifierForVendor获取到的唯一识别码， identifierForVendor需要app启动以后才能获取得到，但是类似dss平台，需要在开通账号过程中，就知道唯一识别码，用于限制终端登录；所以一般为引导用户前往设置中去获取到，然后设置进来)
 *
 */
#pragma mark--register function to IDHModuleProtocol
-(void)setHost:(NSString *)host port:(int)port phoneSN:(NSString*)phoneSN;

/**
 设置登录token
 set login token
 */
#pragma mark--register function to IDHModuleProtocol
- (void)setLoginToken:(NSString *)token;
/**
 *  获取Host
 *  get ip
 *
 *  @return Host地址
 */
#pragma mark--register function to IDHModuleProtocol
-(NSString *)getHost;

/**
 *  get port
 *
 *  @return  port
 */
#pragma mark--register function to IDHModuleProtocol
-(int)getPort;


/**
 *  get IMEI
 *
 */
#pragma mark--register function to IDHModuleProtocol
-(NSString*)getPhoneSN;

/**
 *get login token
 *
 */
#pragma mark--register function to IDHModuleProtocol
- (NSString *)getLoginToken;

/**
 set sip number
 */
#pragma mark--register function to IDHModuleProtocol
- (void)setSipNumber:(NSString *)sipNum;

/**
 get sip number
 @return sip number
 */
#pragma mark--register function to IDHModuleProtocol
- (NSString *)getSipNumber;

/**
 set remoteNotification token
 @param token RemoteNotification Token
 */
#pragma mark--register function to IDHModuleProtocol
- (void)setRemoteNotificationToken:(NSString *)token;

/**
 get remoteNotification token
 @return RemoteNotification Token
 */
#pragma mark--register function to IDHModuleProtocol
- (NSString *)getRemoteNotificationToken;

/**
 set PushKit Token
 @param token PushKit Token
 */
#pragma mark--register function to IDHModuleProtocol
- (void)setPushKitToken:(NSString *)token;

/**
 get pushkit token
 @return PushKit Token
 */
#pragma mark--register function to IDHModuleProtocol
- (NSString *)getPushKitToken;

/**
 set userId
 @param NSString userId
 */
#pragma mark--register function to IDHModuleProtocol
- (void)setUserId:(NSString *)userId;

/**
 get userId
 @return userId
 */
#pragma mark--register function to IDHModuleProtocol
- (NSString *)getUserId;

/**
 *get core
 *
 */
#pragma mark--register function to IDHModuleProtocol
- (instancetype)getCore;

/**
 *设置Https模式
 */
#pragma mark--register function to IDHModuleProtocol
- (void)setHttpsMode:(BOOL)bHttpsEnable;
@end

