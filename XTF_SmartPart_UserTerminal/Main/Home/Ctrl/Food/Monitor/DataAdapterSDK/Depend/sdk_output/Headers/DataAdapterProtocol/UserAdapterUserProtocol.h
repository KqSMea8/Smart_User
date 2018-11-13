//
//  UserAdapterUserProtocol.h
//  Pods
//
//  Created by zyx on 17/2/14.
//
//

#import <Foundation/Foundation.h>
#import "DSSUserInfo.h"
#import "DataAdapterRemoteNotifyProtocol.h"
#import "DataAdapterCoreProtocol.h"

typedef void (^remoteNotifyBlock)(ADAPTER_NOTIFY_ACTION, id);

@protocol UserAdapterUserProtocol <NSObject>
@required
#pragma mark--register function to IDHModuleProtocol
- (void)setRemoteNotifyBlock:(void (^)(ADAPTER_NOTIFY_ACTION, id))remoteNotifyBlock;
/**
 *  login
 *
 *  @param name name
 *  @param pwd  password (MD5)
 *
 *  @return UserInfo
 */
#pragma mark--register function to IDHModuleProtocol
-(DSSUserInfo *)login: (NSString *)name byPassword: (NSString *)pwd error:(NSError **)error;

/**
 *  get userInfo
 *
 *  @param error NSError
 *
 *  @return UserInfo
 */
#pragma mark--register function to IDHModuleProtocol
-(DSSUserInfo *)getUserInfo:(NSError **)error;


/**
 *  logout
 *
 *  @return BOOL
 */
#pragma mark--register function to IDHModuleProtocol
-(BOOL)logout:(NSError **)error;

/**
 *  modify password
 *
 *  @param newPassword NSString MD5
 *
 *  @return BOOL
 */
#pragma mark--register function to IDHModuleProtocol
-(BOOL)modifyPassword:(NSString*)newPassword error:(NSError **)error;

/**
 * query picture ftp Ip
 */
#pragma mark--register function to IDHModuleProtocol
- (DSSFtpAddressInfo *)queryPicFtpIp;

/**
 * get user menu right
 */
#pragma mark--register function to IDHModuleProtocol
- (int)getUserMenuRight:(NSError **)error;

@end


