//
//  CarParkModel.h
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/6/11.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "BaseModel.h"

@interface CarParkModel : BaseModel
/*
 {
 availableSpaceNum = 0;
 latitude = "28.198722";
 longitude = "113.069875";
 parkingAreaDesc = "<null>";
 parkingAreaId = 2001;
 parkingAreaName = "\U524d\U576a\U505c\U8f66\U533a";
 parkingId = 1001;
 remark = "<null>";
 status = 0;
 totalSpaceNum = 1;
 }
 */

@property (nonatomic,copy) NSString *remark;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *longitude;
@property (nonatomic,copy) NSString *parkingAreaDesc;
@property (nonatomic,copy) NSString *parkingAreaId;
@property (nonatomic,strong) NSNumber *availableSpaceNum;
@property (nonatomic,copy) NSString *parkingAreaName;
@property (nonatomic,copy) NSString *latitude;
@property (nonatomic,strong) NSNumber *totalSpaceNum;
@property (nonatomic,copy) NSString *parkingId;

@end
