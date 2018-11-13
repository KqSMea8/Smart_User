//
//  ShowMenuView.m
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/5/29.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "ShowMenuView.h"

@interface ShowMenuView()
{
    UILabel *_titleLabel;
    UISwitch *_commonUseDoorSwitch;
    int _index;
    UIImageView *_inBackGroundView;
    UIView *_titleView;
    UIButton *_closeBt;
    UIView *_lineView;
    UIButton *_inUnLockBtn;
    UILabel *_inStatusLab;
    UILabel *_commonlyUsedDoorLab;
    UIImageView *_outBackGroundView;
    UIButton *_outUnLockBtn;
    UILabel *_outStatusLab;
}

@end

@implementation ShowMenuView

- (instancetype)initWithIndex:(int)index
{
    if (self == [super init])
    {
        _index = index;
    }
    return self;
}

- (void)setDelegate:(id<menuDelegate>)delegate {
    _delegate = delegate;
    
    if(_delegate == nil){
        return;
    }
    
    [self initContent];  // 刷新时创建
}

- (void)initContent
{
    if (_isPortrait) {
        self.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-kTopHeight);
    }else{
        self.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-32);
    }
    
    //alpha 0.0  白色   alpha 1 ：黑色   alpha 0～1 ：遮罩颜色，逐渐
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)]];
    
    if (_contentView == nil)
    {
        if ([_isGate isEqualToString:@"1"]) {
            _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 266-32, KScreenWidth, 266)];
        }else{
            _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 216-32, KScreenWidth, 216)];
        }
        
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        
        [self createTitleView];
        
        [self createContentView];
    }
}

-(void)createTitleView
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 50)];
    titleView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:titleView];
    _titleView = titleView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(50,15,KScreenWidth - 100,20);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(titleForMenu:)]) {
        titleLabel.text = [self.delegate titleForMenu:_index];
    }
    titleLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:20];
    titleLabel.textColor = [UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:1];
    [titleView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    UIButton *closeBt = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBt.frame = CGRectMake(KScreenWidth - 40, 10, 30, 30);
    [closeBt setBackgroundImage:[UIImage imageNamed:@"show_menu_close"] forState:UIControlStateNormal];
    [closeBt addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:closeBt];
    _closeBt = closeBt;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, titleView.height - 0.5, KScreenWidth, 0.5)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#BEBEBE"];
    [titleView addSubview:lineView];
    _lineView = lineView;
}

