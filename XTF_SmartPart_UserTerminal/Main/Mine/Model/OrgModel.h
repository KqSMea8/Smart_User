//
//  OrgModel.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/14.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "BaseModel.h"

@interface OrgModel : BaseModel

/*
 {
 "COMPANY_ID": 1,   ---公司ID
 "ORG_ID": 5,   -部门ID
 "ORG_INDEX": 20,  --排序
 "ORG_NAME": "综合部",  --部门名称
 "PARENT_ORG_ID": 0   ---上级部门ID,为0 表示是一级部门
 }
 */

@property (nonatomic,strong) NSNumber *COMPANY_ID;
@property (nonatomic,strong) NSNumber *ORG_ID;
@property (nonatomic,copy) NSString *ORG_INDEX;
@property (nonatomic,copy) NSString *ORG_NAME;
@property (nonatomic,strong) NSNumber *PARENT_ORG_ID;

@end
