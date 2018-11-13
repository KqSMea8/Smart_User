//
//  ParkMsgModel.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 魏唯隆 on 2017/12/14.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "BaseModel.h"

@interface ParkMsgModel : BaseModel
/*
 {
 "pushId": "4028e44254c69ee10154cd36bfa00070",
 "pushMember": "4028e44254c7b5a80154cc487a2f013e",
 "pushEquit": "",
 "pushType": "3",
 "pushTitle": "会员登录",
 "pushContent": "155***6835用户在2016-06-01 12:30登录2",
 "pushTime": "20160601123023",
 "pushStatus": "0",
 "pushMessageIndex": ""
 }
 */

@property (nonatomic,copy) NSString *pushId;
@property (nonatomic,copy) NSString *pushMember;
@property (nonatomic,copy) NSString *pushEquit;
@property (nonatomic,copy) NSString *pushType;
@property (nonatomic,copy) NSString *pushTitle;
@property (nonatomic,copy) NSString *pushContent;
@property (nonatomic,copy) NSString *pushTime;
@property (nonatomic,copy) NSString *pushStatus;
@property (nonatomic,copy) NSString *pushMessageIndex;
@end
