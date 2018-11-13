//
//  WDKView.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/3.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "WDKView.h"

@interface WDKView()
{
    UILabel *_signLab;
    UIImageView *_dkBgView;
    UILabel *_offWorkLab;
    UILabel *_timeLab;
    UIImageView *_locationView;
    UILabel *_locationLab;
    
    NSTimer *_timeNow;
}

@end

@implementation WDKView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _initView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self _initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initView];
    }
    return self;
}

-(void)_initView
{
    _signLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 16)];
    _signLab.text = @"待打卡";
    _signLab.font = [UIFont systemFontOfSize:17];
    _signLab.textAlignment = NSTextAlignmentLeft;
    _signLab.textColor = [UIColor blackColor];
    [self addSubview:_signLab];
    
    _dkBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_signLab.frame)+9, 160*wScale, 160*wScale)];
    _dkBgView.image = [UIImage imageNamed:@"dkbg"];
    _dkBgView.centerX = KScreenWidth/2-30;
    _dkBgView.backgroundColor = [UIColor clearColor];
    [self addSubview:_dkBgView];
    
    UITapGestureRecognizer *dkTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dkTapAction)];
    _dkBgView.userInteractionEnabled = YES;
    [_dkBgView addGestureRecognizer:dkTap];
    
    _offWorkLab = [[UILabel alloc] initWithFrame:CGRectMake(10, _dkBgView.height/2-20, _dkBgView.width-20, 20)];
    _offWorkLab.text = @"下班打卡";
    _offWorkLab.font = [UIFont systemFontOfSize:20];
    _offWorkLab.textColor = [UIColor whiteColor];
    _offWorkLab.textAlignment = NSTextAlignmentCenter;
    [_dkBgView addSubview:_offWorkLab];
    
    _timeLab = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_offWorkLab.frame)+15, _dkBgView.width-20, 14)];
    _timeLab.font = [UIFont systemFontOfSize:17];
    _timeLab.textColor = [UIColor whiteColor];
    _timeLab.textAlignment = NSTextAlignmentCenter;
    _timeLab.text = @"--:--";
    [_dkBgView addSubview:_timeLab];
    
    _locationView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_dkBgView.frame)+20*wScale, CGRectGetMaxY(_dkBgView.frame)+8.5*wScale, 15, 15)];
    _locationView.image = [UIImage imageNamed:@"kqlocation"];
    [self addSubview:_locationView];
    
    _locationLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_locationView.frame)+2.5*wScale, 0, KScreenWidth-CGRectGetMaxX(_locationView.frame)-2.5*wScale-10, 14)];
    _locationLab.centerY = _locationView.centerY;
    _locationLab.textColor = [UIColor blackColor];
    _locationLab.textAlignment = NSTextAlignmentLeft;
    _locationLab.text = @"天园培训基地";
    _locationLab.font = [UIFont systemFontOfSize:14];
    [self addSubview:_locationLab];
    
//    [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
//        [self timerFunc];
//    } repeats:YES];
    
    _timeNow = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerFunc) userInfo:nil repeats:YES];
}

- (void)timerFunc
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString *timestamp = [formatter stringFromDate:[NSDate date]];
    [_timeLab setText:timestamp];//时间在变化的语句
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];

    if (!newSuperview && _timeNow) {
        // 销毁定时器
        [_timeNow invalidate];
        _timeNow = nil;
    }
}

-(void)dkTapAction
{
    if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(dkSuccessMsg:)]) {
        [self.delegate dkSuccessMsg:self];
    }
}

@end
