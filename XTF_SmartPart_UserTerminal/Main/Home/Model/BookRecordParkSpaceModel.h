//
//  BookRecordParkSpaceModel.h
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/6/14.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "BaseModel.h"

@interface BookRecordParkSpaceModel : BaseModel
/*
 parkingSpace =                 {
 carNo = "\U6e58A8V37V";
 changeRelaId = 2018061475647;
 changeResion = "\U8f66\U4f4d\U9884\U7ea6!";
 changeTime = "<null>";
 lockId = 40f0011;
 lockStatus = 0;
 lockType = 1;
 parkingAreaId = 2001;
 parkingAreaName = "\U524d\U576a\U505c\U8f66\U533a";
 parkingId = 1001;
 parkingName = "\U5929\U56ed\U505c\U8f66\U573a";
 parkingSpaceId = 3002;
 parkingSpaceName = "\U524d\U576a\U8f66\U4f4d01";
 parkingStatus = 1;
 parkingType = 0;
 position1 = "<null>";
 position2 = "<null>";
 version = 36;
 }
 */

@property (nonatomic,copy) NSString *changeTime;
@property (nonatomic,copy) NSString *parkingId;
@property (nonatomic,copy) NSString *parkingSpaceId;
@property (nonatomic,copy) NSString *lockId;
@property (nonatomic,copy) NSString *lockStatus;
@property (nonatomic,copy) NSString *parkingAreaName;
@property (nonatomic,copy) NSString *changeRelaId;
@property (nonatomic,copy) NSString *parkingSpaceName;
@property (nonatomic,copy) NSString *parkingName;
@property (nonatomic,copy) NSString *lockType;
@property (nonatomic,copy) NSString *parkingStatus;
@property (nonatomic,copy) NSString *parkingType;
@property (nonatomic,copy) NSString *changeResion;
@property (nonatomic,copy) NSString *position1;
@property (nonatomic,copy) NSString *position2;
@property (nonatomic,strong) NSNumber *version;
@property (nonatomic,copy) NSString *parkingAreaId;
@property (nonatomic,copy) NSString *carNo;

@end
