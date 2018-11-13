//
//  BillDetailsViewController.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/6.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "RootViewController.h"

@interface BillDetailsViewController : RootViewController

@property (nonatomic,copy) NSString *orderId;

@property (nonatomic,assign) BOOL isNetworkPay;
@property (nonatomic,copy) NSString *Base_ManMoney;

@end
