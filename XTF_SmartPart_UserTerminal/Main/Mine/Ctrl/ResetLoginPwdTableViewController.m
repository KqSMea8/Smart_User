//
//  ResetLoginPwdTableViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2018/3/29.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "ResetLoginPwdTableViewController.h"
#import "Utils.h"
#import "PwdSetTableViewController.h"

@interface ResetLoginPwdTableViewController ()
{
    __weak IBOutlet UITextField *newLoginPwdTex;
    __weak IBOutlet UITextField *sureNewPwdTex;
}

@end

@implementation ResetLoginPwdTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initNavItems];
    
    [self _initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)_initNavItems
{
    self.title = @"重置登录密码";
    
    UIButton *leftBtn = [[UIButton alloc] init];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [leftBtn setImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(_leftBarBtnItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *rightBtn = [[UIButton alloc] init];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [rightBtn addTarget:self action:@selector(_rightBarBtnItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

- (void)_leftBarBtnItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)_rightBarBtnItemClick
{
    [self tapAction];
    
    [self completeresetPwd];
}

-(void)_initView
{
    
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    self.tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.tableView addGestureRecognizer:tap];
}

-(void)tapAction
{
    [self.tableView endEditing:YES];
}

#pragma mark 重置密码
-(void)completeresetPwd
{
    if (newLoginPwdTex.text ==nil || newLoginPwdTex.text.length == 0) {
        [self showHint:@"请输入登录密码!"];
        return;
    }
    
    if (![Utils judgePassWordLegal:newLoginPwdTex.text]) {
        UIAlertView *remainInstall = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的新密码必须包括字母和数字，密码长度至少8位" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [remainInstall show];
        return;
    }
    
    if (sureNewPwdTex.text == nil || sureNewPwdTex.text.length == 0) {
        [self showHint:@"请确认登录密码!"];
        return;
    }
    
    if (![newLoginPwdTex.text isEqualToString:sureNewPwdTex.text]) {
        [self showHint:@"两次密码不一致!"];
        return;
    }
    [self showHudInView:self.view hint:@""];
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/setCustPwd",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:[kUserDefaults objectForKey:KUserPhoneNum] forKey:@"custMobile"];
    [params setObject:[newLoginPwdTex.text md5String] forKey:@"newPwd"];
    
    [[NetworkClient sharedInstance] GET:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        [self showHint:responseObject[@"message"]];
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            [kUserDefaults setObject:@"" forKey:KPwdAlertTime];
            if ([kUserDefaults boolForKey:isRememberPwd]) {
                [kUserDefaults setObject:newLoginPwdTex.text forKey:kUserPwd];
            }
            
            [kUserDefaults setObject:newLoginPwdTex.text forKey:KLoginPasword];
            [kUserDefaults synchronize];
            [self performSelector:@selector(popView) withObject:self afterDelay:0.5];
        }
        
    } failure:^(NSError *error) {
        [self hideHud];
        YYReachability *rech = [YYReachability reachability];
        if (!rech.reachable) {
            [self showHint:@"网络不给力,请重试!"];
        }else{
            [self showHint:@"重置密码失败,请重试!"];
        }
    }];
}

-(void)popView{
    if ([_isFromVc isEqualToString:@"1"]) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[PwdSetTableViewController class]]) {
                PwdSetTableViewController *vc = (PwdSetTableViewController *)controller;
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    }else{
        [kNotificationCenter postNotificationName:@"dissmissRemainCtrl" object:nil];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


@end
