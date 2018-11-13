//
//  MonitorLogin.m
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/11/7.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "MonitorLogin.h"
#import "DHDataCenter.h"
#import "DHLoginManager.h"
#import "WeikitErrorCode.h"
#import "DHHudPrecess.h"

@implementation MonitorLogin

+ (BOOL)loginWithAddress:(NSString *)address withPort:(NSString *)port withName:(NSString *)name withPsw:(NSString *)psw
{
    [[DHDataCenter sharedInstance] setHost:address port:[port intValue]];
    NSError *error = nil;
    DSSUserInfo *userInfo = [[DHLoginManager sharedInstance] loginWithUserName:name Password:psw error:&error];
    if (error) {
        MSG("", @"Login failed", "");
        switch (error.code) {
            case YYS_BEC_USER_PASSWORD_ERROR:
                NSLog(@"username or password error");
                break;
            case YYS_BEC_USER_SESSION_EXIST:
                NSLog(@"user logined");
                break;
            case YYS_BEC_USER_NOT_EXSIT:
                NSLog(@"user not exsit");
                break;
            case YYS_BEC_USER_LOGIN_TIMEOUT:
                NSLog(@"login timeout");
                break;
            case YYS_BEC_COMMON_NETWORK_ERROR:
                NSLog(@"network error");
                break;
            default:
                break;
        }
        
        return NO;
    }
    //call after login
    [[DHDeviceManager sharedInstance] afterLoginInExcute:userInfo];
    return YES;
}

@end
