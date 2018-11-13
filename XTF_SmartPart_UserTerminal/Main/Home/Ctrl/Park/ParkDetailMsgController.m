//
//  ParkDetailMsgController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/3.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "ParkDetailMsgController.h"

@interface ParkDetailMsgController ()
{
    
    __weak IBOutlet UILabel *_hourLabel;
    __weak IBOutlet UILabel *_minLabel;
    __weak IBOutlet UILabel *_secLabel;
    
    __weak IBOutlet UILabel *_codeLabel;
    
    __weak IBOutlet UIView *_outLineView;
    __weak IBOutlet UIImageView *_outPointImgView;
    
    __weak IBOutlet UILabel *_inTimeLabel;
    __weak IBOutlet UILabel *_carnoLabel;
    __weak IBOutlet UILabel *_outTimeLabel;
    
    __weak IBOutlet UILabel *_parknameLabel;
    
    __weak IBOutlet UIImageView *_inParkImgView;
    
    __weak IBOutlet UIImageView *_outParkImgView;
    
    __weak IBOutlet UILabel *_outParkLabel;
}
@end

@implementation ParkDetailMsgController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initNavItems];
    
    [self _initView];
}

-(void)_initNavItems
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"停车详情";
    
    UIButton *leftBtn = [[UIButton alloc] init];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [leftBtn setImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(_leftBarBtnItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)_initView {
    if(![_carRecordModel.traceTime isKindOfClass:[NSNull class]]&&_carRecordModel.traceTime != nil){
        CGFloat time = _carRecordModel.traceTime.floatValue * 60;
//        NSString *timeStr;
//        if(time/3600 > 24) {
//            timeStr = [NSString stringWithFormat:@"%.1d天%.1d小时%.1d分钟", (int)time/3600/24, (int)time/60/60%24, (int)time/60%60];
//        }else
        if(time/3600 > 1){
//            timeStr = [NSString stringWithFormat:@"%.1d小时%.1d分钟", (int)time/3600, (int)time%3600/60];
            _hourLabel.text = [NSString stringWithFormat:@"%.1d", (int)time/3600];
            _minLabel.text = [NSString stringWithFormat:@"%.1d", (int)time%3600/60];
        }else {
//            timeStr = [NSString stringWithFormat:@"%.1d分钟", (int)time%3600/60];
            _hourLabel.text = @"00";
            _minLabel.text = [NSString stringWithFormat:@"%.1d", (int)time%3600/60];
        }
        
        _secLabel.text = @"00";
    }
    
    if([_carRecordModel.traceResult isEqualToString:@"00"]){
        // 已出场
        [self traceTime:_carRecordModel.traceTime];
    }else {
        // 未出场
        [self timeLong:_carRecordModel.traceBegin];
    }
    
    if(_hourLabel.text.length < 2){
        _hourLabel.text = [NSString stringWithFormat:@"0%@", _hourLabel.text];
    }
    if(_minLabel.text.length < 2){
        _minLabel.text = [NSString stringWithFormat:@"0%@", _minLabel.text];
    }
    if(_secLabel.text.length < 2){
        _secLabel.text = [NSString stringWithFormat:@"0%@", _secLabel.text];
    }
    
    _codeLabel.text = _carRecordModel.traceIndex2;
    _carnoLabel.text = _carRecordModel.traceCarno;
    
    if(![_carRecordModel.traceBegin isKindOfClass:[NSNull class]]&&_carRecordModel.traceBegin != nil){
        NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
        [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [inputFormatter setDateFormat:@"yyyyMMddHHmmss"];
        NSDate *inDate = [inputFormatter dateFromString:_carRecordModel.traceBegin];
        
        NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        NSString *formatStr = [formatter stringFromDate:inDate];
        
        _inTimeLabel.text = formatStr;
    }
    
    _parknameLabel.text = [NSString stringWithFormat:@"%@",_carRecordModel.traceParkname];
    
    if([_carRecordModel.traceResult isEqualToString:@"00"]){
        // 已出场
        if(![_carRecordModel.traceEnd isKindOfClass:[NSNull class]]&&_carRecordModel.traceEnd != nil){
            NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
            [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
            [inputFormatter setDateFormat:@"yyyyMMddHHmmss"];
            NSDate *inDate = [inputFormatter dateFromString:_carRecordModel.traceEnd];
            
            NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
            [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
            [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
            NSString *formatStr = [formatter stringFromDate:inDate];
            
            _outTimeLabel.text = formatStr;
        }
        
    }else {
        _outLineView.backgroundColor = [UIColor grayColor];
        _outPointImgView.image = nil;
        _outPointImgView.backgroundColor = [UIColor grayColor];
        _outPointImgView.layer.masksToBounds = YES;
        _outPointImgView.layer.cornerRadius = 7.5;
        _outTimeLabel.text = @"未出场";
    }
    
    if(![_carRecordModel.traceInphoto isKindOfClass:[NSNull class]]&&_carRecordModel.traceInphoto != nil){
        NSString *photoUrl = [_carRecordModel.traceInphoto stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [_inParkImgView sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageNamed:@"icon_no_picture"]];
    }
    if(![_carRecordModel.traceOutphoto isKindOfClass:[NSNull class]]&&_carRecordModel.traceOutphoto != nil){
        NSString *photoUrl = [_carRecordModel.traceOutphoto stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [_outParkImgView sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageNamed:@"icon_no_picture"]];
    }else {
        _outParkImgView.hidden = YES;
        _outParkLabel.hidden = YES;
    }
}

- (void)_leftBarBtnItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark 已离场根据停车时长计算时间
- (NSString *)traceTime:(NSNumber *)traceTime {
    CGFloat time = traceTime.floatValue * 60;
    NSString *timeStr;
    if(time/3600 > 24) {
//        timeStr = [NSString stringWithFormat:@"%.1d天%.1d小时%.1d分钟", (int)time/3600/24, (int)time/60/60%24, (int)time/60%60];
        _hourLabel.text = [NSString stringWithFormat:@"%1d", (int)time/3600/24];
        _minLabel.text = [NSString stringWithFormat:@"%1d", (int)time/60/60%24];
        _secLabel.text = [NSString stringWithFormat:@"%1d", (int)time/60%60];
    }else if(time/3600 > 1){
//        timeStr = [NSString stringWithFormat:@"%.1d小时%.1d分钟", (int)time/3600, (int)time%3600/60];
        _hourLabel.text = @"00";
        _minLabel.text = [NSString stringWithFormat:@"%1d", (int)time/3600];
        _secLabel.text = [NSString stringWithFormat:@"%1d", (int)time%3600/60];
    }else {
//        timeStr = [NSString stringWithFormat:@"%.1d分钟", (int)time%3600/60];
        _hourLabel.text = @"00";
        _minLabel.text = @"00";
        _secLabel.text = [NSString stringWithFormat:@"%1d", (int)time%3600/60];
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
//        timeStr = [NSString stringWithFormat:@"%.1d天%.1d小时%.1d分钟", (int)time/3600/24, (int)time/60/60%24, (int)time/60%60];
        _hourLabel.text = [NSString stringWithFormat:@"%1d", (int)time/3600/24];
        _minLabel.text = [NSString stringWithFormat:@"%1d", (int)time/60/60%24];
        _secLabel.text = [NSString stringWithFormat:@"%1d", (int)time/60%60];
    }else if(time/3600 > 1){
//        timeStr = [NSString stringWithFormat:@"%.1d小时%.1d分钟", (int)time/3600, (int)time%3600/60];
        _hourLabel.text = @"00";
        _minLabel.text = [NSString stringWithFormat:@"%1d", (int)time/3600];
        _secLabel.text = [NSString stringWithFormat:@"%1d", (int)time%3600/60];
    }else {
//        timeStr = [NSString stringWithFormat:@"%.1d分钟", (int)time%3600/60];
        _hourLabel.text = @"00";
        _minLabel.text = @"00";
        _secLabel.text = [NSString stringWithFormat:@"%1d", (int)time%3600/60];
    }
    
    return timeStr;
}


@end
