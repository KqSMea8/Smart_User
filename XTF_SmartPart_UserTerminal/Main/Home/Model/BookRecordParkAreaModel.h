//
//  BookRecordParkAreaModel.h
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/6/14.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "BaseModel.h"

@interface BookRecordParkAreaModel : BaseModel
/*
 {
 availableSpaceNum = "<null>";
 latitude = "28.198722";
 longitude = "113.069875";
 parkingAreaDesc = "<null>";
 parkingAreaId = 2001;
 parkingAreaName = "\U524d\U576a\U505c\U8f66\U533a";
 parkingId = 1001;
 remark = "<null>";
 status = 0;
 totalSpaceNum = "<null>";
 }
 */

@property (nonatomic,copy) NSString *remark;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *longitude;
@property (nonatomic,copy) NSString *parkingAreaDesc;
@property (nonatomic,copy) NSString *parkingAreaId;
@property (nonatomic,copy) NSString *availableSpaceNum;
@property (nonatomic,copy) NSString *parkingAreaName;
@property (nonatomic,copy) NSString *latitude;
@property (nonatomic,copy) NSString *totalSpaceNum;
@property (nonatomic,copy) NSString *parkingId;

@end
