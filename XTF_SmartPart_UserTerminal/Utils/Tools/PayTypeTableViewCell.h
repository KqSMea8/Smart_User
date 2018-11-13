//
//  PayTypeTableViewCell.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/20.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectPayTypeModel.h"

@interface PayTypeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *typeView;
@property (weak, nonatomic) IBOutlet UILabel *typeNameLab;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property (nonatomic,strong) SelectPayTypeModel *model;

@end
