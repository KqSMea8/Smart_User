//
//  NetPayModel.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/27.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "BaseModel.h"

@interface NetPayModel : BaseModel
/*
 {
 consumeSum = "sHgGRkPgJ55wh1j4jT1uVA==";
 monthId = "";
 orderCreateDate = 20171227233252;
 orderId = 201712272332525525;
 orderPayDate = 20171227233300;
 orderPrice = "oxsuwNYIliy98KfcHZCSbw==";
 orderType = 02;
 payType = 02;
 }
*/

@property (nonatomic,copy) NSString *orderPrice;
@property (nonatomic,copy) NSString *payType;
@property (nonatomic,copy) NSString *orderId;
@property (nonatomic,copy) NSString *orderPayDate;

@property (nonatomic,copy) NSString *orderType;
@property (nonatomic,copy) NSString *orderCreateDate;
@property (nonatomic,copy) NSString *consumeSum;
@property (nonatomic,copy) NSString *monthId;

@end