-(void)createContentView
{
    UILabel *inStatusLab = [[UILabel alloc] init];
    inStatusLab.frame = CGRectMake(10,87,160,20);
    inStatusLab.textAlignment = NSTextAlignmentLeft;
    if ([_isGate isEqualToString:@"1"]) {
        if ([_specialTag isEqualToString:@"1"]) {
            inStatusLab.text = @"自东向西进闸机门";
        }else{
            inStatusLab.text = @"进闸机门";
        }
    }else{
        inStatusLab.text = @"房间锁门中";
    }
    
    inStatusLab.font = [UIFont fontWithName:@"MicrosoftYaHei" size:20];
    inStatusLab.textColor = [UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:1];
    [_contentView addSubview:inStatusLab];
    _inStatusLab = inStatusLab;
    
    UIImageView *inBackGroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lock"]];
    inBackGroundView.userInteractionEnabled = YES;
    inBackGroundView.frame = CGRectMake(KScreenWidth - 60, 0, 40, 40);
    inBackGroundView.centerY = inStatusLab.center.y;
    [_contentView addSubview:inBackGroundView];
    _inBackGroundView = inBackGroundView;
    
    UIButton *inUnLockBtn = [[UIButton alloc] init];
    inUnLockBtn.tag = 100;
    inUnLockBtn.frame = CGRectMake(KScreenWidth - 60, 0, 40, 40);
    inUnLockBtn.centerY = inStatusLab.center.y;
    inUnLockBtn.backgroundColor = [UIColor clearColor];
    [inUnLockBtn addTarget:self action:@selector(unLockDoorAction:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:inUnLockBtn];
    _inUnLockBtn = inUnLockBtn;
    
    if ([_isGate isEqualToString:@"1"]) {
        UILabel *outStatusLab = [[UILabel alloc] init];
        outStatusLab.frame = CGRectMake(10,CGRectGetMaxY(inStatusLab.frame)+40,160,20);
        outStatusLab.textAlignment = NSTextAlignmentLeft;
        if ([_specialTag isEqualToString:@"1"]) {
            outStatusLab.text = @"自西向东出闸机门";
        }else{
            outStatusLab.text = @"出闸机门";
        }
        
        outStatusLab.font = [UIFont fontWithName:@"MicrosoftYaHei" size:20];
        outStatusLab.textColor = [UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:1];
        [_contentView addSubview:outStatusLab];
        _outStatusLab = outStatusLab;
        
        UIImageView *outBackGroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lock"]];
        outBackGroundView.userInteractionEnabled = YES;
        outBackGroundView.frame = CGRectMake(KScreenWidth - 60, 0, 40, 40);
        outBackGroundView.centerY = outStatusLab.center.y;
        [_contentView addSubview:outBackGroundView];
        _outBackGroundView = outBackGroundView;
        
        UIButton *outUnLockBtn = [[UIButton alloc] init];
        outUnLockBtn.tag = 200;
        outUnLockBtn.frame = CGRectMake(KScreenWidth - 60, 0, 40, 40);
        outUnLockBtn.centerY = outStatusLab.center.y;
        outUnLockBtn.backgroundColor = [UIColor clearColor];
        [outUnLockBtn addTarget:self action:@selector(unLockDoorAction:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:outUnLockBtn];
        _outUnLockBtn = outUnLockBtn;
    }
    
    UILabel *commonlyUsedDoorLab = [[UILabel alloc] init];
    if ([_isGate isEqualToString:@"1"]) {
        commonlyUsedDoorLab.frame = CGRectMake(10,CGRectGetMaxY(_outStatusLab.frame)+40,120,20);
    }else{
        commonlyUsedDoorLab.frame = CGRectMake(10,CGRectGetMaxY(_inStatusLab.frame)+40,120,20);
    }
    commonlyUsedDoorLab.textAlignment = NSTextAlignmentLeft;
    commonlyUsedDoorLab.text = @"加入常用门禁";
    commonlyUsedDoorLab.font = [UIFont fontWithName:@"MicrosoftYaHei" size:20];
    commonlyUsedDoorLab.textColor = [UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:1];
    [_contentView addSubview:commonlyUsedDoorLab];
    _commonlyUsedDoorLab = commonlyUsedDoorLab;
    
    UISwitch *commonUseDoorSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    commonUseDoorSwitch.centerY = commonlyUsedDoorLab.center.y;
    commonUseDoorSwitch.centerX = inUnLockBtn.center.x;
    [commonUseDoorSwitch addTarget:self action:@selector(addOrDeleteClick) forControlEvents:UIControlEventValueChanged];
    if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(isSwitch:)]) {
        commonUseDoorSwitch.on = [self.delegate isSwitch:_index];
    }
    [_contentView addSubview:commonUseDoorSwitch];
    _commonUseDoorSwitch = commonUseDoorSwitch;
}

#pragma mark 开门
-(void)unLockDoorAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(openDoorWithIndex:withView:withType:)]) {
        if (btn.tag == 100) {
            [self.delegate openDoorWithIndex:_index withView:_inBackGroundView withType:@"IN"];
        }else{
            [self.delegate openDoorWithIndex:_index withView:_outBackGroundView withType:@"OUT"];
        }
    }
}

#pragma mark 添加常用门禁
-(void)addOrDeleteClick
{
    if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(switchState:withSwitch:)]) {
        [self.delegate switchState:_index withSwitch:_commonUseDoorSwitch.isOn];
    }
}

-(void)closeAction{
    [self disMissView];
}

//展示从底部向上弹出的UIView（包含遮罩）
- (void)showInView:(UIView *)view
{
    if (!view)
    {
        return;
    }
    
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait) {
        self.frame = CGRectMake(0, 0, KScreenHeight, KScreenWidth - kTopHeight);
        if ([_isGate isEqualToString:@"1"]) {
            [_contentView setFrame:CGRectMake(0, self.height, KScreenWidth, 216)];
        }else{
            [_contentView setFrame:CGRectMake(0, self.height, KScreenWidth, 266)];
        }
        
    }else{
        self.frame = CGRectMake(0, 0, KScreenHeight, KScreenWidth - 32);
        if ([_isGate isEqualToString:@"1"]) {
            [_contentView setFrame:CGRectMake(0, self.height, KScreenWidth, 266)];
        }else{
            [_contentView setFrame:CGRectMake(0, self.height, KScreenWidth, 216)];
        }
    }
    
    [view addSubview:self];
    [view addSubview:_contentView];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 1.0;
        if ([_isGate isEqualToString:@"1"]) {
            [_contentView setFrame:CGRectMake(0, self.height - 266, KScreenWidth, 266)];
        }else{
            [_contentView setFrame:CGRectMake(0, self.height - 216, KScreenWidth, 216)];
        }
    } completion:nil];
}

