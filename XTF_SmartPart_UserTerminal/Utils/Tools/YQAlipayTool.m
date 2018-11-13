//
//  YQAlipayTool.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/13.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "YQAlipayTool.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation YQAlipayTool

+ (void)aliPayWithOrderId:(NSString *)orderId withComplete:(PayCompleteBlock)payCompleteBlock type:(NSString *)type{
    
    if ([type isEqualToString:@"1"]) {
        NSString *aliPayUrl = [NSString stringWithFormat:@"%@/rechargeOrder/alipay", MainUrl];
        NSMutableDictionary *params = @{}.mutableCopy;
        [params setObject:orderId forKey:@"orderId"];
        
        //生成订单
        [[NetworkClient sharedInstance] GET:aliPayUrl dict:params progressFloat:nil succeed:^(id responseObject) {
            if([responseObject[@"code"] isEqualToString:@"1"]){
                NSString *payInfo = responseObject[@"responseData"];
                
                [[AlipaySDK defaultService] payOrder:payInfo fromScheme:KAppScheme callback:^(NSDictionary *resultDic) {
                    //                NSLog(@"+++++++++++++++++++++++%@", resultDic);
                    payCompleteBlock(resultDic[@"resultStatus"]);
                }];
            }
        } failure:^(NSError *error) {
            DLog(@"%@",error);
        }];
    }else{
        NSString *aliPayUrl = [NSString stringWithFormat:@"%@/consumeOrder/alipay", MainUrl];
        NSMutableDictionary *params = @{}.mutableCopy;
        [params setObject:orderId forKey:@"orderId"];
        
        //生成订单
        [[NetworkClient sharedInstance] GET:aliPayUrl dict:params progressFloat:nil succeed:^(id responseObject) {
            if([responseObject[@"code"] isEqualToString:@"1"]){
                NSString *payInfo = responseObject[@"responseData"];
                
                [[AlipaySDK defaultService] payOrder:payInfo fromScheme:KAppScheme callback:^(NSDictionary *resultDic) {
                    //                NSLog(@"+++++++++++++++++++++++%@", resultDic);
                    payCompleteBlock(resultDic[@"resultStatus"]);
                }];
            }
        } failure:^(NSError *error) {
            DLog(@"%@",error);
        }];
    }
    
}

@end
