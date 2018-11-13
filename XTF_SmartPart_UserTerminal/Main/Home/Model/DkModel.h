//
//  DkModel.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/7.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "BaseModel.h"

@interface DkModel : BaseModel
/*
 certIds = 123123;
 recordDate = "2017-12-07";
 signAddr = "\U8fdc\U5927\U4e8c\U8def212\U53f7";
 signStatus = 2;
 signTime = "2017-12-07 20:13:42.0";
 */

@property (nonatomic,copy) NSString *certIds;
@property (nonatomic,copy) NSString *recordDate;
@property (nonatomic,copy) NSString *signTime;
@property (nonatomic,copy) NSString *signStatus;
@property (nonatomic,copy) NSString *signAddr;

@end
