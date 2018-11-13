//
//  ReSetPayPwdTableViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/15.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "ReSetPayPwdTableViewController.h"
#import "PwdSetTableViewController.h"
#import "PayMentTableViewController.h"
#import "SetTableViewController.h"

@interface ReSetPayPwdTableViewController ()
{
    __weak IBOutlet UITextField *newPwdTex;
    __weak IBOutlet UITextField *sureNewPwdTex;
}

@end

@implementation ReSetPayPwdTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initNavItems];
    
    [self _initView];
}

-(void)_initNavItems
{
    self.title = @"重置支付密码";
    
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
    [sureNewPwdTex addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == newPwdTex||textField == sureNewPwdTex) {
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
    [self tapAction];
    
    [self resetPayPwdAction];
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

#pragma mark 重置支付密码
-(void)resetPayPwdAction
{
    if (newPwdTex.text == nil || newPwdTex.text.length == 0) {
        [self showHint:@"请输入密码!"];
        return;
    }
    
    if (newPwdTex.text.length < 6) {
        [self showHint:@"支付密码必须为6位数字!"];
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
            if ([_signStr isEqualToString:@"1"]) {
//                PayMentTableViewController *parMentVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"PayMentTableViewController"];
                for (UIViewController *controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[PayMentTableViewController class]]) {
                        PayMentTableViewController*payVC = (PayMentTableViewController *)controller;
                        [self.navigationController popToViewController:payVC animated:YES];
                    }
                }
            }else if([_signStr isEqualToString:@"2"]){
                for (UIViewController *controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[SetTableViewController class]]) {
                        SetTableViewController *setVC = (SetTableViewController *)controller;
                        [self.navigationController popToViewController:setVC animated:YES];
                    }
                }
            }else{
                for (UIViewController *controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[PwdSetTableViewController class]]) {
                        PwdSetTableViewController *vc = (PwdSetTableViewController *)controller;
                        [self.navigationController popToViewController:vc animated:YES];
                    }
                }
            }
        }else{
            if (responseObject[@"message"] != nil) {
                [self showHint:responseObject[@"message"]];
            }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
