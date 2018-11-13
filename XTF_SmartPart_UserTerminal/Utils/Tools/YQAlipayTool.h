//
//  YQAlipayTool.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/13.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PayCompleteBlock)(NSString *stateCode);

@interface YQAlipayTool : NSObject

+ (void)aliPayWithOrderId:(NSString *)orderId withComplete:(PayCompleteBlock)payCompleteBlock type:(NSString *)type;  // 订单号

@property (nonatomic, assign) PayCompleteBlock payCompleteBlock;

@end
