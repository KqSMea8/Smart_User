//
//  CarListModel.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 魏唯隆 on 2017/12/13.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "BaseModel.h"

@interface CarListModel : BaseModel

/*
{
    "carId": 8,
    "carMemberId": "4028e44254f1072b0154f16dd8df000e",
    "carNo": "鄂A12345",
    "carArea": "鄂A",
    "carNum": "12345",
    "carType": "1",
    "carUserid": null,
    "carCtime": "20160530165839",
    "carUtime": null,
    "carAutoPay": "1",
    "carNike": "aa"
}
 */

@property (nonatomic,strong) NSNumber *carId;
@property (nonatomic,copy) NSString *carMemberId;
@property (nonatomic,copy) NSString *carNo;
@property (nonatomic,copy) NSString *carArea;
@property (nonatomic,copy) NSString *carNum;
@property (nonatomic,copy) NSString *carType;
@property (nonatomic,copy) NSString *carUserid;
@property (nonatomic,copy) NSString *carCtime;
@property (nonatomic,copy) NSString *carUtime;
@property (nonatomic,copy) NSString *carAutoPay;
@property (nonatomic,copy) NSString *carNike;

@property (nonatomic,copy) NSString *state;
@property (nonatomic,copy) NSString *carParkArea;

@end
