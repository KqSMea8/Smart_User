//
//  WDKTableViewCell.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2018/3/22.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "WDKTableViewCell.h"
#import "Utils.h"

@interface WDKTableViewCell()
{
    __weak IBOutlet UILabel *kqTimeLab;
    __weak IBOutlet UILabel *locationLab;
    __weak IBOutlet UIImageView *locationView;
}

@property (weak, nonatomic) IBOutlet UIImageView *offWorkControls;

@end

@implementation WDKTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _offWorkControls.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(punchAction:)];
    [_offWorkControls addGestureRecognizer:tap];
}

-(void)setType:(NSString *)type
{
    _type = type;
}

-(void)setLatitude:(NSString *)latitude
{
    _latitude = latitude;
}

-(void)setLongtitude:(NSString *)longtitude
{
    _longtitude = longtitude;
}

-(void)setOnWorkTime:(NSString *)onWorkTime
{
    _onWorkTime = onWorkTime;
    kqTimeLab.text = _onWorkTime;
    
    BOOL isSatisfy = NO;
    
    NSString *positionStr = [kUserDefaults objectForKey:kqPosition];
    NSArray *positionArr = [positionStr componentsSeparatedByString:@"|"];
    
    NSString *range = [kUserDefaults objectForKey:kqRange];
    for (int i = 0; i < positionArr.count; i++) {
        NSString *postion = positionArr[i];
        NSArray *currComPositionArr = [postion componentsSeparatedByString:@","];
        double distance = [Utils distanceBetweenOrderBy:[_latitude doubleValue] :[currComPositionArr.lastObject doubleValue] :[_longtitude doubleValue] :[currComPositionArr.firstObject doubleValue]];
        if (distance < [range doubleValue]) {
            isSatisfy = YES;
        }
    }
    
    if ([_type isEqualToString:@"0"]) {
        if (isSatisfy) {
            NSString *time = [kUserDefaults objectForKey:kqTime];
            NSArray *timeArr = [time componentsSeparatedByString:@","];
            NSString *onWorkTimeStr = timeArr.firstObject;
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"HH:mm"];
            NSDate *onWorkDate = [formatter dateFromString:onWorkTimeStr];
            int i = [Utils compareOneDay:onWorkDate withAnotherDay:[NSDate date]];
//            if (i == -1) {
//                _typeLab.text = @"迟到打卡";
//                _offWorkControls.image = [UIImage imageNamed:@"dkbg_yellow"];
//            }else if(i == 1){
//                _typeLab.text = @"上班打卡";
//                _offWorkControls.image = [UIImage imageNamed:@"dkbg"];
//            }else{
//                _typeLab.text = @"上班打卡";
//                _offWorkControls.image = [UIImage imageNamed:@"dkbg"];
//            }
            _typeLab.text = @"上班打卡";
            _offWorkControls.image = [UIImage imageNamed:@"dkbg"];
            locationLab.text = [NSString stringWithFormat:@"已进入考勤范围：%@",_signAddr];
            locationView.image = [UIImage imageNamed:@"postion"];
        }else{
//            _typeLab.text = @"外勤打卡";
            _typeLab.text = @"上班打卡";
            locationLab.text = [NSString stringWithFormat:@"未进入考勤范围：%@",_signAddr];
            _offWorkControls.image = [UIImage imageNamed:@"dkbg_gray"];
            locationView.image = [UIImage imageNamed:@"location_gray"];
        }
    }else{
        if (isSatisfy) {
            NSString *time = [kUserDefaults objectForKey:kqTime];
            NSArray *timeArr = [time componentsSeparatedByString:@","];
            NSString *offWorkTimeStr = timeArr.lastObject;
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"HH:mm"];
            NSDate *offWorkDate = [formatter dateFromString:offWorkTimeStr];
            NSDate *currentDate = [NSDate date];
           
            int i = [Utils compareOneDay:offWorkDate withAnotherDay:currentDate];
            
//            if (i == -1) {
//                _typeLab.text = @"下班打卡";
//                _offWorkControls.image = [UIImage imageNamed:@"dkbg"];
//                locationView.image = [UIImage imageNamed:@"postion"];
//            }else if (i == 0){
//                _typeLab.text = @"下班打卡";
//                _offWorkControls.image = [UIImage imageNamed:@"dkbg"];
//                locationView.image = [UIImage imageNamed:@"postion"];
//            }else{
//                _typeLab.text = @"早退打卡";
//                _offWorkControls.image = [UIImage imageNamed:@"dkbg_yellow"];
//                locationView.image = [UIImage imageNamed:@"postion"];
//            }
            _typeLab.text = @"下班打卡";
            _offWorkControls.image = [UIImage imageNamed:@"dkbg"];
            locationView.image = [UIImage imageNamed:@"postion"];
            if ([_signAddr isKindOfClass:[NSNull class]]||_signAddr == nil||_signAddr.length == 0) {
                locationLab.text = [NSString stringWithFormat:@"已进入考勤范围：定位失败"];
            }else{
                locationLab.text = [NSString stringWithFormat:@"已进入考勤范围：%@",_signAddr];
            }
            
        }else{
//            _typeLab.text = @"外勤打卡";
            _typeLab.text = @"下班打卡";
            if ([_signAddr isKindOfClass:[NSNull class]]||_signAddr == nil||_signAddr.length == 0) {
                locationLab.text = [NSString stringWithFormat:@"未进入考勤范围：定位失败"];
            }else{
                locationLab.text = [NSString stringWithFormat:@"未进入考勤范围：%@",_signAddr];
            }
            
            _offWorkControls.image = [UIImage imageNamed:@"dkbg_gray"];
            locationView.image = [UIImage imageNamed:@"location_gray"];
        }
    }
}

-(void)setSignAddr:(NSString *)signAddr
{
    _signAddr = signAddr;
}

-(void)punchAction:(UITapGestureRecognizer *)tap
{
    if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(panch:)]) {
        if (_type != nil) {
            if ([_type isEqualToString:@"0"]) {
                [self.delegate panch:@"IN"];
            }else{
                [self.delegate panch:@"OUT"];
            }
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
