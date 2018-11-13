//
//  PayTypeTableViewCell.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/20.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "PayTypeTableViewCell.h"

@implementation PayTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(SelectPayTypeModel *)model
{
    _model = model;
    
    _typeNameLab.text = model.descriptionMsg;
    
    _typeView.image = [UIImage imageNamed:model.payTypeImage];
    
    if ([model.status isEqualToString:@"1"]) {
        _selectBtn.hidden = NO;
    }else{
        _selectBtn.hidden = YES;
    }
    
}

@end
