//
//  MenuView.m
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/6/26.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "MenuView.h"

#define UI_navBar_Height 64.0;
@interface MenuView()
{
    UIView *_contentView;
    UILabel *_titleLabel;
    UIImageView *_inBackGroundView;
    UIImageView *_outBackGroundView;
    UIView *_titleView;
    UIButton *_closeBt;
    UIView *_lineView;
    UIButton *_inUnLockBtn;
    UILabel *_inStatusLab;
    UIButton *_outUnLockBtn;
    UILabel *_outStatusLab;

}
@end

@implementation MenuView

-(void)setSpecialTag:(NSString *)specialTag
{
    _specialTag = specialTag;
    if ([_specialTag isEqualToString:@"1"]) {
        _inStatusLab.text = @"自东向西进闸机门";
    }else{
        _inStatusLab.text = @"进闸机门";
    }
    
    if ([_specialTag isEqualToString:@"1"]) {
        _outStatusLab.text = @"自西向东出闸机门";
    }else{
        _outStatusLab.text = @"出闸机门";
    }
}

- (id)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setupContent];
    }
    return self;
}

- (void)setupContent {
    self.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-kTopHeight);
    
    //alpha 0.0  白色   alpha 1 ：黑色   alpha 0～1 ：遮罩颜色，逐渐
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)]];
    
    if (_contentView == nil) {
        
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - 216, KScreenWidth, 216)];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        // 右上角关闭按钮
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(_contentView.width - 20 - 15, 15, 20, 20);
        [closeBtn setImage:[UIImage imageNamed:@"guanbi"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(disMissView) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:closeBtn];
        
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
    
    UILabel *outStatusLab = [[UILabel alloc] init];
    outStatusLab.frame = CGRectMake(10,CGRectGetMaxY(inStatusLab.frame)+50,160,20);
    outStatusLab.textAlignment = NSTextAlignmentLeft;
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

//展示从底部向上弹出的UIView（包含遮罩）
- (void)showInView:(UIView *)view {
    if (!view) {
        return;
    }
    
    [view addSubview:self];
    [view addSubview:_contentView];
    
    [_contentView setFrame:CGRectMake(0, KScreenHeight, KScreenWidth, 216)];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.alpha = 1.0;
        
        [_contentView setFrame:CGRectMake(0, KScreenHeight - 216 - kTopHeight, KScreenWidth, 216)];
        
    } completion:nil];
}

//移除从上向底部弹下去的UIView（包含遮罩）
- (void)disMissView {
    [_contentView setFrame:CGRectMake(0, KScreenHeight - 216, KScreenWidth, 216)];
    [UIView animateWithDuration:0.2f animations:^{
         self.alpha = 0.0;
         [_contentView setFrame:CGRectMake(0, KScreenHeight, KScreenWidth, 216)];
     }completion:^(BOOL finished){
         [self removeFromSuperview];
         [_contentView removeFromSuperview];
         
     }];
}

-(void)setModel:(OpenDoorModel *)model
{
    _model = model;
    
    _titleLabel.text = _model.DEVICE_NAME;
}

-(void)setView:(UIImageView *)view
{
    _view = view;
}

-(void)closeAction{
    [self disMissView];
}

-(void)unLockDoorAction:(id)sender
{
    [self disMissView];
    UIButton *btn = (UIButton *)sender;
    if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(menuOpenDoorWithModel:withView:withType:)]) {
        if (btn.tag == 100) {
            [self.delegate menuOpenDoorWithModel:_model withView:_view withType:@"IN"];
        }else{
            [self.delegate menuOpenDoorWithModel:_model withView:_view withType:@"OUT"];
        }
    }
}

@end
