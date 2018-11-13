//
//  RepairStateTableViewCell.m
//  XTF_SmartPart_UserTerminal
//
//  Created by jiaop on 2018/5/8.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "RepairStateTableViewCell.h"

@interface RepairStateTableViewCell(){
    
    __weak IBOutlet UILabel *reportedTimeLab;
    
    __weak IBOutlet UIImageView *repairStateView;
    
    __weak IBOutlet UILabel *malfunctionLab;
}

@end

@implementation RepairStateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(RepairModel *)model
{
    _model = model;
    if (![model.alarmTime isKindOfClass:[NSNull class]]&&model.alarmTime != nil) {
        reportedTimeLab.text = [NSString stringWithFormat:@"%@",model.alarmTime];
    }
    
    if ([model.alarmState isEqualToString:@"0"]||[model.alarmState isEqualToString:@"3"]) {
        repairStateView.image = [UIImage imageNamed:@"waitReceived"];
    }else if ([model.alarmState isEqualToString:@"1"]){
        repairStateView.image = [UIImage imageNamed:@"repairing"];
    }else if ([model.alarmState isEqualToString:@"2"]||[model.alarmState isEqualToString:@"9"]){
        repairStateView.image = [UIImage imageNamed:@"completed_Subscript"];
    }else{
        repairStateView.image = [UIImage imageNamed:@""];
    }
    
    malfunctionLab.text = [NSString stringWithFormat:@"故障：%@",model.alarmInfo];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
