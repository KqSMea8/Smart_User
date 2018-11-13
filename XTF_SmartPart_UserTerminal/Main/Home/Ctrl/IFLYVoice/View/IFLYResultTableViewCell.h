//
//  IFLYResultTableViewCell.h
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/9/6.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstMenuModel.h"

@interface IFLYResultTableViewCell : UITableViewCell

@property (nonatomic,retain) FirstMenuModel *model;
@property (nonatomic,copy) NSString *matchStr;

@end
