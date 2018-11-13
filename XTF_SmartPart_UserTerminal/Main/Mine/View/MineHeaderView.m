//
//  MineHeaderView.m
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/6/8.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "MineHeaderView.h"
#import "AESUtil.h"
#import "PersonMsgModel.h"

@interface MineHeaderView ()
{
    __weak IBOutlet UILabel *_nameLab;
    __weak IBOutlet UIImageView *_iconView;
    __weak IBOutlet UILabel *_signLab;
    __weak IBOutlet UILabel *_phoneLab;
    __weak IBOutlet UILabel *_moneyLab;
    PersonMsgModel *model;
    __weak IBOutlet NSLayoutConstraint *_nameLabTopCont;
    __weak IBOutlet NSLayoutConstraint *_signLabBottomCont;
    __weak IBOutlet UIButton *_rechageBtn;
    __weak IBOutlet UIView *headerBgView;
}

@end

@implementation MineHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _iconView.layer.cornerRadius = 35;
    _iconView.clipsToBounds = YES;
    
    _rechageBtn.layer.cornerRadius = 6;
    _rechageBtn.clipsToBounds = YES;
    
    headerBgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTapAction:)];
    [headerBgView addGestureRecognizer:tap];
}

-(void)setModel:(PersonMsgModel *)model
{
    _model = model;
    if (_model == nil){
        return;
    }
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KAuthLogin]){
        // 游客
        NSString *nickName = [kUserDefaults objectForKey:KAuthName];
        if (nickName != nil&&nickName.length >0) {
            _nameLab.text = [NSString stringWithFormat:@"%@(游客)",nickName];
        }else{
            _nameLab.text = [NSString stringWithFormat:@"游客"];
        }
        _phoneLab.hidden = YES;
        _signLab.text = @"绑定身份以获得更多权限";
        _moneyLab.text = @"未绑定身份";
        
        
    }else if([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KAuthLoginMobile]){
        // 访客
        _phoneLab.hidden = NO;
        if(![model.CUST_NAME isKindOfClass:[NSNull class]]&&model.CUST_NAME != nil){
            _nameLab.text = [NSString stringWithFormat:@"%@(访客)", model.CUST_NAME];
        }
        if(![model.CUST_MOBILE isKindOfClass:[NSNull class]]&&model.CUST_MOBILE != nil){
            _phoneLab.text = model.CUST_MOBILE;
        }
        _signLab.text = @"绑定员工工号可获得更多权限";

        _nameLabTopCont.constant = 35;
        _signLabBottomCont.constant = 35;
        _moneyLab.text = @"未绑定身份";
        
        
    }else if([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KLogin]){
        // 员工
        _phoneLab.hidden = NO;
        if(![model.CUST_NAME isKindOfClass:[NSNull class]]&&model.CUST_NAME != nil){
            _nameLab.text = model.CUST_NAME;
        }else{
            _nameLab.text = @"-";
        }
        if(![model.COMPANY_NAME isKindOfClass:[NSNull class]]&&model.COMPANY_NAME != nil){
            _phoneLab.text = model.COMPANY_NAME;
        }else{
            _phoneLab.text = @"请尽快完善公司信息";
        }
        if(![model.ORG_NAME isKindOfClass:[NSNull class]]&&model.ORG_NAME != nil){
            _signLab.text = model.ORG_NAME;
        }else{
            _signLab.text = @"请尽快完善部门信息";
        }

        _nameLabTopCont.constant = 35;
        _signLabBottomCont.constant = 35;

    }
    
    if(![model.CUST_HEADIMAGE isKindOfClass:[NSNull class]] && model.CUST_HEADIMAGE != nil){
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
        [_iconView sd_setImageWithURL:[NSURL URLWithString:model.CUST_HEADIMAGE] placeholderImage:[UIImage imageNamed:@"_member_icon"]];
    }
}

-(void)setMoney:(NSString *)money
{
    _money = money;
    if ([money isKindOfClass:[NSNull class]]||money == nil) {
        _moneyLab.text = [NSString stringWithFormat:@"%@",@"--元"];
    }else{
        _moneyLab.text = [NSString stringWithFormat:@"%@",money];
    }
    
}

#pragma mark 我的信息点击
-(void)headerTapAction:(UITapGestureRecognizer *)tap
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(headerTap)]) {
        [self.delegate headerTap];
    }
}

#pragma mark 快速充值
- (IBAction)quickRechageAction:(id)sender {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(quickRechageTap)]) {
        [self.delegate quickRechageTap];
    }
}

#pragma mark 分享
- (IBAction)shareAction:(id)sender {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(shareTap)]) {
        [self.delegate shareTap];
    }
}

@end
