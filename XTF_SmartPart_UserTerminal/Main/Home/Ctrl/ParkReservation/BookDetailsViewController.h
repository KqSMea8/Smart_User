//
//  BookDetailsViewController.h
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/6/5.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "BaseTableViewController.h"
@class BookRecordModel;
@class BookRecordParkAreaModel;
@class BookRecordParkSpaceModel;

@interface BookDetailsViewController : BaseTableViewController

//@property (nonatomic,retain) NSMutableDictionary *dataDic;
@property (nonatomic,retain) BookRecordModel *orderModel;
@property (nonatomic,retain) BookRecordParkSpaceModel *parkSpaceModel;
@property (nonatomic,retain) BookRecordParkAreaModel *parkAreaModel;
@property (nonatomic,copy) NSString *currentTime;

@end
