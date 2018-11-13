//
//  ParkMessageModel.h
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/6/26.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "BaseModel.h"

@interface ParkMessageModel : BaseModel

/*
 {
 "IS_READ": "0",   --是否已读
 "MESSAGE_TYPE": "01",  消息类型
 "PUSH_CONTENT": "您的账号在另外一处登录，若是本人操作，请忽略！",
 "PUSH_ID": 351,   --
 "PUSH_STATUS": "1",  -- 0 未推送 1 推送  成功 2 推送失败
 "PUSH_TIMESTR": "2017-11-29 16:11:24",  推送时间
 "PUSH_TITLE": "账号异常登录",
 "PUSH_TYPE": "01",
 "ROWNUM_": 1
 }
 */

@property (nonatomic, copy) NSString *IS_READ;
@property (nonatomic, copy) NSString *MESSAGE_TYPE;
@property (nonatomic, copy) NSString *PUSH_CONTENT;
@property (nonatomic, strong) NSNumber *PUSH_ID;
@property (nonatomic, copy) NSString *PUSH_STATUS;
@property (nonatomic, copy) NSString *PUSH_TIMESTR;
@property (nonatomic, copy) NSString *PUSH_TITLE;
@property (nonatomic, copy) NSString *PUSH_TYPE;
@property (nonatomic, strong) NSNumber *ROWNUM_;
@property (nonatomic, copy) NSString *MESSAGE_PUSH_TABLE;
@property (nonatomic, copy) NSString *MESSAGE_PUSH_INDEX;

@property (nonatomic, copy) NSString *headerImage;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *UNREAD_SUM;

@end
