//
//  VisitHistoryModel.h
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/9/14.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "BaseModel.h"

@interface VisitHistoryModel : BaseModel

/*
 {
 appointmentId = 20180914117026;
 arriveTime = "<null>";
 beginTime = 1536886800000;
 cancelTime = "<null>";
 carNo = "<null>";
 createTime = 1536908204000;
 endTime = 1536897600000;
 logoffTime = "<null>";
 persionWith = "<null>";
 qrCode = "http://220.168.59.15:8081/hntfEsb/upload/images/visit/E1664A6B6490CC376D5095AF4A308E5D.jpg";
 reasionDesc = "\U62dc\U8bbf";
 reasionId = 1;
 remark = "<null>";
 reserveFive = "<null>";
 reserveFour = "<null>";
 reserveOne = "<null>";
 reserveThree = "<null>";
 reserveTwo = "<null>";
 status = 0;
 tempCardId = 0000003371;
 tempCardNo = 000fd2f6;
 userId = 9ad64aa732e1415dbbce877a5998866f;
 userName = "\U7126\U5e73";
 visitorName = "\U9a6c\U6d69\U7136";
 visitorPhone = 18175670259;
 visitorSex = 1;
 }
 */

@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *appointmentId;
@property (nonatomic,copy) NSString *logoffTime;
@property (nonatomic,copy) NSString *reasionDesc;
@property (nonatomic,copy) NSString *reasionId;

@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *visitorName;
@property (nonatomic,copy) NSString *visitorSex;
@property (nonatomic,retain) NSNumber *endTime;
@property (nonatomic,copy) NSString *reserveFive;

@property (nonatomic,copy) NSString *qrCode;
@property (nonatomic,copy) NSString *reserveOne;
@property (nonatomic,copy) NSString *reserveTwo;
@property (nonatomic,copy) NSString *tempCardId;
@property (nonatomic,copy) NSString *tempCardNo;

@property (nonatomic,copy) NSString *persionWith;
@property (nonatomic,copy) NSString *reserveFour;
@property (nonatomic,copy) NSString *carNo;
@property (nonatomic,copy) NSString *visitorPhone;
@property (nonatomic,copy) NSString *reserveThree;

@property (nonatomic,retain) NSNumber *arriveTime;
@property (nonatomic,retain) NSNumber *createTime;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *remark;
@property (nonatomic,retain) NSNumber *beginTime;

@property (nonatomic,retain) NSNumber *cancelTime;

@end
