//
//  FloorModel.h
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/5/29.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "BaseModel.h"

@interface FloorModel : BaseModel

/*
 {
 "BUILDING_ID" = 1;
 "LAYER_ID" = 1;
 "LAYER_MAP" = "<null>";
 "LAYER_NAME" = "\U5730\U4e0b\U8f66\U5e93";
 "LAYER_NUM" = "-1";
 }
 */

@property (nonatomic,copy) NSString *BUILDING_ID;

@property (nonatomic,copy) NSString *LAYER_NUM;

@property (nonatomic,strong) NSNumber *LAYER_ID;

@property (nonatomic,copy) NSString *LAYER_MAP;

@property (nonatomic,copy) NSString *LAYER_NAME;

@end
