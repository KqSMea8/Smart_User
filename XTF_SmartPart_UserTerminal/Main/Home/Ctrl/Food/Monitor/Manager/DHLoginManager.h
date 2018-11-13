//
//  DHLoginManager.h
//  DataAdapterExample_Example
//
//  Created by 32943 on 2018/1/31.
//  Copyright © 2018年 ly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSSUserInfo.h"

@interface DHLoginManager : NSObject
@property (nonatomic, strong) DSSUserInfo *userInfo;

+ (DHLoginManager *)sharedInstance;

+ (void)unSharedInstance;
/**
 Login
 登录

 @param userName 用户名
 @param password 密码
 @param error 错误
 @return UserInfo 用户信息
 */
- (DSSUserInfo *)loginWithUserName:(NSString *)userName Password:(NSString *)password error:(NSError **)error;

/**
 *  获取用户信息
 *  getUserInfo
 *
 *  @param error NSError
 *
 *  @return UserInfo
 */
- (DSSUserInfo *)getUserInfo:(NSError **)error;

/**
 *  注销
 *  Logout
 *
 *  @return BOOL
 */
- (BOOL)logout:(NSError **)error;

/**
 *  修改密码
 *  Modify password
 *
 *  @param newPassword NSString MD5 加密过的。
 *
 *  @return BOOL
 */
- (BOOL)modifyPassword:(NSString *)newPassword error:(NSError **)error;

@end
