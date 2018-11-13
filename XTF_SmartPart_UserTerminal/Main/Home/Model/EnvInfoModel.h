//
//  EnvInfoModel.h
//  ZHYQ
//
//  Created by 魏唯隆 on 2018/1/8.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "BaseModel.h"
#import "EnvAttributesModel.h"

@interface EnvInfoModel : BaseModel

/*
{
    "addDate": "2018-01-0211:25:06",
    "addUser": "tongfu123",
    "addr": "0xed000030",
    "addrStr": "30",
    "adv_name": "湖南",
    "airpressure": 10246,
    "attributes": {
        "airpressure": "10246.000000",
        "gateway_id": "5a4afb5698f1ac15eefab9f6",
        "humidity": "83.099998",
        "light_pole_id": "5a45f38698f1ac15eefab9ee",
        "luminousradiation": "0.000000",
        "noise": "58.400002",
        "pm10": "208.000000",
        "pm2_5": "168.000000",
        "precipitation": "0.000000",
        "refresh_time": "MonJan0811:02:49GMT+08:002018",
        "temperature": "2.900000",
        "ultravioletintensity": "0.000000",
        "winddirectionavg": "82.000000",
        "winddirectionmax": "315.000000",
        "winddirectionmin": "0.000000",
        "windspeedavg": "0.200000",
        "windspeedmax": "0.700000",
        "windspeedmin": "0.000000"
    },
    "divisionId": "5a3e130498f1acdeac5bb666",
    "gatewayName": "FEFEDDDD",
    "humidity": 83.1,
    "id": "气象传感器(十一合一)",
    "light_pole_number": "0005",
    "luminousradiation": 0,
    "modifyDate": "2018-01-0211:25:06",
    "modifyUser": "tongfu123",
    "name": "停车场外侧",
    "noise": 58.4,
    "online": 1,
    "org_name": "通服",
    "organizationId": "5a3e131b98f1acdeac5bb667",
    "pm10": 208,
    "pm2_5": 168,
    "precipitation": 0,
    "prj_name": "通服",
    "projectId": "5a3e139b98f1acdeac5bb668",
    "refresh_time": "2018-01-0811:02:49",
    "temperature": 2.9,
    "type": 28,
    "uid": "5a4afb9298f1ac15eefab9f7",
    "ultravioletintensity": 0,
    "winddirection": "table_direction_east",
    "windspeed": 0.2
}
 */

@property (nonatomic, strong) NSNumber *airpressure;    // 气压
@property (nonatomic, strong) NSNumber *pm2_5;          // pm2.5
@property (nonatomic, strong) NSNumber *temperature;    // 温度
@property (nonatomic, strong) NSNumber *noise;          // 噪音
@property (nonatomic, copy) NSString *winddirection;    // 风向
@property (nonatomic, strong) NSNumber *windspeed;      // 风速
@property (nonatomic, strong) NSNumber *pm10;           // pm10
@property (nonatomic, strong) NSNumber *humidity;       // 湿度
@property (nonatomic, copy) NSString *adv_name;         // 区域
@property (nonatomic, copy) NSString *weather;          // 天气
@property (nonatomic, copy) NSString *smallWhite;       //首页白色小图标地址
@property (nonatomic, copy) NSString *bigColor;         //天气详情大图标

@property (nonatomic, retain) EnvAttributesModel *envAttributesModel;

@end
