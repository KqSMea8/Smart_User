//
//  ChangePayPwdTableViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/14.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "ChangePayPwdTableViewController.h"
#import "SetTableViewController.h"
#import "FPayPwdTableViewController.h"

@interface ChangePayPwdTableViewController ()
{
    __weak IBOutlet UILabel *oldPwdLab;
    __weak IBOutlet UILabel *newPwdLab;
    __weak IBOutlet UILabel *sureNewPwdLab;
    
    __weak IBOutlet UITextField *oldPwdTex;
    __weak IBOutlet UITextField *newPwdTex;
    __weak IBOutlet UITextField *sureNewPwdTex;
    
    __weak IBOutlet UIButton *forgetOldPwdBtn;
    
}

@end

@implementation ChangePayPwdTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initNavItems];
    
    [self _initView];
}

-(void)_initNavItems
{
    if ([kUserDefaults boolForKey:isSetPayPwd]) {
        self.title = @"修改支付密码";
        newPwdLab.text = @"新密码";
        sureNewPwdLab.text = @"确认新密码";
        
    }else{
        self.title = @"设置支付密码";
        newPwdLab.text = @"密码";
        sureNewPwdLab.text = @"确认密码";
        forgetOldPwdBtn.hidden = YES;
    }
    
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
    
    [newPwdTex addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [oldPwdTex addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [sureNewPwdTex addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == newPwdTex||textField == oldPwdTex||textField == sureNewPwdTex) {
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
        }
    }
}

- (void)_leftBarBtnItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)_rightBarBtnItemClick
{
    [self.tableView endEditing:YES];
    
    if ([kUserDefaults boolForKey:isSetPayPwd]) {
        [self changePayPwdAction];
    }else{
        [self setPayPwdAction];
    }
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    if (![kUserDefaults boolForKey:isSetPayPwd]) {
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

-(void)changePayPwdAction
{
    if (oldPwdTex.text == nil || oldPwdTex.text.length == 0) {
        [self showHint:@"请输入旧密码!"];
        return;
    }
    
    if (newPwdTex.text == nil || newPwdTex.text.length == 0) {
        [self showHint:@"请输入新密码!"];
        return;
    }
    
    if (newPwdTex.text.length <6) {
        [self showHint:@"密码必须为六位数字!"];
        return;
    }
    
    if (![newPwdTex.text isEqualToString:sureNewPwdTex.text]) {
        [self showHint:@"两次输入的新密码不一致!"];
        return;
    }
    if ([newPwdTex.text isEqualToString:oldPwdTex.text]) {
        [self showHint:@"新密码与旧密码一致!"];
        return;
    }
    [self showHudInView:self.view hint:@""];
    
    NSString *custId = [kUserDefaults objectForKey:kCustId];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/upPayPassword",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:custId forKey:@"custId"];
    [params setObject:[oldPwdTex.text md5String] forKey:@"oldPayPwd"];
    [params setObject:[newPwdTex.text md5String] forKey:@"newPayPwd"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
    
        [self hideHud];
        [self showHint:responseObject[@"message"]];
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        [self hideHud];
        YYReachability *rech = [YYReachability reachability];
        if (!rech.reachable) {
            [self showHint:@"网络不给力,请重试!"];
        }else{
            [self showHint:@"修改失败,请重试!"];
        }
        
    }];
}

-(void)setPayPwdAction
{
    if (newPwdTex.text == nil || newPwdTex.text.length == 0) {
        [self showHint:@"请输入密码!"];
        return;
    }
    
    if (newPwdTex.text.length <6) {
        [self showHint:@"密码必须为六位数字!"];
        return;
    }
    
    if (sureNewPwdTex.text == nil || sureNewPwdTex.text.length == 0) {
        [self showHint:@"请确认密码!"];
        return;
    }
    if (![newPwdTex.text isEqualToString:sureNewPwdTex.text]) {
        [self showHint:@"两次输入的密码不一致!"];
        return;
    }
    [self showHudInView:self.view hint:@""];
    
    NSString *custId = [kUserDefaults objectForKey:kCustId];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/payPassword",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:custId forKey:@"custId"];
    [params setObject:[newPwdTex.text md5String] forKey:@"payPassword"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            [self showHint:responseObject[@"message"]];
            [self.navigationController popViewControllerAnimated:YES];
            [kUserDefaults setBool:YES forKey:isSetPayPwd];
        }
    } failure:^(NSError *error) {
        [self hideHud];
        YYReachability *rech = [YYReachability reachability];
        if (!rech.reachable) {
            [self showHint:@"网络不给力,请重试!"];
        }else{
            [self showHint:@"设置支付密码失败,请重试!"];
        }
        
    }];
    
}

#pragma mark 忘记旧密码

- (IBAction)forgetOldPwdBtnAction:(id)sender {
    FPayPwdTableViewController *fPayPwdVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"FPayPwdTableViewController"];
    [self.navigationController pushViewController:fPayPwdVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
