//
//  IFLYPopTableViewCell.h
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/9/10.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IFLYPopModel.h"

@interface IFLYPopTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *backView; // 气泡
@property (nonatomic,strong) UILabel *contentLabel; // 气泡内文本

- (void)refreshCell:(IFLYPopModel *)model; //cell

@end
