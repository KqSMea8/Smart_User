//
//  RepairModel.h
//  XTF_SmartPart_UserTerminal
//
//  Created by jiaop on 2018/5/11.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "BaseModel.h"

@interface RepairModel : BaseModel

/*
 alarmId = 68469;
 alarmImage = "<null>";
 alarmInfo = "\U706f\U4e0d\U4eae";
 alarmLocation = 305;
 alarmResource = 3;
 alarmState = 0;
 alarmTime = "2018-05-11 13:27:39";
 alarmType = 5;
 deviceId = "<null>";
 deviceName = "\U706f";
 deviceOfferName = "<null>";
 modifyTime = "<null>";
 reportName = "%E7%84%A6%E5%B9%B3";
 reporter = 4c66793d6d5f4a5d85950bb81cc9988b;
 */

@property (nonatomic,strong) NSNumber *alarmId;
@property (nonatomic,copy) NSString *alarmImage;
@property (nonatomic,copy) NSString *alarmInfo;
@property (nonatomic,copy) NSString *alarmLocation;
@property (nonatomic,copy) NSString *alarmResource;
@property (nonatomic,copy) NSString *alarmState;
@property (nonatomic,copy) NSString *alarmTime;
@property (nonatomic,copy) NSString *alarmType;
@property (nonatomic,strong) NSNumber *deviceId;
@property (nonatomic,copy) NSString *deviceName;
@property (nonatomic,copy) NSString *deviceOfferName;
@property (nonatomic,copy) NSString *modifyTime;
@property (nonatomic,copy) NSString *reportName;
@property (nonatomic,copy) NSString *reporter;

@end
