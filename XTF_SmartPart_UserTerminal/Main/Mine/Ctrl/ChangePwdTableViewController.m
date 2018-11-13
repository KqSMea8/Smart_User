//
//  ChangePwdTableViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/3.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "ChangePwdTableViewController.h"

#import "SetTableViewController.h"
#import "Utils.h"
#import "FLoginPwdTableViewController.h"

@interface ChangePwdTableViewController ()
{
    
    __weak IBOutlet UILabel *oldPwdLab;
    __weak IBOutlet UITextField *_oldPwd;
    
    __weak IBOutlet UILabel *newPwdLab;
    __weak IBOutlet UITextField *_newPwd;
    
    __weak IBOutlet UILabel *sureNewPwdLab;
    __weak IBOutlet UITextField *_sureNewPwd;
    
    __weak IBOutlet UILabel *signLab;
    
    __weak IBOutlet UIButton *forgetPwdBtn;
}

@end

@implementation ChangePwdTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [kNotificationCenter addObserver:self selector:@selector(dissmissRemainCtrl:) name:@"dissmissRemainCtrl" object:nil];
    
    [self _initNavItems];
    
    [self _initView];
}

-(void)dissmissRemainCtrl:(NSNotification *)notification
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)_initNavItems
{
    if ([kUserDefaults boolForKey:isSetPwd]) {
        self.title = @"修改登录密码";
        signLab.text = @"密码完成修改后，旧密码将失效无法再登录";
        newPwdLab.text = @"新密码";
        sureNewPwdLab.text = @"确认新密码";
    }else{
        self.title = @"设置登录密码";
        signLab.text = @"";
        newPwdLab.text = @"密码";
        sureNewPwdLab.text = @"确认密码";
        forgetPwdBtn.hidden = YES;
    }
    
    UIButton *leftBtn = [[UIButton alloc] init];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [leftBtn setImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(_leftBarBtnItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
//    if (!_isOverdue) {
//        self.navigationItem.leftBarButtonItem = leftItem;
//
//    }else{
//        UIAlertView *remainInstall = [[UIAlertView alloc]initWithTitle:@"提示" message:@"登录密码超1个月未修改，为保证安全性，请完成密码修改" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//
//        [remainInstall show];
//    }
    
    UIButton *rightBtn = [[UIButton alloc] init];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [rightBtn addTarget:self action:@selector(_rightBarBtnItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (IBAction)forgetPwd:(id)sender {
    FLoginPwdTableViewController *fCodeVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"FLoginPwdTableViewController"];
    if (_isOverdue) {
        fCodeVC.isFromVc = @"2";
    }else{
        fCodeVC.isFromVc = @"1";
    }
    
    [self.navigationController pushViewController:fCodeVC animated:YES];
}

- (void)_leftBarBtnItemClick
{
    if (_isOverdue) {
        [kNotificationCenter postNotificationName:@"ignorepwdexpired" object:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)_rightBarBtnItemClick
{
    [self.tableView endEditing:YES];
    
    if ([kUserDefaults boolForKey:isSetPwd]) {
        [self changePwdAction];
    }else{
        [self setLoginPwd];
    }
}

#pragma mark 修改密码
-(void)changePwdAction
{
    if (_oldPwd.text == nil || _oldPwd.text.length == 0) {
        [self showHint:@"请输入旧密码!"];
        return;
    }
    
    if (_newPwd.text == nil || _newPwd.text.length == 0) {
        [self showHint:@"请输入新密码!"];
        return;
    }
    
    if (![Utils judgePassWordLegal:_newPwd.text]) {
        UIAlertView *remainInstall = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的新密码必须包括字母和数字，密码长度至少8位" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [remainInstall show];
        return;
    }
    
    if (![_newPwd.text isEqualToString:_sureNewPwd.text]) {
        [self showHint:@"两次输入的新密码不一致!"];
        return;
    }
    if ([_newPwd.text isEqualToString:_oldPwd.text]) {
        [self showHint:@"新密码与旧密码一致!"];
        return;
    }
    
    NSString *custId = [kUserDefaults objectForKey:kCustId];
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/upCustPwd",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    
    [params setObject:custId forKey:@"custId"];
    [params setObject:[_oldPwd.text md5String] forKey:@"oldPwd"];
    [params setObject:[_newPwd.text md5String] forKey:@"newPwd"];
    
    [self showHudInView:self.view hint:@""];
    
    [[NetworkClient sharedInstance] GET:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            [kUserDefaults setObject:@"" forKey:KPwdAlertTime];
            [self showHint:@"修改密码成功!"];
            
            [kUserDefaults setObject:_newPwd.text forKey:KLoginPasword];
            [kUserDefaults setObject:_newPwd.text forKey:kUserPwd];
            
            [self performSelector:@selector(presentVC) withObject:nil afterDelay:0.5];
            
        }else{
            [self showHint:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        [self hideHud];
        YYReachability *rech = [YYReachability reachability];
        if (!rech.reachable) {
            [self showHint:@"网络不给力,请重试!"];
        }else{
            [self showHint:@"修改密码失败!"];
        }
    }];
}

-(void)presentVC
{
    if (_isOverdue) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark 设置登录密码
-(void)setLoginPwd
{
    if (_newPwd.text == nil || _newPwd.text.length == 0) {
        [self showHint:@"请输入密码!"];
        return;
    }
    
    if (![Utils judgePassWordLegal:_newPwd.text]) {
        UIAlertView *remainInstall = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的新密码必须包括字母和数字，密码长度至少8位" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [remainInstall show];
        return;
    }
    
    if (_sureNewPwd.text == nil || _sureNewPwd.text.length == 0) {
        [self showHint:@"请确认密码!"];
        return;
    }
    if (![_newPwd.text isEqualToString:_sureNewPwd.text]) {
        [self showHint:@"两次输入的密码不一致!"];
        return;
    }
    
    NSString *custId = [kUserDefaults objectForKey:kCustId];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/loginPassword",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:custId forKey:@"custId"];
    [params setObject:[_newPwd.text md5String] forKey:@"password"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            [self showHint:responseObject[@"message"]];
            
            [kUserDefaults setBool:YES forKey:isSetPwd];
            [kUserDefaults synchronize];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    } failure:^(NSError *error) {
        YYReachability *rech = [YYReachability reachability];
        if (!rech.reachable) {
            [self showHint:@"网络不给力,请重试!"];
        }else{
            [self showHint:@"设置密码失败,请重试!"];
        }
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    if (![kUserDefaults boolForKey:isSetPwd]) {
        if (indexPath.row == 0) {
            height = 0;
        }else{
            height = 60;
        }
    }else{
        height = 60;
    }
    return height;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [kNotificationCenter removeObserver:self name:@"dissmissRemainCtrl" object:nil];
}

@end
