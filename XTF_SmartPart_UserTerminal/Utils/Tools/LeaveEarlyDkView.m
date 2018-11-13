//
//  LeaveEarlyDkView.m
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/7/3.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "LeaveEarlyDkView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface LeaveEarlyDkView()

@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UIView *topSepLineView;
@property (nonatomic,strong) UIView *horSepLineView;
@property (nonatomic,strong) UILabel *kqTimeLab;
@property (nonatomic,retain) UIImageView *topView;
@property (nonatomic,strong) UIButton *cancleBtn;
@property (nonatomic,strong) UIButton *dkBtn;
@property (nonatomic,strong) UIButton *closeBtn;
@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,copy) NSString *time;

@end

@implementation LeaveEarlyDkView

- (instancetype)initWithsignTime:(NSString *)time
{
    if (self = [super init]) {
        self.time = time;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
        
        [self configUI];
    }
    return self;
}

-(void)setSignType:(NSString *)signType
{
    _signType = signType;
}

-(void)configUI
{
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.45];
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 1;
    }];
    //------- 弹窗主内容 -------//
    self.contentView = [[UIView alloc]init];
    self.contentView.frame = CGRectMake(37.5, (SCREEN_HEIGHT - 300) / 2, KScreenWidth-75, 300);
    self.contentView.center = self.center;
    [self addSubview:self.contentView];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 4;
    
    //关闭按钮
    self.closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.contentView.bottom+26, 40, 40)];
    self.closeBtn.centerX = self.contentView.centerX;
    [self.closeBtn setBackgroundImage:[UIImage imageNamed:@"kqclose"] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.closeBtn];
    
    self.topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 31, 110, 110)];
    self.topView.centerX = self.contentView.width/2;
    [self.topView setImage:[UIImage imageNamed:@"leaveEarly"]];
    [self.contentView addSubview:self.topView];
    
    self.kqTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(10, self.topView.bottom+14, self.contentView.width-20, 16)];
    self.kqTimeLab.text = self.time;
    self.kqTimeLab.textAlignment = NSTextAlignmentCenter;
    self.kqTimeLab.font = [UIFont systemFontOfSize:20];
    self.kqTimeLab.textColor = [UIColor colorWithHexString:@"#FF4359"];
    [self.contentView addSubview:self.kqTimeLab];
    
    self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, self.kqTimeLab.bottom+18, self.contentView.width-20, 29)];
    self.titleLab.text = @"暂未下班，确定早退?";
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab.font = [UIFont boldSystemFontOfSize:25];
    self.titleLab.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.titleLab];
    
    self.topSepLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.titleLab.bottom + 22, self.contentView.width, 0.5)];
    self.topSepLineView.backgroundColor = [UIColor colorWithHexString:@"#E2E2E2"];
    [self.contentView addSubview:self.topSepLineView];
    
    self.horSepLineView = [[UIView alloc] initWithFrame:CGRectMake(self.contentView.width/2, self.topSepLineView.bottom, 0.5, self.contentView.height -  self.topSepLineView.bottom)];
    self.horSepLineView.backgroundColor = [UIColor colorWithHexString:@"#E2E2E2"];
    [self.contentView addSubview:self.horSepLineView];
    
    self.cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.topSepLineView.bottom, self.contentView.width/2, self.contentView.height -  self.topSepLineView.bottom)];
    [self.cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.cancleBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.cancleBtn];
    
    self.dkBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.contentView.width/2+0.5, self.topSepLineView.bottom, self.contentView.width/2-0.5, self.contentView.height -  self.topSepLineView.bottom)];
    [self.dkBtn setTitle:@"继续打卡" forState:UIControlStateNormal];
    [self.dkBtn setTitleColor:[UIColor colorWithHexString:@"#FF4359"] forState:UIControlStateNormal];
    [self.dkBtn addTarget:self action:@selector(dkBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.dkBtn];
    
}

-(void)tapAction
{
    [self endEditing:YES];
}

#pragma mark 关闭按钮点击
-(void)closeBtnAction:(id)sender
{
    [self dismiss];
}

#pragma mark - 弹出此弹窗
/** 弹出此弹窗 */
- (void)show{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
}

-(void)dkBtnAction:(id)sender
{
    [self dismiss];
    if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(leaveEarlyContinueDk:)]) {
        [self.delegate leaveEarlyContinueDk:_signType];
    }
}

#pragma mark - 移除此弹窗
/** 移除此弹窗 */
- (void)dismiss{
    [self removeFromSuperview];
}

@end
