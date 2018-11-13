//
//  KqStatusModel.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/9.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "BaseModel.h"

@interface KqStatusModel : BaseModel

@property (nonatomic,copy) NSString *certIds;
@property (nonatomic,copy) NSString *recordDate;
@property (nonatomic,copy) NSString *signTime;
@property (nonatomic,copy) NSString *signStatus;
@property (nonatomic,copy) NSString *signAddr;
@property (nonatomic,copy) NSString *trunSignTime;
@property (nonatomic,copy) NSString *isOutside;
@property (nonatomic,copy) NSString *signImageUrl;
@property (nonatomic,copy) NSString *channel;
/*
 channel 1：app 2：人脸
 */

@property (nonatomic,copy) NSString *status;

@end
