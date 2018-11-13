//
//  BalanceDetailModel.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 魏唯隆 on 2017/12/15.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "BaseModel.h"

@interface BalanceDetailModel : BaseModel

/*
 {
 "Base_CardNo" = D707F74A;
 "Base_DataTwo" = 201712272141046079;
 "Base_Modify_User" = SYSTEM;
 "Base_Money" = "8/5Gi1ByKQRz8AZfLVnDrg==";
 "Base_PerID" = 0000002342;
 "Base_Remain" = "fPVKBElpdU7WrtNvgMMBfw==";
 chargeSum = "bKnya8YN1wcGfGRLNyOVpw==";
 consumeSum = "g1WIBN/5pfHqaPP+Fpvyrg==";
 monthId = "2017-12";
 orderCreateTime = 20171227214104;
 orderPayTime = 20171227214019;
 orderType = 02;
 payType = 03;
 }
 */


@property (nonatomic,copy) NSString *Base_Money;
@property (nonatomic,copy) NSString *Base_PerID;
@property (nonatomic,copy) NSString *Base_Modify_User;
@property (nonatomic,copy) NSString *payType;
@property (nonatomic,copy) NSString *orderType;

@property (nonatomic,copy) NSString *chargeSum;
@property (nonatomic,copy) NSString *monthId;
@property (nonatomic,copy) NSString *consumeSum;

@property (nonatomic,copy) NSString *Base_CardNo;
@property (nonatomic,copy) NSString *Base_DataTwo;
@property (nonatomic,copy) NSString *Base_Remain;
@property (nonatomic,copy) NSString *orderPayTime;
@property (nonatomic,copy) NSString *orderCreateTime;

@property (nonatomic,copy) NSString *Base_ManMoney;

@end
