//
//  VisitReasonModel.h
//  DXWingGate
//
//  Created by coder on 2018/9/14.
//  Copyright © 2018年 com.Transfar. All rights reserved.
//

#import "BaseModel.h"

@interface VisitReasonModel : BaseModel
/*
 {
 dictCode = "visit_reasion";
 dictItemCode = "\U62dc\U8bbf";
 dictItemId = 1;
 dictItemValue = 1;
 orderValue = 1;
 status = 1;
 }
 */

@property (nonatomic,copy) NSString *dictCode;
@property (nonatomic,copy) NSString *dictItemCode;
@property (nonatomic,copy) NSString *dictItemId;
@property (nonatomic,copy) NSString *dictItemValue;
@property (nonatomic,copy) NSString *orderValue;
@property (nonatomic,copy) NSString *status;

@end
