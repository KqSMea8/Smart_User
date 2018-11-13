//
//  YDKTableViewCell.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2018/3/22.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KqStatusModel.h"

@protocol onWorkRecordDelegate <NSObject>

-(void)onWorkreSaveRecord:(NSString *)signType;

@end

@interface YDKTableViewCell : UITableViewCell

@property (nonatomic,copy) NSString *onWorkTime;
@property (nonatomic,copy) NSString *signAddr;
@property (nonatomic,strong) KqStatusModel *model;
@property (nonatomic,copy) NSString *islack;
@property (nonatomic,copy) NSString *isWorkDay;

@property (nonatomic,weak) id<onWorkRecordDelegate> delegate;

@end
