//
//  ParkAreasModel.h
//  ZHYQ
//
//  Created by 焦平 on 2017/12/3.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "BaseModel.h"

@interface ParkAreasModel : BaseModel

/*
 {
 agentName = "\U6e56\U5357\U901a\U670d\U8fd0\U8425\U5546";
 areaAgentid = 8a04a41f56bc33a20156bc33a29f0000;
 areaCode = 4000002101;
 areaCtime = 20160824190226;
 areaFeeindex = 8a04a41f56bc33a20156bc38a9c80007;
 areaFlag = 0;
 areaId = 8a04a41f56bc33a20156bc3726df0006;
 areaIdle = 58;
 areaLevel = 00;
 areaName = "\U5929\U56ed\U524d\U576a\U505c\U8f66\U573a";
 areaNum = 500;
 areaParkid = 8a04a41f56bc33a20156bc3726df0004;
 areaRemark = "";
 areaType = 1;
 areaUserid = 8a04a41f56bc33a20156bc34e2f50001;
 areaUtime = 20170726110214;
 parkName = "\U901a\U670d\U5929\U56ed\U505c\U8f66\U573a";
 parkRegionid = FDE21623FDD9A825E040007F01000707;
 }
 */

@property (nonatomic,copy) NSString *areaLevel;
@property (nonatomic,copy) NSString *agentName;
@property (nonatomic,copy) NSString *areaId;
@property (nonatomic,copy) NSString *areaFeeindex;
@property (nonatomic,copy) NSString *areaFlag;
@property (nonatomic,copy) NSString *areaCtime;
@property (nonatomic,copy) NSString *areaAgentid;
@property (nonatomic,copy) NSString *areaParkid;
@property (nonatomic,copy) NSString *areaType;
@property (nonatomic,copy) NSString *parkRegionid;
@property (nonatomic,strong) NSNumber *areaNum;
@property (nonatomic,copy) NSString *areaName;
@property (nonatomic,strong) NSNumber *areaIdle;
@property (nonatomic,copy) NSString *areaRemark;
@property (nonatomic,copy) NSString *areaUserid;
@property (nonatomic,copy) NSString *areaUtime;
@property (nonatomic,copy) NSString *parkName;
@property (nonatomic,copy) NSString *areaCode;

@end
