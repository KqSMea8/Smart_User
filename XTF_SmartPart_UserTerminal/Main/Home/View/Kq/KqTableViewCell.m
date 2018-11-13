//
//  KqTableViewCell.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/4.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "KqTableViewCell.h"
#import "UIView+SDAutoLayout.h"

@interface KqTableViewCell ()
{
    UIView *wdkView;
    UIView *ydkView;
    
    UILabel *_signLab;
    UIImageView *_dkBgView;
    UILabel *_offWorkLab;
    UILabel *_timeLab;
    UIImageView *_wdkLocationView;
    UILabel *_wdkLocationLab;
    
    NSTimer *_timeNow;
}

@property (nonatomic, strong) UILabel *verticalLabel1 ;//竖线
@property (nonatomic, strong) UILabel *verticalLabel2 ;//竖线
@property (nonatomic, strong) UIButton *circleView; //圈
@property (nonatomic, strong) UILabel *titleLabel; //标题

@property (nonatomic,strong) UILabel *dkTimeLab;
@property (nonatomic,strong) UIImageView *locationView;
@property (nonatomic,strong) UILabel *locationLab;
@property (nonatomic,strong) UIButton *cxdkBtn;
@property (nonatomic,strong) UIImageView *cxdkView;
@property (nonatomic,strong) UIImageView *statusView;

@end

@implementation KqTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}
//布局
-(void)initView
{
    //竖线
    self.verticalLabel1 = [[UILabel alloc]init];
    self.verticalLabel1.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.verticalLabel1];
    
    self.verticalLabel2 = [[UILabel alloc]init];
    self.verticalLabel2.backgroundColor = [UIColor colorWithHexString:@"#1B82D1"];
    [self.contentView addSubview:self.verticalLabel2];
    
    //圆圈
    self.circleView = [UIButton buttonWithType:UIButtonTypeCustom];
    self.circleView.backgroundColor = [UIColor clearColor];
    [self.circleView setBackgroundImage:[UIImage imageNamed:@"dots_blue"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.circleView];
    
    //标题
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:self.titleLabel];
    
    //布局
    self.verticalLabel1.sd_layout
    .topEqualToView(self.contentView)
    .leftSpaceToView(self.contentView,PADDING_OF_LEFT_STEP_LINE)
    .widthIs(1)
    .heightIs(10);
    
    self.verticalLabel2.sd_layout
    .topSpaceToView(self.contentView,10)
    .leftSpaceToView(self.contentView,PADDING_OF_LEFT_STEP_LINE)
    .widthIs(1)
    .bottomEqualToView(self.contentView);
    
    self.circleView.sd_layout
    .centerXEqualToView(self.verticalLabel1)
    .centerYIs(8)
    .heightIs(16)
    .widthIs(16);
    
    self.titleLabel.sd_layout
    .leftSpaceToView(self.verticalLabel1,PADDING_OF_LEFT_RIGHT)
    .topSpaceToView(self.contentView,3)
    .heightIs(15)
    .rightEqualToView(self.contentView);
    
    wdkView = [[UIView alloc] init];
    [self.contentView addSubview:wdkView];
    wdkView.backgroundColor = [UIColor clearColor];
    wdkView.hidden = YES;
    
    wdkView.sd_layout
    .leftSpaceToView(_verticalLabel2, 10)
    .topSpaceToView(_titleLabel, 10)
    .widthIs(self.contentView.frame.size.width-CGRectGetMaxX(_verticalLabel2.frame)-10)
    .heightIs(220);
    
    _signLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 16)];
    _signLab.text = @"待打卡";
    _signLab.font = [UIFont systemFontOfSize:17];
    _signLab.textAlignment = NSTextAlignmentLeft;
    _signLab.textColor = [UIColor blackColor];
    [wdkView addSubview:_signLab];
    
    _dkBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_signLab.frame)+9, 160*wScale, 160*wScale)];
    _dkBgView.image = [UIImage imageNamed:@"dkbg"];
    _dkBgView.centerX = KScreenWidth/2-30;
    _dkBgView.backgroundColor = [UIColor clearColor];
    [wdkView addSubview:_dkBgView];
    
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
    
    
    _wdkLocationLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_dkBgView.frame)+8.5*wScale, 100, 14)];
    _wdkLocationLab.centerX = _dkBgView.centerX;
    _wdkLocationLab.textColor = [UIColor blackColor];
    _wdkLocationLab.textAlignment = NSTextAlignmentLeft;
    _wdkLocationLab.text = @"天园培训基地";
    _wdkLocationLab.font = [UIFont systemFontOfSize:14];
    [wdkView addSubview:_wdkLocationLab];

    
    _wdkLocationView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_wdkLocationLab.frame)-20*wScale, CGRectGetMaxY(_dkBgView.frame)+8.5*wScale, 15, 15)];
    _wdkLocationView.centerY = _wdkLocationLab.centerY;
    _wdkLocationView.image = [UIImage imageNamed:@"kqlocation"];
    [wdkView addSubview:_wdkLocationView];
    
    
    _timeNow = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerFunc) userInfo:nil repeats:YES];

    ydkView = [[UIView alloc] init];
    [self.contentView addSubview:ydkView];
    ydkView.backgroundColor = [UIColor clearColor];
    ydkView.hidden = YES;
    
    ydkView.sd_layout
    .leftSpaceToView(_verticalLabel2, 10)
    .topSpaceToView(_titleLabel, 10)
    .widthIs(self.contentView.frame.size.width-CGRectGetMaxX(_verticalLabel2.frame)-10)
    .heightIs(80);
    
    NSString *str = @"08:20已打卡";
    CGSize size1 = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
    _dkTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, size1.width, size1.height)];
    _dkTimeLab.font = [UIFont systemFontOfSize:17];
    _dkTimeLab.textAlignment = NSTextAlignmentLeft;
    _dkTimeLab.textColor = [UIColor blackColor];
    _dkTimeLab.text = str;
    [ydkView addSubview:_dkTimeLab];
    
    
    _locationView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_dkTimeLab.frame)+20*wScale, 0, 15, 15)];
    _locationView.centerY = _dkTimeLab.centerY;
    _locationView.image = [UIImage imageNamed:@"kqlocation"];
    [ydkView addSubview:_locationView];
    
    _locationLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_locationView.frame)+2.5*wScale, 0, KScreenWidth-CGRectGetMaxX(_locationView.frame)-2.5*wScale-10*wScale-115, 14)];
    _locationLab.centerY = _locationView.centerY;
    _locationLab.text = @"天园培训基地";
    _locationLab.textAlignment = NSTextAlignmentLeft;
    _locationLab.font = [UIFont systemFontOfSize:14];
    [ydkView addSubview:_locationLab];
    
    _statusView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_locationLab.frame)+20, 0, 32, 17)];
    _statusView.image = [UIImage imageNamed:@"normal"];
    _statusView.contentMode = UIViewContentModeScaleAspectFit;
    _statusView.centerY = _locationLab.centerY;
    [ydkView addSubview:_statusView];
    
    _cxdkBtn = [[UIButton alloc] initWithFrame:CGRectMake(_dkTimeLab.origin.x, CGRectGetMaxY(_dkTimeLab.frame)+20*wScale, 60, 13)];
    [_cxdkBtn addTarget:self action:@selector(cxdkBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_cxdkBtn setTitle:@"重新打卡" forState:UIControlStateNormal];
    [_cxdkBtn setTitleColor:[UIColor colorWithHexString:@"#FF4359"] forState:UIControlStateNormal];
    [_cxdkBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [ydkView addSubview:_cxdkBtn];
    
    _cxdkView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_cxdkBtn.frame)+1.5*wScale, 0, 15, 15)];
    _cxdkView.image = [UIImage imageNamed:@"redk"];
    _cxdkView.centerY = _cxdkBtn.centerY;
    [ydkView addSubview:_cxdkView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cxdkBtnAction)];
    _cxdkView.userInteractionEnabled = YES;
    [_cxdkView addGestureRecognizer:tap];
}

