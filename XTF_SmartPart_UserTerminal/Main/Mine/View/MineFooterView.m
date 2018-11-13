//
//  MineFooterView.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2018/2/5.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "MineFooterView.h"

@interface MineFooterView()
{
    //考勤
    UIView *_kqBgView;
    UIImageView *_kqImagView;
    UILabel *_kqLab;
    //我的钱包
    UIView *_myWalletBgView;
    UIImageView *_myWalletImagView;
    UILabel *_myWalletLab;
    //我的车辆
    UIView *_myCarBgView;
    UIImageView *_myCarImagView;
    UILabel *_myCarLab;
    //停车记录
    UIView *_parkRecBgView;
    UIImageView *_parkRecImagView;
    UILabel *_ParkRecLab;
    //人像信息
    UIView *_humanFaceBgView;
    UIImageView *_humanFaceImagView;
    UILabel *_humanFaceLab;
    //预约记录
    UIView *_bookRecordBgView;
    UIImageView *_bookRecordImageView;
    UILabel *_bookRecordLab;
    //设置
    UIView *_setBgView;
    UIImageView *_setImagView;
    UILabel *_setLab;
}

@end

@implementation MineFooterView

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
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 5)];
    topView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    [self addSubview:topView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    _kqBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, KScreenWidth/4, 95)];
    _kqBgView.backgroundColor = [UIColor clearColor];
    [self addSubview:_kqBgView];
    
    _kqImagView = [[UIImageView alloc] init];
    _kqImagView.size = CGSizeMake(45, 45);
    _kqImagView.top = 15;
    _kqImagView.userInteractionEnabled = YES;
    _kqImagView.centerX = _kqBgView.width/2*1.1;
    _kqImagView.image = [UIImage imageNamed:@"home_sign"];
    [_kqBgView addSubview:_kqImagView];
    
    _kqLab = [[UILabel alloc] initWithFrame:CGRectMake(0, _kqImagView.bottom+8.5, _kqBgView.width-8, 17)];
    _kqLab.centerX = _kqImagView.centerX;
    _kqLab.font = [UIFont systemFontOfSize:15];
    _kqLab.textColor = [UIColor blackColor];
    _kqLab.textAlignment = NSTextAlignmentCenter;
    _kqLab.text = @"考勤统计";
    [_kqBgView addSubview:_kqLab];
    
    UITapGestureRecognizer *kqTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(kqTapAction:)];
    [_kqBgView addGestureRecognizer:kqTap];
    
    _myWalletBgView = [[UIView alloc] initWithFrame:CGRectMake(_kqBgView.right, 5, KScreenWidth/4, 95)];
    _myWalletBgView.backgroundColor = [UIColor clearColor];
    [self addSubview:_myWalletBgView];
    
    _myWalletImagView = [[UIImageView alloc] init];
    _myWalletImagView.size = CGSizeMake(45, 45);
    _myWalletImagView.top = 15;
    _myWalletImagView.userInteractionEnabled = YES;
    _myWalletImagView.centerX = _kqBgView.width/2;
    _myWalletImagView.image = [UIImage imageNamed:@"mine_purse"];
    [_myWalletBgView addSubview:_myWalletImagView];
    
    _myWalletLab = [[UILabel alloc] initWithFrame:CGRectMake(0, _kqImagView.bottom+8.5, _kqBgView.width-8, 17)];
    _myWalletLab.centerX = _myWalletImagView.centerX;
    _myWalletLab.font = [UIFont systemFontOfSize:15];
    _myWalletLab.textColor = [UIColor blackColor];
    _myWalletLab.textAlignment = NSTextAlignmentCenter;
    _myWalletLab.text = @"我的钱包";
    [_myWalletBgView addSubview:_myWalletLab];
    
    UITapGestureRecognizer *myWalletTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myWalletTapAction:)];
    [_myWalletBgView addGestureRecognizer:myWalletTap];
    
    _myCarBgView = [[UIView alloc] initWithFrame:CGRectMake(_myWalletBgView.right, 5, KScreenWidth/4, 95)];
    _myCarBgView.backgroundColor = [UIColor clearColor];
    [self addSubview:_myCarBgView];
    
    _myCarImagView = [[UIImageView alloc] init];
    _myCarImagView.size = CGSizeMake(45, 45);
    _myCarImagView.top = 15;
    _myCarImagView.userInteractionEnabled = YES;
    _myCarImagView.centerX = _kqBgView.width/2;
    _myCarImagView.image = [UIImage imageNamed:@"mine_car"];
    [_myCarBgView addSubview:_myCarImagView];
    
    _myCarLab = [[UILabel alloc] initWithFrame:CGRectMake(0, _kqImagView.bottom+8.5, _kqBgView.width-8, 17)];
    _myCarLab.centerX = _myCarImagView.centerX;
    _myCarLab.font = [UIFont systemFontOfSize:15];
    _myCarLab.textColor = [UIColor blackColor];
    _myCarLab.textAlignment = NSTextAlignmentCenter;
    _myCarLab.text = @"我的车辆";
    [_myCarBgView addSubview:_myCarLab];
    
    UITapGestureRecognizer *myCarTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myCarTapAction:)];
    [_myCarBgView addGestureRecognizer:myCarTap];
    
    _parkRecBgView = [[UIView alloc] initWithFrame:CGRectMake(_myCarBgView.right, 5, KScreenWidth/4, 95)];
    _parkRecBgView.backgroundColor = [UIColor clearColor];
    [self addSubview:_parkRecBgView];
    
    _parkRecImagView = [[UIImageView alloc] init];
    _parkRecImagView.size = CGSizeMake(45, 45);
    _parkRecImagView.top = 15;
    _parkRecImagView.userInteractionEnabled = YES;
    _parkRecImagView.centerX = _kqBgView.width/2*0.9;
    _parkRecImagView.image = [UIImage imageNamed:@"mine_park_all"];
    [_parkRecBgView addSubview:_parkRecImagView];
    
    _ParkRecLab = [[UILabel alloc] initWithFrame:CGRectMake(0, _kqImagView.bottom+8.5, _kqBgView.width-8, 17)];
    _ParkRecLab.centerX = _parkRecImagView.centerX;
    _ParkRecLab.font = [UIFont systemFontOfSize:15];
    _ParkRecLab.textColor = [UIColor blackColor];
    _ParkRecLab.textAlignment = NSTextAlignmentCenter;
    _ParkRecLab.text = @"停车记录";
    [_parkRecBgView addSubview:_ParkRecLab];
    
    UITapGestureRecognizer *parkRecTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(parkRecTapAction:)];
    [_parkRecBgView addGestureRecognizer:parkRecTap];
    
    _humanFaceBgView = [[UIView alloc] initWithFrame:CGRectMake(0, _kqBgView.bottom, KScreenWidth/4, 95)];
    _humanFaceBgView.backgroundColor = [UIColor clearColor];
    [self addSubview:_humanFaceBgView];
    
    _humanFaceImagView = [[UIImageView alloc] init];
    _humanFaceImagView.size = CGSizeMake(45, 45);
    _humanFaceImagView.top = 15;
    _humanFaceImagView.userInteractionEnabled = YES;
    _humanFaceImagView.centerX = _kqBgView.width/2*1.1;
    _humanFaceImagView.image = [UIImage imageNamed:@"humanface"];
    [_humanFaceBgView addSubview:_humanFaceImagView];
    
    _humanFaceLab = [[UILabel alloc] initWithFrame:CGRectMake(0, _kqImagView.bottom+8.5, _kqBgView.width-8, 17)];
    _humanFaceLab.centerX = _humanFaceImagView.centerX;
    _humanFaceLab.font = [UIFont systemFontOfSize:15];
    _humanFaceLab.textColor = [UIColor blackColor];
    _humanFaceLab.textAlignment = NSTextAlignmentCenter;
    _humanFaceLab.text = @"人像信息";
    [_humanFaceBgView addSubview:_humanFaceLab];
    
    UITapGestureRecognizer *humanfaceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(humanfaceTapAction:)];
    [_humanFaceBgView addGestureRecognizer:humanfaceTap];
    
    _bookRecordBgView = [[UIView alloc] initWithFrame:CGRectMake(_humanFaceBgView.right, _kqBgView.bottom, KScreenWidth/4, 95)];
    _bookRecordBgView.backgroundColor = [UIColor clearColor];
    [self addSubview:_bookRecordBgView];
    
    _bookRecordImageView = [[UIImageView alloc] init];
    _bookRecordImageView.size = CGSizeMake(45, 45);
    _bookRecordImageView.top = 15;
    _bookRecordImageView.userInteractionEnabled = YES;
    _bookRecordImageView.centerX = _kqBgView.width/2*1.1;
    _bookRecordImageView.image = [UIImage imageNamed:@"bookRecord"];
    [_bookRecordBgView addSubview:_bookRecordImageView];
    
    _bookRecordLab = [[UILabel alloc] initWithFrame:CGRectMake(0, _kqImagView.bottom+8.5, _kqBgView.width-8, 17)];
    _bookRecordLab.centerX = _humanFaceImagView.centerX;
    _bookRecordLab.font = [UIFont systemFontOfSize:15];
    _bookRecordLab.textColor = [UIColor blackColor];
    _bookRecordLab.textAlignment = NSTextAlignmentCenter;
    _bookRecordLab.text = @"预约记录";
    [_bookRecordBgView addSubview:_bookRecordLab];
    
    UITapGestureRecognizer *bookRecordTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bookRecordTapAction:)];
    [_bookRecordBgView addGestureRecognizer:bookRecordTap];
    
    _setBgView = [[UIView alloc] initWithFrame:CGRectMake(_bookRecordBgView.right, _kqBgView.bottom, KScreenWidth/4, 95)];
    _setBgView.backgroundColor = [UIColor clearColor];
    [self addSubview:_setBgView];
    
    _setImagView = [[UIImageView alloc] init];
    _setImagView.size = CGSizeMake(45, 45);
    _setImagView.top = 15;
    _setImagView.userInteractionEnabled = YES;
    _setImagView.centerX = _kqBgView.width/2*1.1;
    _setImagView.image = [UIImage imageNamed:@"mine_set"];
    [_setBgView addSubview:_setImagView];
    
    _setLab = [[UILabel alloc] initWithFrame:CGRectMake(0, _kqImagView.bottom+8.5, _kqBgView.width-8, 17)];
    _setLab.centerX = _setImagView.centerX;
    _setLab.font = [UIFont systemFontOfSize:15];
    _setLab.textColor = [UIColor blackColor];
    _setLab.textAlignment = NSTextAlignmentCenter;
    _setLab.text = @"设置";
    [_setBgView addSubview:_setLab];
    
    UITapGestureRecognizer *setTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setTapAction:)];
    [_setBgView addGestureRecognizer:setTap];
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KAuthLogin]) {
        _kqBgView.hidden = YES;
        _parkRecBgView.hidden = YES;
        _humanFaceBgView.hidden = YES;
        _bookRecordBgView.hidden = YES;
        _myWalletBgView.frame = CGRectMake(0, 5, KScreenWidth/4, 95);
        _myCarBgView.frame = CGRectMake(_myWalletBgView.right, 5, KScreenWidth/4, 95);
        _setBgView.frame = CGRectMake(_myCarBgView.right, 5, KScreenWidth/4, 95);
        _setImagView.centerX = _kqBgView.width/2;
        _setLab.centerX = _setImagView.centerX;
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KAuthLoginMobile]) {
        _kqBgView.hidden = YES;
        _humanFaceBgView.hidden = YES;
        _myWalletBgView.frame = CGRectMake(0, 5, KScreenWidth/4, 95);
        _myCarBgView.frame = CGRectMake(_myWalletBgView.right, 5, KScreenWidth/4, 95);
        _parkRecBgView.frame = CGRectMake(_myCarBgView.right, 5, KScreenWidth/4, 95);
        _bookRecordBgView.frame = CGRectMake(_parkRecBgView.right, 5, KScreenWidth/4, 95);
        _bookRecordImageView.centerX = _kqBgView.width/2*0.9;
        _bookRecordLab.centerX = _bookRecordImageView.centerX;
        _setBgView.frame = CGRectMake(0, _myWalletBgView.bottom, KScreenWidth/4, 95);
        _setImagView.centerX = _kqBgView.width/2;
        _setLab.centerX = _setImagView.centerX;
    }
}

