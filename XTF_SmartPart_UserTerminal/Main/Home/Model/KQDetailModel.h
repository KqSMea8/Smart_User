//
//  KQDetailModel.h
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/7/30.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "BaseModel.h"

@interface KQDetailModel : BaseModel

@property (nonatomic,copy) NSString *certIds;
@property (nonatomic,copy) NSString *recordDate;
@property (nonatomic,copy) NSString *signTime;
@property (nonatomic,copy) NSString *signStatus;
@property (nonatomic,copy) NSString *signAddr;
@property (nonatomic,copy) NSString *isOutside;
@property (nonatomic,copy) NSString *signImageUrl;
@property (nonatomic,copy) NSString *channel;
/*
 channel 1：app 2：人脸
 */
@property (nonatomic,copy) NSString *signType;
@property (nonatomic,copy) NSString *custId;
@property (nonatomic,copy) NSString *validFlag;
@property (nonatomic,copy) NSString *isFirst;
@property (nonatomic,strong) NSNumber *recordId;
@property (nonatomic,copy) NSString *signLatitude;
@property (nonatomic,copy) NSString *signLongitude;

@end
