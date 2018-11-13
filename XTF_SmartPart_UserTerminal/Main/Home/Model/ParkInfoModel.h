//
//  ParkInfoModel.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 魏唯隆 on 2017/12/14.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "BaseModel.h"

@interface ParkInfoModel : BaseModel

/*
{
    distance = "<null>";
    exceptCount = 0;
    joinAgentName = "\U6e56\U5357\U901a\U670d\U8fd0\U8425\U5546";
    joinRegionName = "\U8299\U84c9\U533a";
    parkAddress = "\U6e56\U5357\U7701\U957f\U6c99\U5e02\U8299\U84c9\U533a\U8fdc\U5927\U4e8c\U8def";
    parkAddtime = 20160824190226;
    parkAddversion = "<null>";
    parkAgentid = 8a04a41f56bc33a20156bc33a29f0000;
    parkAppointmentnum = "<null>";
    parkCapacity = 769;
    parkCapdesc = "";
    parkCheck = 0;
    parkCode = 40000021;
    parkCollecttime = 20160824190226;
    parkContactphone = "";
    parkContacts = "";
    parkDiscountIndex = "<null>";
    parkFeedesc = "\U6682\U4e0d\U6536\U8d39";
    parkFeeindex = "";
    parkFeelevel = 0;
    parkFlag = 0;
    parkFreetime = "<null>";
    parkHearttime = 20171214090317;
    parkId = 8a04a41f56bc33a20156bc3726df0004;
    parkIdle = 0;
    parkIdleOccu = "<null>";
    parkInventory = "<null>";
    parkIsCard = "";
    parkIsbussiness = "";
    parkIspc = "";
    parkIsshare = "<null>";
    parkIsstagger = "";
    parkJointime = 20160824190226;
    parkLat = 28198051;
    parkLng = 113069866;
    parkLogon = 0;
    parkName = "\U901a\U670d\U5929\U56ed\U505c\U8f66\U573a";
    parkPcid = 0000000000000000000000000000001;
    parkPhotoid = "http://tcb-yunpark.oss-cn-hangzhou.aliyuncs.com/yunpark/40000021/20170306/20170306095717IMG_04018.jpg";
    parkRegionid = FDE21623FDD9A825E040007F01000707;
    parkRemark = "";
    parkScore = "<null>";
    parkSofttype = "";
    parkStatus = 0;
    parkSubtype = 07;
    parkTraceIdle = "-59";
    parkType = 2;
    parkUpdversion = "<null>";
    parkUser = "<null>";
    parkUserid = 0000000000000000000000000000001;
    parkUtime = 20161227161024;
    traceAmt = 0;
}
 */

@property (nonatomic, strong) NSNumber *parkLat;
@property (nonatomic, strong) NSNumber *parkLng;
@property (nonatomic, copy) NSString *parkAgentid;
@property (nonatomic, copy) NSString *parkName;
@property (nonatomic, copy) NSString *parkAddress;

@end
