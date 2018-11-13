//
//  BookRecordTableViewCell.h
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/6/6.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BookRecordModel;
@class BookRecordParkSpaceModel;
@class BookRecordParkAreaModel;

@interface BookRecordTableViewCell : UITableViewCell

@property (nonatomic,retain) BookRecordModel *model;
@property (nonatomic,retain) BookRecordParkSpaceModel *parkSpaceModel;
@property (nonatomic,retain) BookRecordParkAreaModel *parkAreaModel;

@end
