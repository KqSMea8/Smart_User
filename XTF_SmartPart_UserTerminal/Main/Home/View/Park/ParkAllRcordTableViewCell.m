//
//  ParkAllRcordTableViewCell.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/2.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "ParkAllRcordTableViewCell.h"

@implementation ParkAllRcordTableViewCell
{
    __weak IBOutlet UILabel *_carnoLabel;
    
    __weak IBOutlet UIImageView *_stateImgView;
    
    __weak IBOutlet UILabel *_inTimeTitle;
    __weak IBOutlet UILabel *_outTimeTitle;
    __weak IBOutlet UILabel *_timeLongTitle;
    
    __weak IBOutlet UILabel *_inTimeLabel;
    __weak IBOutlet UILabel *_outTimeLabel;
    __weak IBOutlet UILabel *_timeLongLabel;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setCarRecordModel:(CarRecordModel *)carRecordModel {
    _carRecordModel = carRecordModel;
    
    _carnoLabel.text = carRecordModel.traceCarno;
    
    if(![carRecordModel.traceBegin isKindOfClass:[NSNull class]]&&carRecordModel.traceBegin != nil){
        NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
        [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [inputFormatter setDateFormat:@"yyyyMMddHHmmss"];
        NSDate *inDate = [inputFormatter dateFromString:carRecordModel.traceBegin];
        
        NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        NSString *formatStr = [formatter stringFromDate:inDate];
        
        _inTimeLabel.text = formatStr;
    }
    
    if([carRecordModel.traceResult isEqualToString:@"00"]){
        // 已出场
        _stateImgView.image = [UIImage imageNamed:@"carout"];
        
        if(![carRecordModel.traceEnd isKindOfClass:[NSNull class]]&&carRecordModel.traceEnd != nil){
            NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
            [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
            [inputFormatter setDateFormat:@"yyyyMMddHHmmss"];
            NSDate *inDate = [inputFormatter dateFromString:carRecordModel.traceEnd];
            
            NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
            [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
            [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
            NSString *formatStr = [formatter stringFromDate:inDate];
            
            _outTimeLabel.text = formatStr;
        }
        
        _timeLongLabel.text = [self traceTime:carRecordModel.traceTime];
        
    }else {
        _stateImgView.image = [UIImage imageNamed:@"carin"];
        _outTimeLabel.text = @"未出场";
        
        _timeLongLabel.text = [self timeLong:carRecordModel.traceBegin];
    }
}

#pragma mark 已离场根据停车时长计算时间
- (NSString *)traceTime:(NSNumber *)traceTime {
    CGFloat time = traceTime.floatValue * 60;
    NSString *timeStr;
    if(time/3600 > 24) {
        timeStr = [NSString stringWithFormat:@"%.1d天%.1d小时%.1d分钟", (int)time/3600/24, (int)time/60/60%24, (int)time/60%60];
    }else if(time/3600 > 1){
        timeStr = [NSString stringWithFormat:@"0天%.1d小时%.1d分钟", (int)time/3600, (int)time%3600/60];
    }else {
        timeStr = [NSString stringWithFormat:@"0天0小时%.1d分钟", (int)time%3600/60];
    }
    return timeStr;
}

#pragma mark 停车中根据入场时间计算停车时长
- (NSString *)timeLong:(NSString *)inTime {
    
    NSDateFormatter *dateForamt = [[NSDateFormatter alloc] init];
    [dateForamt setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *inDate = [dateForamt dateFromString:inTime];
    
    NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:inDate];
    
    NSString *timeStr;
    if(time/3600 > 24) {
        timeStr = [NSString stringWithFormat:@"%.1d天%.1d小时%.1d分钟", (int)time/3600/24, (int)time/60/60%24, (int)time/60%60];
    }else if(time/3600 > 1){
        timeStr = [NSString stringWithFormat:@"0天%.1d小时%.1d分钟", (int)time/3600, (int)time%3600/60];
    }else {
        timeStr = [NSString stringWithFormat:@"0天0小时%.1d分钟", (int)time%3600/60];
    }
    
    return timeStr;
}


@end
