//
//  CarMessageView.m
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/6/21.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "CarMessageView.h"
#import "UIButton+ImageTitleSpacing.h"
#import "Utils.h"
#import "ParkHomeViewController.h"

@interface CarMessageView()
{
    NSInteger _aptTime; // 单位秒
    UILabel *_timeLab;
    NSTimer *_timer;
    NSDate *_enterBDate;
}

@end

@implementation CarMessageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _aptTime = 1800;
        [self initView];
    }
    return self;
}

-(void)initView{
    [kNotificationCenter addObserver:self selector:@selector(applicationBecomeActive) name:@"EnterForegroundAlert" object:nil];
    [kNotificationCenter addObserver:self selector:@selector(applicationEnterBackground) name:@"EnterBackgroundNotification" object:nil];
}

- (void)applicationEnterBackground {
    
    _enterBDate = [NSDate date];
    _timer.fireDate = [NSDate distantFuture];
}

- (void)applicationBecomeActive {
    if ([_timer isValid]) {
        NSDate *activeDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSString *time = [Utils dateTimeDifferenceWithStartTime:[dateFormatter stringFromDate:_enterBDate] endTime:[dateFormatter stringFromDate:activeDate]];
        
        if ([time integerValue]>=_aptTime) {
            [self.viewController.navigationController popViewControllerAnimated:YES];
        }else{
            _aptTime = _aptTime - [time integerValue];
            //        UIViewController *VC = [Utils getCurrentVC];
            //        if ([VC isKindOfClass:[ParkHomeViewController class]]) {
            //
            //        }
        }
        [self startTime];
    }
}

-(void)setCurrentTime:(NSString *)currentTime
{
    _currentTime = currentTime;
}

