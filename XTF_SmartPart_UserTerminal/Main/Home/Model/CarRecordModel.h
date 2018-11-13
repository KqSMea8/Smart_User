//
//  CarRecordModel.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 魏唯隆 on 2017/12/13.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "BaseModel.h"
#import "BookRecordModel.h"
#import "BookRecordParkAreaModel.h"

@interface CarRecordModel : BaseModel

/*
{
    "traceIndex2": "2015072700000215000213013681",
    "traceAgentid": "000000000000",
    "traceAgentname": "平台运营商",
    "traceParkid": "4028e44254f1072b0154f1072b7a0000",
    "traceParkname": "时代总部停车场",
    "traceArea": "4028e44254f1072b0154f1072b7a0002",
    "traceInoperno": 50000016,
    "traceOutoperno": 50000016,
    "traceSeatcode1": "000001",
    "traceSeatno1": "0001",
    "traceBegin": "20160527082442",
    "traceEnd": "",
    "traceTime": null,
    "tracePreamt": 0,
    "traceParkamt": 0,
    "traceCash": 0,
    "traceNotcash": 0,
    "traceCartype": "0",
    "traceCarno": "HD5368",
    "traceCarnocolor": "蓝",
    "traceWarning": "",
    "traceMemberId": "4028e44254c69ee10154cd0bd4e6006d",
    "traceCardId": "4028e44254c7b5a80154cd0ce9080140",
    "traceSysbatch": "",
    "traceSystrace": "",
    "tracePaydate": "20160624155746",
    "traceSettledate": "1",
    "traceIngateid": "",
    "traceInphoto": "",
    "traceInsmallPhoto": "http://tcb-yunpark.oss-cn-hangzhou.aliyuncs.com/park/hzcl/2016429/鄂A1F817-2016-04-29-08-27-05-s.jpg",
    "traceOutgateid": "",
    "traceOutphoto": "http://tcb-yunpark.oss-cn-hangzhou.aliyuncs.com/park/hzcl/2016429/鄂A1F817-2016-04-29-09-06-56-b.jpg",
    "traceOutsmallPhoto": "http://tcb-yunpark.oss-cn-hangzhou.aliyuncs.com/park/hzcl/2016429/鄂A1F817-2016-04-29-08-27-05-s.jpg",
    "traceOuttype": "",
    "traceResult": "66",
    "traceInoperate": "",
    "traceOutoperate": "",
    "traceUpdatetime": "",
    "cardPhone": null,
    "cardExpdate": null
}
 */

@property (nonatomic,copy) NSString *traceIndex2;
@property (nonatomic,copy) NSString *traceCarno;
@property (nonatomic,copy) NSString *traceBegin;
@property (nonatomic,copy) NSString *traceEnd;
@property (nonatomic,strong) NSNumber *traceTime;
@property (nonatomic,copy) NSString *traceResult;   // 66 90 未出场  00 出场
@property (nonatomic,copy) NSString *traceInphoto;
@property (nonatomic,copy) NSString *traceOutphoto;
@property (nonatomic,copy) NSString *traceParkname;
@property (nonatomic,copy) NSString *traceArea;

@property (nonatomic,copy) NSString *isBooking;
@property (nonatomic,retain) BookRecordModel *orderModel;
@property (nonatomic,retain) BookRecordParkAreaModel *parkAreaModel;

@end
