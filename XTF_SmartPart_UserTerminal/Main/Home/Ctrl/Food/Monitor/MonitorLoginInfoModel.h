//
//  MonitorLoginInfoModel.h
//  ZHYQ
//
//  Created by 魏唯隆 on 2017/12/17.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "BaseModel.h"

@interface MonitorLoginInfoModel : BaseModel

/*
{
    "dssAddr": "220.168.59.11",
    "dssAdmin": "system",
    "dssPasswd": "ztf123456",
    "dssPort": "9080"
}
*/

@property (nonatomic,copy) NSString *dssAddr;
@property (nonatomic,copy) NSString *dssAdmin;
@property (nonatomic,copy) NSString *dssPasswd;
@property (nonatomic,copy) NSString *dssPort;

@end
