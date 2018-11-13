//
//  BookRecordModel.h
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/6/12.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "BaseModel.h"

@interface BookRecordModel : BaseModel
/*
 {
 carNo = "\U6e58A8V37V";
 createTime = "2018-06-12 09:54:46";
 custId = 3a5e3d61238d4141b4c571f91aa7d855;
 custName = "\U7126\U5e73";
 delFlag = "<null>";
 invalidTime = "2018-06-12 10:24:46";
 lockId = TF001;
 lockType = 0;
 orderId = 2018061275334;
 orderPrice = "<null>";
 orderTime = "2018-06-12 09:54:46";
 parkingSpaceId = 3001;
 parkingSpaceName = "\U5730\U4e0b\U8f66\U4f4d01";
 payMode = "<null>";
 payOrderId = "<null>";
 payTag = "<null>";
 payTime = "<null>";
 remark = "<null>";
 reservedTime = 1800;
 status = 2;
 updateTime = "<null>";
 }
 */

@property (nonatomic,copy) NSString *orderPrice;
@property (nonatomic,copy) NSString *remark;
@property (nonatomic,copy) NSString *custName;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *payTime;
@property (nonatomic,copy) NSString *updateTime;
@property (nonatomic,copy) NSString *lockType;
@property (nonatomic,copy) NSString *payMode;
@property (nonatomic,copy) NSString *custId;
@property (nonatomic,copy) NSString *delFlag;
@property (nonatomic,strong) NSNumber *reservedTime;
@property (nonatomic,copy) NSString *carNo;
@property (nonatomic,copy) NSString *payOrderId;
@property (nonatomic,copy) NSString *lockId;
@property (nonatomic,copy) NSString *parkingSpaceId;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *orderTime;
@property (nonatomic,copy) NSString *parkingSpaceName;
@property (nonatomic,copy) NSString *payTag;
@property (nonatomic,copy) NSString *orderId;
@property (nonatomic,copy) NSString *invalidTime;

@end
