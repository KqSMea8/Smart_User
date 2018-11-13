//
//  YDKView.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/3.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "YDKView.h"

@interface YDKView()


@end

@implementation YDKView

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
    NSString *str = @"08:20:55已打卡";
    CGSize size1 = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
    _dkTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size1.width, size1.height)];
    _dkTimeLab.font = [UIFont systemFontOfSize:17];
    _dkTimeLab.textAlignment = NSTextAlignmentLeft;
    _dkTimeLab.textColor = [UIColor colorWithHexString:@"#1B82D1"];
    _dkTimeLab.text = str;
    [self addSubview:_dkTimeLab];
    
    
    _locationView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_dkTimeLab.frame)+20*wScale, 0, 15, 15)];
    _locationView.centerY = _dkTimeLab.centerY;
    _locationView.image = [UIImage imageNamed:@"kqlocation"];
    [self addSubview:_locationView];
    
    _locationLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_locationView.frame)+2.5*wScale, 0, KScreenWidth-CGRectGetMaxX(_locationView.frame)-2.5*wScale-10*wScale-115, 14)];
    _locationLab.centerY = _locationView.centerY;
    _locationLab.text = @"天园培训基地";
    _locationLab.textAlignment = NSTextAlignmentLeft;
    _locationLab.font = [UIFont systemFontOfSize:14];
    [self addSubview:_locationLab];
    
    _statusView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_locationLab.frame)+20, 0, 32, 17)];
    _statusView.image = [UIImage imageNamed:@"normal"];
    _statusView.contentMode = UIViewContentModeScaleAspectFit;
    _statusView.centerY = _locationLab.centerY;
    [self addSubview:_statusView];
    
    _cxdkBtn = [[UIButton alloc] initWithFrame:CGRectMake(_dkTimeLab.origin.x, CGRectGetMaxY(_dkTimeLab.frame)+20*wScale, 60, 13)];
    [_cxdkBtn addTarget:self action:@selector(cxdkBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_cxdkBtn setTitle:@"重新打卡" forState:UIControlStateNormal];
    [_cxdkBtn setTitleColor:[UIColor colorWithHexString:@"#FF4359"] forState:UIControlStateNormal];
    [_cxdkBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:_cxdkBtn];
    
    _cxdkView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_cxdkBtn.frame)+1.5*wScale, 0, 15, 15)];
    _cxdkView.image = [UIImage imageNamed:@"redk"];
    _cxdkView.centerY = _cxdkBtn.centerY;
    [self addSubview:_cxdkView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cxdkBtnAction)];
    _cxdkView.userInteractionEnabled = YES;
    [_cxdkView addGestureRecognizer:tap];
    
}

-(void)cxdkBtnAction
{
    UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:@"是否重新打卡?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sureInfoAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //确认重新打卡
        [self confirmDKAction];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [actionSheetController addAction:cancelAction];
    [actionSheetController addAction:sureInfoAction];
    
    [[self viewController] presentViewController:actionSheetController animated:YES completion:nil];
    
}

#pragma mark 确认重新打卡
-(void)confirmDKAction
{
    if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(reConfirmDKAction:)]) {
        [self.delegate reConfirmDKAction:self];
    }
}

@end
