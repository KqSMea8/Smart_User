//
//  DownParkMdel.h
//  ZHYQ
//
//  Created by 魏唯隆 on 2017/12/5.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "BaseModel.h"

@interface DownParkMdel : BaseModel

/*
{
    "seatOccutimeView":"2017-12-13 08:26:59",
    "seatOccutimeTime":"13小时22分钟",
    "seatXY":"337,408",
    "seatFx":"2",
    "card":null,
    "seatId":"8a10c18958a8d36d0158aed827f50017",
    "seatCode":"10000001",
    "seatNo":"0001",
    "seatAreaid":"8a04a41f56c0c3f90157277802150065",
    "seatAgentid":"8a04a41f56c0c3f90157277802150065",
    "seatParkid":"8a04a41f56bc33a20156bc3726df0004",
    "seatParkcode":"40000021",
    "seatIdle":"1",
    "seatIdleCarno":"湘A0LP69",
    "seatOccutime":"20171213082659",
    "seatUrl":"http://115.29.51.72:8081/file/camera/20171213/40000021/192.168.205.21_20171213082659_1.jpg",
    "specialStatus":"1"
}
 */

@property (nonatomic, copy) NSString *seatOccutimeView;
@property (nonatomic, copy) NSString *seatOccutimeTime;
@property (nonatomic, copy) NSString *seatXY;
@property (nonatomic, copy) NSString *seatFx;
@property (nonatomic, copy) NSString *seatId;
@property (nonatomic, copy) NSString *seatCode;
@property (nonatomic, copy) NSString *seatAreaid;
@property (nonatomic, copy) NSString *seatAgentid;
@property (nonatomic, copy) NSString *seatParkid;
@property (nonatomic, copy) NSString *seatParkcode;
@property (nonatomic, copy) NSString *seatIdle;
@property (nonatomic, copy) NSString *seatIdleCarno;
@property (nonatomic, copy) NSString *seatOccutime;
@property (nonatomic, copy) NSString *seatUrl;
@property (nonatomic, copy) NSString *seatNo;

@end