-(void)setCarRecordModel:(CarRecordModel *)carRecordModel
{
    _carRecordModel = carRecordModel;
    
    if ([carRecordModel.isBooking isEqualToString:@"1"]) {
        UIButton *navBtn = [[UIButton alloc] initWithFrame:CGRectMake(KScreenWidth - 126, 5.5, 119, 36)];
        navBtn.backgroundColor = [UIColor colorWithHexString:@"#E7F5FF"];
        navBtn.layer.cornerRadius = 5;
        navBtn.layer.borderColor = [UIColor colorWithHexString:@"#1B82D1"].CGColor;
        navBtn.layer.borderWidth = 0.5;
        [navBtn.titleLabel setFont:[UIFont fontWithName:@"MicrosoftYaHei" size:17]];
        [navBtn setTitle:@"导航前往" forState:UIControlStateNormal];
        [navBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [navBtn setImage:[UIImage imageNamed:@"list_right_narrow_black"] forState:UIControlStateNormal];
        [navBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:2];
        [navBtn addTarget:self action:@selector(navBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:navBtn];
        
        UIButton *unlockBtn = [[UIButton alloc] initWithFrame:CGRectMake(KScreenWidth - 126, navBtn.bottom+5, 119, 36)];
        unlockBtn.backgroundColor = [UIColor colorWithHexString:@"#E7F5FF"];
        unlockBtn.layer.cornerRadius = 5;
        unlockBtn.layer.borderColor = [UIColor colorWithHexString:@"#1B82D1"].CGColor;
        [unlockBtn.titleLabel setFont:[UIFont fontWithName:@"MicrosoftYaHei" size:17]];
        unlockBtn.layer.borderWidth = 0.5;
        [unlockBtn setTitle:@"打开车位锁" forState:UIControlStateNormal];
        [unlockBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [unlockBtn setImage:[UIImage imageNamed:@"list_right_narrow_black"] forState:UIControlStateNormal];
        [unlockBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:2];
        [unlockBtn addTarget:self action:@selector(unlockBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:unlockBtn];
        
        UIButton *cancleBookBtn = [[UIButton alloc] initWithFrame:CGRectMake(KScreenWidth - 126, unlockBtn.bottom+5, 119, 36)];
        cancleBookBtn.backgroundColor = [UIColor colorWithHexString:@"#E7F5FF"];
        cancleBookBtn.layer.cornerRadius = 5;
        cancleBookBtn.layer.borderColor = [UIColor colorWithHexString:@"#1B82D1"].CGColor;
        [cancleBookBtn.titleLabel setFont:[UIFont fontWithName:@"MicrosoftYaHei" size:17]];
        cancleBookBtn.layer.borderWidth = 0.5;
        [cancleBookBtn setTitle:@"取消预约" forState:UIControlStateNormal];
        [cancleBookBtn setTitleColor:[UIColor colorWithHexString:@"#FF4359"] forState:UIControlStateNormal];
        [cancleBookBtn setImage:[UIImage imageNamed:@"list_right_narrow_red"] forState:UIControlStateNormal];
        [cancleBookBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:2];
        [cancleBookBtn addTarget:self action:@selector(cancleBookBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancleBookBtn];
        
        UIView *recordBgView = [[UIView alloc] initWithFrame:CGRectMake(7, 5, KScreenWidth-119-17.5, 36*3+10)];
        recordBgView.layer.cornerRadius = 10;
        recordBgView.layer.borderWidth = 0.5;
        recordBgView.backgroundColor = [UIColor colorWithHexString:@"#E7F5FF"];
        recordBgView.layer.borderColor = [UIColor colorWithHexString:@"#1B82D1"].CGColor;
        [self addSubview:recordBgView];
        
        UIImageView *carNoBgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(6.5, 9, 141.5, 50)];
        carNoBgImgView.image = [UIImage imageNamed:@"car_no_bg_blue"];
        [recordBgView addSubview:carNoBgImgView];
        
        UILabel *carNolabel = [[UILabel alloc] initWithFrame:CGRectMake(carNoBgImgView.left, carNoBgImgView.top + 18, carNoBgImgView.width, 25)];
        carNolabel.text = carRecordModel.traceCarno;
        carNolabel.textColor = [UIColor whiteColor];
        carNolabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:23];
        carNolabel.textAlignment = NSTextAlignmentCenter;
        [recordBgView addSubview:carNolabel];
        
        UILabel *parkSpaceLab = [[UILabel alloc] initWithFrame:CGRectMake(carNoBgImgView.left, carNoBgImgView.bottom+10, recordBgView.width - 13, 21)];
        parkSpaceLab.text = [NSString stringWithFormat:@"%@ 预约中",carRecordModel.orderModel.parkingSpaceName];
        parkSpaceLab.font = [UIFont fontWithName:@"MicrosoftYaHei" size:17];
        parkSpaceLab.textAlignment = NSTextAlignmentLeft;
        [recordBgView addSubview:parkSpaceLab];
        
        UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(carNoBgImgView.left, parkSpaceLab.bottom+3, recordBgView.width - 13, 21)];
        timeLab.text = @"剩余时间 00:00:00";
        timeLab.font = [UIFont fontWithName:@"MicrosoftYaHei" size:17];
        timeLab.textAlignment = NSTextAlignmentLeft;
        [recordBgView addSubview:timeLab];
        _timeLab = timeLab;
        
        NSString *sencond = [Utils dateTimeDifferenceWithStartTime:carRecordModel.orderModel.orderTime endTime:_currentTime];
        _aptTime = _aptTime - [sencond integerValue];

        [self startTime];
        
    }else{
        
        UIImageView *carNoBgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, (self.height - 60)/2, 170, 60)];
        carNoBgImgView.image = [UIImage imageNamed:@"car_no_bg_blue"];
        [self addSubview:carNoBgImgView];
        
        UILabel *carNolabel = [[UILabel alloc] initWithFrame:CGRectMake(carNoBgImgView.left, carNoBgImgView.top + 20, carNoBgImgView.width, 25)];
        carNolabel.text = carRecordModel.traceCarno;
        carNolabel.textColor = [UIColor whiteColor];
        carNolabel.font = [UIFont systemFontOfSize:25];
        carNolabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:carNolabel];
        
        // 停车场
        UILabel *parkNamelabel = [[UILabel alloc] initWithFrame:CGRectMake(carNoBgImgView.right + 20, 28, KScreenWidth - carNoBgImgView.right - 32, 17)];
        if(![carRecordModel.traceParkname isKindOfClass:[NSNull class]]&&carRecordModel.traceParkname != nil){
            parkNamelabel.text = carRecordModel.traceParkname;
        }
        parkNamelabel.textColor = [UIColor blackColor];
        parkNamelabel.font = [UIFont systemFontOfSize:17];
        parkNamelabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:parkNamelabel];
        
        // 进场时间
        UILabel *inTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(parkNamelabel.left, parkNamelabel.bottom + 12, parkNamelabel.width, 17)];
        inTimeLabel.text = @"";
        inTimeLabel.font = [UIFont systemFontOfSize:16];
        inTimeLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:inTimeLabel];
        if(![carRecordModel.traceBegin isKindOfClass:[NSNull class]]&&carRecordModel.traceBegin != nil){
            NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
            [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
            [inputFormatter setDateFormat:@"yyyyMMddHHmmss"];
            NSDate *inDate = [inputFormatter dateFromString:carRecordModel.traceBegin];
            
            NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
            [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
            [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
            NSString *formatStr = [formatter stringFromDate:inDate];
            
            inTimeLabel.text = formatStr;
        }
        
        // 无正在停车记录的居中显示
        if(carRecordModel.traceParkname == nil || [carRecordModel.traceParkname isKindOfClass:[NSNull class]] || carRecordModel.traceParkname.length <= 0){
            inTimeLabel.text = @"该车辆暂未入场";
        }
        
        // 停车时长
        UILabel *timeLongLabel = [[UILabel alloc] initWithFrame:CGRectMake(parkNamelabel.left, inTimeLabel.bottom + 12, parkNamelabel.width, 17)];
        timeLongLabel.text = @"";
        timeLongLabel.font = [UIFont systemFontOfSize:17];
        timeLongLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:timeLongLabel];
        if(![carRecordModel.traceBegin isKindOfClass:[NSNull class]]&&carRecordModel.traceBegin != nil){
            timeLongLabel.text = [self timeLong:carRecordModel.traceBegin];
        }
    }
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
        timeStr = [NSString stringWithFormat:@"%.1d小时%.1d分钟", (int)time/3600, (int)time%3600/60];
    }else {
        timeStr = [NSString stringWithFormat:@"%.1d分钟", (int)time%3600/60];
    }
    
    return timeStr;
}

