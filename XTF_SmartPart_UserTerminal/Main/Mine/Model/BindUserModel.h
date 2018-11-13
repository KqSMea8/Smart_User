//
//  BindUserModel.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/11.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "BaseModel.h"

@interface BindUserModel : BaseModel
/*
{
    authId = "o-xfPw1zovK3fH5-Qtj7600_OZNw";
    authType = 3;
    certIds = "";
    companyName = "\U90e8\U95e8";
    custId = 18df30e4c3244851bfd674c1b447b07f;
    custMobile = 15116664934;
    custName = "\U7126\U5e73";
    isMobile = 1;
    orgName = "\U90e8\U95e8";
    result = OK;
    roleId = 4;
}
*/

@property (nonatomic,copy) NSString *authId;
@property (nonatomic,copy) NSString *custId;
@property (nonatomic,copy) NSString *result;
@property (nonatomic,copy) NSString *authType;
@property (nonatomic,strong) NSNumber *roleId;
@property (nonatomic,copy) NSString *certIds;
@property (nonatomic,copy) NSString *companyName;
@property (nonatomic,copy) NSString *custMobile;
@property (nonatomic,copy) NSString *custName;
@property (nonatomic,copy) NSString *isMobile;
@property (nonatomic,copy) NSString *orgName;

@end
