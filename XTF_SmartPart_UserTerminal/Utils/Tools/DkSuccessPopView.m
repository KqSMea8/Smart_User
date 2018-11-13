//
//  DkSuccessPopView.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2018/1/15.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "DkSuccessPopView.h"

@interface DkSuccessPopView()
{
    UIView *_contentView;
}

@property (nonatomic,copy) NSString *timeTitle;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,assign) PopViewType type;
@property (nonatomic,retain) UIScrollView *contentScrView;

@property (nonatomic,strong) UIImageView *titleView;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UIImageView *timeBgView;
@property (nonatomic,strong) UILabel *statusLab;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UILabel *messageLab;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIButton *knowBtn;

@end

@implementation DkSuccessPopView

- (instancetype)initWithtimeTitle:(NSString *)timeTitle type:(PopViewType)type signContent:(NSString *)content
{
    if(self = [super init]) {
        self.timeTitle = timeTitle;
        self.type = type;
        self.content = content;
        
        [self initView];
    }
    return self;
}

-(void)initView{
    self.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    
    //alpha 0.0  白色   alpha 1 ：黑色   alpha 0～1 ：遮罩颜色，逐渐
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)]];
    
    if (_contentView == nil)
    {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake((KScreenWidth-250*wScale)/2, (KScreenHeight - 325*wScale)/2, 250*wScale, 325*wScale)];
        _contentView.backgroundColor = [UIColor colorWithHexString:@"#1B82D1"];
        [self addSubview:_contentView];
        
        _titleView = [[UIImageView alloc] initWithFrame:CGRectMake(45*wScale, 37.5*wScale, 45*wScale, 60*wScale)];
        _titleView.image = [UIImage imageNamed:@"dksign"];
        [_contentView addSubview:_titleView];
        
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_titleView.frame)+15*wScale, 0, 110, 24)];
        _titleLab.font = [UIFont boldSystemFontOfSize:25];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.text = @"打卡成功";
        _titleLab.centerY = _titleView.centerY;
        [_contentView addSubview:_titleLab];
        
        _timeBgView = [[UIImageView alloc] initWithFrame:CGRectMake(35*wScale, _titleView.bottom + 38*wScale, _contentView.width-70*wScale, 56*wScale)];
        _timeBgView.image = [UIImage imageNamed:@"dktimebg"];
        [_contentView addSubview:_timeBgView];
        
        _statusLab = [[UILabel alloc] initWithFrame:CGRectMake(25*wScale, 0, 15, 45)];
        NSString *workStatus;
        if (self.type == onWorkPopView) {
            workStatus = @"上班";
        }else{
            workStatus = @"下班";
        }
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:workStatus];
        [str setLineSpacing:5];
        _statusLab.attributedText = str;
        _statusLab.centerY = _timeBgView.height/2;
        _statusLab.numberOfLines = 0;
        _statusLab.textAlignment = NSTextAlignmentCenter;
        _statusLab.font = [UIFont systemFontOfSize:15];
        [_timeBgView addSubview:_statusLab];
        
        _timeLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_statusLab.frame)+30*wScale, 0, 90, 25)];
        _timeLab.font = [UIFont boldSystemFontOfSize:30];
        _timeLab.textAlignment = NSTextAlignmentLeft;
        _timeLab.text = _timeTitle;
        _timeLab.centerY = _statusLab.centerY;
        [_timeBgView addSubview:_timeLab];
        
        _messageLab = [[UILabel alloc] initWithFrame:CGRectMake(10, _timeBgView.bottom+30*wScale, _contentView.width-20, 17)];
        _messageLab.textAlignment = NSTextAlignmentCenter;
        _messageLab.textColor = [UIColor whiteColor];
        NSString *message;
        if (self.type == onWorkPopView) {
            if ([self.content isKindOfClass:[NSNull class]]||self.content == nil) {
                message = @"成功，从快乐工作开始";
            }else{
                message = self.content;
            }
        }else{
            if ([self.content isKindOfClass:[NSNull class]]||self.content == nil) {
                message = @"辛苦一天了，好好休息";
            }else{
                message = self.content;
            }
        }
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:message];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [paragraphStyle setLineSpacing:10];//调整行间距
        [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [message length])];
        //设置尺寸
        [attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"KaiTi_GB2312" size:14] range:NSMakeRange(0, message.length)];
        _messageLab.attributedText = attrString;
        _messageLab.numberOfLines = 0;
        _messageLab.centerX = _contentView.width/2;
        [_contentView addSubview:_messageLab];
        
        CGSize size = [_messageLab.attributedText boundingRectWithSize:CGSizeMake(_contentView.width-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        _messageLab.frame = CGRectMake(10, _timeBgView.bottom+30*wScale, _contentView.width-20, size.height);
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _messageLab.bottom + 18, _contentView.width, 0.5)];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [_contentView addSubview:_lineView];
        
        _knowBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, _lineView.bottom, _contentView.width, 49*wScale)];
        _knowBtn.backgroundColor = [UIColor colorWithHexString:@"#1B82D1"];
        [_knowBtn setTitle:@"我知道了" forState:UIControlStateNormal];
        [_knowBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [_knowBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_knowBtn];
        
    }
}

//展示从底部向上弹出的UIView（包含遮罩）
- (void)showInView:(UIView *)view
{
    if (!view)
    {
        return;
    }
    
    [view addSubview:self];
    [view addSubview:_contentView];
    
//    [_contentView setFrame:CGRectMake((KScreenWidth-250*wScale)/2, (KScreenHeight - 325*wScale)/2, 250*wScale, 325*wScale)];
    _contentView.frame = CGRectMake((KScreenWidth-250*wScale)/2, (KScreenHeight - _messageLab.bottom+18+49.5)/2, 250*wScale, _messageLab.bottom+18+49.5);
    _contentView.center = self.center;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.alpha = 1.0;
        
//        [_contentView setFrame:CGRectMake((KScreenWidth-250*wScale)/2, (KScreenHeight - 325*wScale)/2, 250*wScale, 325*wScale)];
        _contentView.frame = CGRectMake((KScreenWidth-250*wScale)/2, (KScreenHeight - _messageLab.bottom+18+49.5)/2, 250*wScale, _messageLab.bottom+18+49.5);
        _contentView.center = self.center;
        
    } completion:nil];
}

-(void)closeBtnAction
{
    [self disMissView];
}

//移除从上向底部弹下去的UIView（包含遮罩）
- (void)disMissView
{
//    [_contentView setFrame:CGRectMake((KScreenWidth-250*wScale)/2, (KScreenHeight - 325*wScale)/2, 250*wScale, 325*wScale)];
    _contentView.frame = CGRectMake((KScreenWidth-250*wScale)/2, (KScreenHeight - _messageLab.bottom+18+49.5)/2, 250*wScale, _messageLab.bottom+18+49.5);
    _contentView.center = self.center;
    [UIView animateWithDuration:0.2f
                     animations:^{
                         
                         self.alpha = 0.0;
                         
//                         [_contentView setFrame:CGRectMake((KScreenWidth-250*wScale)/2, (KScreenHeight - 325*wScale)/2, 250*wScale, 325*wScale)];
                         _contentView.frame = CGRectMake((KScreenWidth-250*wScale)/2, (KScreenHeight - _messageLab.bottom+18+49.5)/2, 250*wScale, _messageLab.bottom+18+49.5);
                         _contentView.center = self.center;
                     }
                     completion:^(BOOL finished){
                         
                         [self removeFromSuperview];
                         [_contentView removeFromSuperview];
                         
                     }];
    
}


@end
