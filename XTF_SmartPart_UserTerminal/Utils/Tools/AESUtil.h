//
//  AESUtil.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/22.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AESUtil : NSObject
//加密
+ (NSString *)encryptAES:(NSString *)content key:(NSString *)key;
//解密
+ (NSString *)decryptAES:(NSString *)content key:(NSString *)key;

@end
