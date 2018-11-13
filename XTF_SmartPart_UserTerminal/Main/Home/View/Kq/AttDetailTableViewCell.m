//
//  AttDetailTableViewCell.m
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/7/26.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "AttDetailTableViewCell.h"

@interface AttDetailTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *monthAndDayLab;
@property (weak, nonatomic) IBOutlet UIImageView *typeView;
@property (weak, nonatomic) IBOutlet UILabel *hourTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *locationLab;
@property (weak, nonatomic) IBOutlet UIImageView *isOutSideView;

@end

@implementation AttDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(KQDetailModel *)model
{
    _model = model;
    
    if (![model.isOutside isKindOfClass:[NSNull class]]&&model.isOutside != nil&&[model.isOutside isEqualToString:@"1"]) {
        _isOutSideView.hidden = NO;
    }else{
        _isOutSideView.hidden = YES;
    }
    
    NSString *monthAndDayStr = [model.signTime substringWithRange:NSMakeRange(5, 5)];
    _monthAndDayLab.text = [NSString stringWithFormat:@"%@",monthAndDayStr];
    
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