-(void)kqTapAction:(UITapGestureRecognizer *)tap
{
    if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(mineFuctionTapAtIndex:)]) {
        [self.delegate mineFuctionTapAtIndex:1];
    }
}

-(void)myWalletTapAction:(UITapGestureRecognizer *)tap
{
    if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(mineFuctionTapAtIndex:)]) {
        [self.delegate mineFuctionTapAtIndex:2];
    }
}

-(void)myCarTapAction:(UITapGestureRecognizer *)tap
{
    if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(mineFuctionTapAtIndex:)]) {
        [self.delegate mineFuctionTapAtIndex:3];
    }
}

-(void)parkRecTapAction:(UITapGestureRecognizer *)tap
{
    if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(mineFuctionTapAtIndex:)]) {
        [self.delegate mineFuctionTapAtIndex:4];
    }
}

-(void)humanfaceTapAction:(UITapGestureRecognizer *)tap{
    if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(mineFuctionTapAtIndex:)]) {
        [self.delegate mineFuctionTapAtIndex:5];
    }
}

-(void)bookRecordTapAction:(UITapGestureRecognizer *)tap
{
    if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(mineFuctionTapAtIndex:)]) {
        [self.delegate mineFuctionTapAtIndex:6];
    }
}

-(void)setTapAction:(UITapGestureRecognizer *)tap
{
    if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(mineFuctionTapAtIndex:)]) {
        [self.delegate mineFuctionTapAtIndex:7];
    }
}


@end