//移除从上向底部弹下去的UIView（包含遮罩）
- (void)disMissView
{
    if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(closeMenu)]) {
        [self.delegate closeMenu];
    }
    if ([_isGate isEqualToString:@"1"]) {
        [_contentView setFrame:CGRectMake(0, self.height - 266, KScreenWidth, 266)];
    }else{
        [_contentView setFrame:CGRectMake(0, self.height - 216, KScreenWidth, 216)];
    }
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         self.alpha = 0.0;
                         if ([_isGate isEqualToString:@"1"]) {
                             [_contentView setFrame:CGRectMake(0, self.height, KScreenWidth, 266)];
                         }else{
                             [_contentView setFrame:CGRectMake(0, self.height, KScreenWidth, 216)];
                         }
                         
                     }
                     completion:^(BOOL finished){
                         
                         [self removeFromSuperview];
                         [_contentView removeFromSuperview];
                         
                     }];
}

-(void)reloadMenu
{
    [_contentView removeAllSubviews];
    [_contentView removeFromSuperview];
    _contentView = nil;
    [self initContent];
    
    UIView *view = [self viewController].view;
    
    if (!view)
    {
        return;
    }
    
    [view addSubview:self];
    [view addSubview:_contentView];
    
    if ([_isGate isEqualToString:@"1"]) {
        [_contentView setFrame:CGRectMake(0, KScreenHeight-kTopHeight, KScreenWidth, 266)];
    }else{
         [_contentView setFrame:CGRectMake(0, KScreenHeight-kTopHeight, KScreenWidth, 216)];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 1.0;
        if ([_isGate isEqualToString:@"1"]) {
            [_contentView setFrame:CGRectMake(0, KScreenHeight - 266-kTopHeight, KScreenWidth, 266)];
        }else{
            [_contentView setFrame:CGRectMake(0, KScreenHeight - 216-kTopHeight, KScreenWidth, 216)];
        }
    } completion:nil];

}

-(void)setIsPortrait:(BOOL)isPortrait
{
    _isPortrait = isPortrait;
}

-(void)setIsGate:(NSString *)isGate
{
    _isGate = isGate;
}

-(void)setSpecialTag:(NSString *)specialTag
{
    _specialTag = specialTag;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if ([_isGate isEqualToString:@"1"]) {
        _contentView.frame = CGRectMake(0, self.height - 266, KScreenWidth, 266);
    }else{
        _contentView.frame = CGRectMake(0, self.height - 216, KScreenWidth, 216);
    }
    _titleView.frame = CGRectMake(0, 0, _contentView.width, 50);
    _titleLabel.frame = CGRectMake(50, 15, _contentView.width-100, 20);
    _closeBt.frame = CGRectMake(_contentView.width-40, 10, 30, 30);
    _lineView.frame = CGRectMake(0, _titleView.height - 0.5, _contentView.width, 0.5);
    _inUnLockBtn.frame = CGRectMake(_contentView.width - 60, 0, 40, 40);
    _inUnLockBtn.centerY = _inStatusLab.center.y;
    _inBackGroundView.frame = CGRectMake(_contentView.width - 60, 0, 40, 40);
    _inBackGroundView.centerY = _inStatusLab.center.y;
    if ([_isGate isEqualToString:@"1"]) {
        _outUnLockBtn.frame = CGRectMake(KScreenWidth - 60, 0, 40, 40);
        _outUnLockBtn.centerY = _outStatusLab.center.y;
        _outBackGroundView.frame = CGRectMake(KScreenWidth - 60, 0, 40, 40);
        _outBackGroundView.centerY = _outStatusLab.center.y;
    }
    _commonUseDoorSwitch.frame = CGRectMake(0, 0, 40, 30);
    _commonUseDoorSwitch.centerY = _commonlyUsedDoorLab.center.y;
    _commonUseDoorSwitch.centerX = _inUnLockBtn.center.x;
}

@end
