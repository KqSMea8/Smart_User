//
//  KQDetailMonthModel.h
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/7/31.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "BaseModel.h"

@interface KQDetailMonthModel : BaseModel

/*
 {
 errorCount = 20;
 okCount = 0;
 }
 */

@property (nonatomic,strong) NSNumber *okCount;
@property (nonatomic,strong) NSNumber *errorCount;

@end
