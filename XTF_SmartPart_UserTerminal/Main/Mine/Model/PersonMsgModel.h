//
//  PersonMsgModel.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/14.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "BaseModel.h"

@interface PersonMsgModel : BaseModel

/*
 {
 "CERT_IDS" = 020701;
 "COMPANY_NAME" = "<null>";
 "CREATE_DATE" = "2017-12-12 20:31:32";
 "CUST_HEADIMAGE" = "https://wx.qlogo.cn/mmopen/vi_32/JiaeMlEKcF9u3hibrfnsNyiaLLzgWYicno48V7CLAH0CkAhUJNibqicRibTw029DCewOAvibU953XIevvPwmWYPCibibgNPg/0";
 "CUST_ID" = d9f4245d2fa64fda81ba5a94ff40a21e;
 "CUST_MOBILE" = 13272010300;
 "CUST_NAME" = "\U7126\U5e73";
 "CUST_PASSWD" = "<null>";
 "IS_SECRET_PAY" = 0;
 "IS_SMALL_PAY" = 0;
 "IS_VALID" = 1;
 "MODIFY_DATE" = "2017-12-12 21:09:13";
 "ORG_ID" = "<null>";
 "ORG_NAME" = "<null>";
 "PAY_PASSWD" = "<null>";
 "PERSON_SIGN" = "<null>";
 }
 */

@property (nonatomic,copy) NSString *CUST_PASSWD;
@property (nonatomic,copy) NSString *CUST_HEADIMAGE;
@property (nonatomic,copy) NSString *COMPANY_NAME;
@property (nonatomic,strong) NSNumber *COMPANY_ID;
@property (nonatomic,copy) NSString *CERT_IDS;
@property (nonatomic,copy) NSString *PERSON_SIGN;
@property (nonatomic,copy) NSString *CUST_MOBILE;
@property (nonatomic,copy) NSString *CUST_NAME;
@property (nonatomic,copy) NSString *IS_SECRET_PAY;
@property (nonatomic,copy) NSString *IS_SMALL_PAY;
@property (nonatomic,copy) NSString *IS_VALID;
@property (nonatomic,copy) NSString *CUST_ID;
@property (nonatomic,copy) NSString *ORG_ID;
@property (nonatomic,copy) NSString *ORG_NAME;
@property (nonatomic,copy) NSString *PAY_PASSWD;
@property (nonatomic,copy) NSString *CREATE_DATE;
@property (nonatomic,copy) NSString *MODIFY_DATE;
@property (nonatomic,copy) NSString *FACE_IMAGE_ID;

@end
