//
//  ReservationRemindViewController.h
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/6/5.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "RootViewController.h"

typedef enum{
    BookCancle,
    BookFailure,
    BookParkAreaOpen,
} BookRemaindType;

@interface ReservationRemindViewController : RootViewController

@property (nonatomic,copy) NSString *orderId;
@property (nonatomic,assign) BookRemaindType type;

@end
