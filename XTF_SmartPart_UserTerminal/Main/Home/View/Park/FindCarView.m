//
//  FindCarView.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 魏唯隆 on 2017/12/14.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "FindCarView.h"

@implementation FindCarView
{
    UIView *_menuBgView;
    
    UIView *titleView;
    UILabel *titleLabel;
    
    UIImageView *_carImageView;
}

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    if(self){
        [self _initView];
    }
    return self;
}

- (void)_initView {
    self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
    self.hidden = YES;
    
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    
    UITapGestureRecognizer *hidTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAction)];
    [self addGestureRecognizer:hidTap];
    
    // 菜单背景视图
    _menuBgView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 440, KScreenWidth, 440)];
    _menuBgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_menuBgView];
    
    [self _createTitleVIew];
    
    _carImageView = [[UIImageView alloc] init];
    _carImageView.frame = CGRectMake((KScreenWidth - 220)/2, titleView.bottom + 20,220,150);
    _carImageView.image = [UIImage imageNamed:@"icon_no_picture"];
    [_menuBgView addSubview:_carImageView];
    
    NSArray *titles = @[@"车牌",@"联系人",@"联系电话",@"进场时间",@"已停时间"];
    for (int i=0; i<5; i++) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (_carImageView.bottom + 20) + i*40, 80, 17)];
        titleLabel.text = titles[i];
        titleLabel.font = [UIFont systemFontOfSize:17];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [_menuBgView addSubview:titleLabel];
        
        UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.right + 10, (_carImageView.bottom + 20) + i*40, KScreenWidth - 112, 17)];
        msgLabel.tag = 2000 + i;
        msgLabel.text = @"-";
        msgLabel.textColor = [UIColor blackColor];
        msgLabel.font = [UIFont systemFontOfSize:17];
        msgLabel.textAlignment = NSTextAlignmentRight;
        [_menuBgView addSubview:msgLabel];
    }
}

// 关闭视图
- (void)closeAction {
    self.hidden = YES;
}

- (void)_createTitleVIew {
    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 50)];
    titleView.backgroundColor = [UIColor whiteColor];
    [_menuBgView addSubview:titleView];
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(50,15,KScreenWidth - 100,20);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"-";
    titleLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:20];
    titleLabel.textColor = [UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:1];
    [titleView addSubview:titleLabel];
    
    UIButton *closeBt = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBt.frame =CGRectMake(KScreenWidth - 40, 10, 30, 30);
    [closeBt setBackgroundImage:[UIImage imageNamed:@"show_menu_close"] forState:UIControlStateNormal];
    [closeBt addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:closeBt];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, titleView.height - 0.5, KScreenWidth, 0.5)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#BEBEBE"];
    [titleView addSubview:lineView];
    
}

- (void)setDownParkMdel:(DownParkMdel *)downParkMdel {
    _downParkMdel = downParkMdel;
    
    titleLabel.text = [NSString stringWithFormat:@"%@车位", downParkMdel.seatNo];
    
    if(![downParkMdel.seatUrl isKindOfClass:[NSNull class]]&&downParkMdel.seatUrl != nil){
        [_carImageView sd_setImageWithURL:[NSURL URLWithString:downParkMdel.seatUrl] placeholderImage:[UIImage imageNamed:@"icon_no_picture"]];
    }
    
    UILabel *carnoLabel = [_menuBgView viewWithTag:2000];
    carnoLabel.text = downParkMdel.seatIdleCarno;
    
    UILabel *userLabel = [_menuBgView viewWithTag:2001];
    userLabel.text = @"-";
    
    UILabel *phoneLabel = [_menuBgView viewWithTag:2002];
    phoneLabel.text = @"-";
    
    UILabel *intimeLabel = [_menuBgView viewWithTag:2003];
    intimeLabel.text = [self dateFormatter:downParkMdel.seatOccutimeView];
    
    UILabel *timeLongLabel = [_menuBgView viewWithTag:2004];
    timeLongLabel.text = downParkMdel.seatOccutimeTime;
    
}

- (NSString *)dateFormatter:(NSString *)timeStr {
    NSDateFormatter *inFormat = [[NSDateFormatter alloc] init];
    [inFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *inDate = [inFormat dateFromString:timeStr];
    
    NSDateFormatter *outFormat = [[NSDateFormatter alloc] init];
    [outFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [outFormat setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString *outTimeStr = [outFormat stringFromDate:inDate];
    
    return outTimeStr;
}

- (void)showMenu {
    self.hidden = NO;
}
- (void)hidMenu {
    self.hidden = YES;
}

@end
