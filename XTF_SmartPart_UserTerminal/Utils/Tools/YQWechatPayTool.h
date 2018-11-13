//
//  YQWechatPayTool.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/13.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YQWechatPayTool : NSObject

+ (void)weChatPayWithOrderId:(NSString *)orderId;  // 订单号

@end
