//
//  PwdSetTableViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/14.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "PwdSetTableViewController.h"
#import "ChangePwdTableViewController.h"
#import "ChangePayPwdTableViewController.h"

@interface PwdSetTableViewController ()
{
    
    __weak IBOutlet UILabel *loginPwdLab;
    
    
    __weak IBOutlet UILabel *payPwdLab;
}

@end

@implementation PwdSetTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initNavItems];
    
    [self _initView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([kUserDefaults boolForKey:isSetPayPwd]) {
        payPwdLab.text = @"修改支付密码";
    }else{
        payPwdLab.text = @"设置支付密码";
    }
    
    if ([kUserDefaults boolForKey:isSetPwd]) {
        loginPwdLab.text = @"修改登录密码";
    }else{
        loginPwdLab.text = @"设置登录密码";
    }
}

-(void)_initNavItems
{
    self.title = @"密码设置";
    
    UIButton *leftBtn = [[UIButton alloc] init];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [leftBtn setImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(_leftBarBtnItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)_leftBarBtnItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)_initView
{
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    self.tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    
    if ([kUserDefaults boolForKey:isSetPayPwd]) {
        payPwdLab.text = @"修改支付密码";
    }else{
        payPwdLab.text = @"设置支付密码";
    }
    
    if ([kUserDefaults boolForKey:isSetPwd]) {
        loginPwdLab.text = @"修改登录密码";
    }else{
        loginPwdLab.text = @"设置登录密码";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        ChangePwdTableViewController *changePwdVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"ChangePwdTableViewController"];
        [self.navigationController pushViewController:changePwdVC animated:YES];
    }else{
        ChangePayPwdTableViewController *changePayPwdVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"ChangePayPwdTableViewController"];
        [self.navigationController pushViewController:changePayPwdVC animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    if (indexPath.row == 0) {
        if ([[kUserDefaults objectForKey:KLoginWay] isEqualToString:KAuthLogin]) {
            height = 0.01;
        }else{
            height = 60;
        }
    }else{
        if ([[kUserDefaults objectForKey:KLoginWay] isEqualToString:KLogin]) {
            height = 60;
        }else{
            height = 0.01;
        }
    }
    return height;
}

@end
