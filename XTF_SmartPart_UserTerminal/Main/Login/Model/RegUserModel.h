//
//  RegUserModel.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 魏唯隆 on 2017/12/7.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "BaseModel.h"

@interface RegUserModel : BaseModel

/*
{
    "authId": "6011985784d04be1a97387471cb2433a",  ---
    "authType": "1",   --1 普通注册 2 qq认证3 微信认证4 新浪微博
    "certIds": "073124",---员工卡号
    "companyName": "",---公司名称
    "custHeadImage": "http://www.sina.com.cn",---头像地址
    "custId": "6011985784d04be1a97387471cb2433a",---客户ID
    "custMobile": "153084081234",---手机号
    "custName": "测试",---客户姓名
    "custPwd": "96e79218965eb72c92a549dd5a330112",--客户密码
    "equId": "124123",  --极光推送设备ID
    "equIdType": "0",  ---0:ANDROID 1:IOS 2:微信 3：WP
    "isMobile": "1",  --是否手机号码  1是  0否
    "mobileModel": "HUAWEI-COD1",---手机型号
    "orgName": "11",   ---部门名称
    "result": "OK",
    "roleId": 3   --客户所属角色
}
*/

@property (nonatomic,copy) NSString *authId;
@property (nonatomic,copy) NSString *authType;
@property (nonatomic,copy) NSString *certIds;
@property (nonatomic,copy) NSString *companyName;
@property (nonatomic,copy) NSString *custHeadImage;
@property (nonatomic,copy) NSString *custId;
@property (nonatomic,copy) NSString *custMobile;
@property (nonatomic,copy) NSString *custName;
@property (nonatomic,copy) NSString *custPwd;
@property (nonatomic,copy) NSString *equId;
@property (nonatomic,copy) NSString *equIdType;
@property (nonatomic,copy) NSString *isMobile;
@property (nonatomic,copy) NSString *mobileModel;
@property (nonatomic,copy) NSString *orgName;
@property (nonatomic,copy) NSString *result;
@property (nonatomic,strong) NSNumber *roleId;

@end
