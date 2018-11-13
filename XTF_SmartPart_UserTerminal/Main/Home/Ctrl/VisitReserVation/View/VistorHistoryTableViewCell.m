//
//  VistorHistoryTableViewCell.m
//  DXWingGate
//
//  Created by coder on 2018/9/4.
//  Copyright © 2018年 com.Transfar. All rights reserved.
//

#import "VistorHistoryTableViewCell.h"

@interface VistorHistoryTableViewCell()
{
    __weak IBOutlet UILabel *visitNameLab;
    __weak IBOutlet UILabel *visitPhoneLab;
    
    __weak IBOutlet UILabel *sexLab;
    __weak IBOutlet UILabel *carNumLab;
}

@end

@implementation VistorHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(VisitHistoryModel *)model
{
    _model = model;
    
    visitNameLab.text = [NSString stringWithFormat:@"%@",_model.visitorName];
    visitPhoneLab.text = [NSString stringWithFormat:@"%@",_model.visitorPhone];
    
    if ([_model.visitorSex isEqualToString:@"1"]) {
        sexLab.text = @"男";
    }else if ([_model.visitorSex isEqualToString:@"2"]){
        sexLab.text = @"女";
    }else{
        sexLab.text = @"未知";
    }
    
    if ([_model.carNo isKindOfClass:[NSNull class]]||_model.carNo == nil||_model.carNo.length == 0) {
        carNumLab.text = @"";
    }else{
        carNumLab.text = [NSString stringWithFormat:@"%@",_model.carNo];
    }
}

@end
