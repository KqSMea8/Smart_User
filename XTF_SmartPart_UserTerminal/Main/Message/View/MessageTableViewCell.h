//
//  MessageTableViewCell.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/5.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParkMessageModel.h"

@interface MessageTableViewCell : UITableViewCell

@property (nonatomic,retain) ParkMessageModel *model;

@end
