//
//  OpenDoorModel.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/18.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "BaseModel.h"

@interface OpenDoorModel : BaseModel
/*
 {
 "DEVICE_ADDR" = "\U4e00\U697c\U4e1c\U5411\U7535\U68af\U53f3\U4fa7\U5357\U4e00\Uff08\U8fdb\Uff09";
 "DEVICE_ID" = "-522";
 "DEVICE_NAME" = "\U4e1c\U5411\U7535\U68af\U53f3\U4fa7\U5357\U4e00\Uff08\U8fdb\Uff09";
 "DEVICE_TYPE" = "4-1";
 LATITUDE = 696;
 "LAYER_A" = "192.168.207.31";
 "LAYER_B" = 171;
 "LAYER_C" = 1;
 "LAYER_ID" = 2;
 "LAYER_MAP" = "yfl1f.png";
 "LAYER_NAME" = "\U7814\U53d1\U4e00\U697c";
 LONGITUDE = "1456.0015374";
 TAGID = 338;
 hasAuth = 1;
 isCommon = 0;
 },
 */

@property (nonatomic,copy) NSString *TAGID;
@property (nonatomic,copy) NSString *DEVICE_TYPE;
@property (nonatomic,copy) NSString *DEVICE_NAME;
@property (nonatomic,copy) NSString *LAYER_ID;
@property (nonatomic,copy) NSString *DEVICE_ADDR;

@property (nonatomic,copy) NSString *LAYER_C;
@property (nonatomic,copy) NSString *LAYER_B;
@property (nonatomic,copy) NSString *DEVICE_ID;
@property (nonatomic,copy) NSString *LAYER_A;
@property (nonatomic,copy) NSString *LAYER_NAME;

@property (nonatomic,copy) NSString *LATITUDE;
@property (nonatomic,copy) NSString *LONGITUDE;
@property (nonatomic,copy) NSString *LAYER_MAP;
@property (nonatomic,strong) NSNumber *isCommon;
@property (nonatomic,strong) NSNumber *hasAuth;

@end
