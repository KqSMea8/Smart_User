//
//  AttDetailOtherTableViewCell.m
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/7/27.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "AttDetailOtherTableViewCell.h"

@interface AttDetailOtherTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *typeView;
@property (weak, nonatomic) IBOutlet UILabel *hourTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *locationLab;

@end

@implementation AttDetailOtherTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(KQDetailModel *)model
{
    _model = model;
    
    NSString *hourStr = [model.signTime substringWithRange:NSMakeRange(11, 8)];
    _hourTimeLab.text = [NSString stringWithFormat:@"%@",hourStr];
    
    _locationLab.text = [NSString stringWithFormat:@"%@",model.signAddr];
    
    if ([model.channel isEqualToString:@"1"]) {
        _typeView.image = [UIImage imageNamed:@"phone_Dk"];
    }else{
        _typeView.image = [UIImage imageNamed:@"faceRecognition"];
    }
    
    if ([model.validFlag isEqualToString:@"1"]||[model.validFlag isEqualToString:@"2"]) {
        _hourTimeLab.textColor = [UIColor colorWithHexString:@"#1B82D1"];
        _locationLab.textColor = [UIColor colorWithHexString:@"#1B82D1"];
    }else{
        _hourTimeLab.textColor = [UIColor blackColor];
        _locationLab.textColor = [UIColor blackColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