- (void)startTime {
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
        _aptTime --;
        NSString *minStr = [NSString stringWithFormat:@"%ld", _aptTime/60];
        if(minStr.length < 2){
            minStr = [NSString stringWithFormat:@"0%@", minStr];
        }

        NSString *secStr = [NSString stringWithFormat:@"%ld", _aptTime%60];
        if(secStr.length < 2){
            secStr = [NSString stringWithFormat:@"0%@", secStr];
        }
        _timeLab.text = [NSString stringWithFormat:@"剩余时间 00:%@:%@",minStr,secStr];

        if(_aptTime <= 0){
            _timeLab.text = [NSString stringWithFormat:@"剩余时间 00:00:00"];
            [self.viewController showHint:@"未在规定时间内停入车场,预定车位被取消!"];
            [self.viewController.navigationController popViewControllerAnimated:YES];
            [timer invalidate];
        }
    } repeats:YES];
}

-(void)navBtnAction:(id)sender
{
    if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(navToParkSpace:)]) {
        [self.delegate navToParkSpace:sender];
    }
}

-(void)cancleBookBtnAction:(id)sender
{
    if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(cancleBookParkSpace:)]) {
        [self.delegate cancleBookParkSpace:sender];
    }
}

-(void)unlockBtnAction:(id)sender
{
    if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(unlockParkSpace:)]) {
        [self.delegate unlockParkSpace:sender];
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (! newSuperview && _timer) {
        // 销毁定时器
        [_timer invalidate];
        _timer = nil;
    }
    if (!newSuperview) {
        [kNotificationCenter removeObserver:self name:@"EnterForegroundAlert" object:nil];
        [kNotificationCenter removeObserver:self name:@"EnterBackgroundNotification" object:nil];
    }
}

@end
