//
//  MonitorLogin.h
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/11/7.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MonitorLogin : NSObject

+ (BOOL)loginWithAddress:(NSString *)address withPort:(NSString *)port withName:(NSString *)name withPsw:(NSString *)psw;

@end

NS_ASSUME_NONNULL_END
