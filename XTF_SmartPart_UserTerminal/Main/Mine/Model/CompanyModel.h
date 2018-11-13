//
//  CompanyModel.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/14.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "BaseModel.h"

@interface CompanyModel : BaseModel

/*
 {
 "COMPANY_ID" = 1;
 "COMPANY_NAME" = "\U6e56\U5357\U7701\U901a\U4fe1\U4ea7\U4e1a\U670d\U52a1\U6709\U9650\U516c\U53f8";
 "COMPANY_NAME_DESC" = "\U7701\U901a\U670d";
 }
 */

@property (nonatomic,copy) NSString *COMPANY_NAME;
@property (nonatomic,copy) NSString *COMPANY_NAME_DESC;
@property (nonatomic,strong) NSNumber *COMPANY_ID;

@end