- (void)timerFunc
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString *timestamp = [formatter stringFromDate:[NSDate date]];
    [_timeLab setText:timestamp];//时间在变化的语句
}

//赋值
-(void)setModel:(KqModel *)model
{
    _model = model;
    
    self.titleLabel.text = model.titleStr;
    
    if ([model.style isEqualToString:@"0"]) {
        [_circleView setBackgroundImage:[UIImage imageNamed:@"dots_gray"] forState:UIControlStateNormal];
        wdkView.hidden = NO;
        ydkView.hidden = YES;
        _verticalLabel2.backgroundColor = [UIColor colorWithHexString:@"#C9C9C9"];
    }else if([model.style isEqualToString:@"1"]){
        [_circleView setBackgroundImage:[UIImage imageNamed:@"dots_blue"] forState:UIControlStateNormal];
        wdkView.hidden = YES;
        ydkView.hidden = NO;
        _verticalLabel2.backgroundColor = [UIColor colorWithHexString:@"#1B82D1"];
    }else{
        [_circleView setBackgroundImage:[UIImage imageNamed:@"dots_gray"] forState:UIControlStateNormal];
        wdkView.hidden = YES;
        ydkView.hidden = YES;
        _verticalLabel2.backgroundColor = [UIColor colorWithHexString:@"#C9C9C9"];
    }
}

-(void)setDkModel:(DkModel *)dkModel
{
    _dkModel = dkModel;
    
    if (dkModel == nil) {
        wdkView.hidden = NO;
        ydkView.hidden = YES;
    }
    
    NSString *timeStr = [dkModel.signTime substringWithRange:NSMakeRange(10, 6)];
    
    _dkTimeLab.text = [NSString stringWithFormat:@"%@已打卡",timeStr];
    CGSize size1 = [_dkTimeLab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
    _dkTimeLab.size = size1;
    
    _locationLab.text = [NSString stringWithFormat:@"%@",dkModel.signAddr];
    
    if ([dkModel.signStatus isEqualToString:@"1"]) {
        _statusView.image = [UIImage imageNamed:@"normal"];
    }else if ([dkModel.signStatus isEqualToString:@"2"]){
        _statusView.image = [UIImage imageNamed:@"later"];
    }else{
        _statusView.image = [UIImage imageNamed:@"later"];
    }
    
}

#pragma mark 打卡
-(void)dkSuccessMsg:(id)object
{
    if (self.dkDelegate !=nil&&[self.dkDelegate respondsToSelector:@selector(dkSuccessAndRefresh:)]) {
        [self.dkDelegate dkSuccessAndRefresh:object];
    }
}

-(void)dkTapAction
{
    
}

#pragma mark 重新打卡
-(void)cxdkBtnAction
{
    
}
@end
