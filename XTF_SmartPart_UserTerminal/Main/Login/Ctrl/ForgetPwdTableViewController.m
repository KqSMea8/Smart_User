//
//  ForgetPwdTableViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/2.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "ForgetPwdTableViewController.h"
#import "FVerCodeTableViewController.h"
#import "Utils.h"

@interface ForgetPwdTableViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *phoneBgView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTex;
@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;

@end

@implementation ForgetPwdTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initView];
    
    [self _initNavItems];
}

-(void)_initView
{
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.bounces = NO;
    
    UITapGestureRecognizer *endDditTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditAction)];
    [self.tableView addGestureRecognizer:endDditTap];
    
    _nextStepBtn.layer.cornerRadius = 4;
    
    // 初始化textField
    _phoneTex.delegate = self;
    
    _phoneBgView.image = [_phoneBgView.image resizableImageWithCapInsets:UIEdgeInsetsMake(20, 40, 20, 40)];
    
    UIView *phoneLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 50)];
    UIImageView *phoneLeftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 16, 15, 15)];
    phoneLeftImgView.image = [UIImage imageNamed:@"phone"];
    [phoneLeftView addSubview:phoneLeftImgView];
    _phoneTex.leftView = phoneLeftView;
    _phoneTex.leftViewMode = UITextFieldViewModeAlways;
    _phoneTex.layer.borderColor = [UIColor colorWithHexString:@"#d5d3d5"].CGColor;
    _phoneTex.layer.borderWidth = 0.8;
    _phoneTex.layer.cornerRadius = 4;
    
}

-(void)_initNavItems
{
    self.title = @"忘记密码";
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UItextField协议
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == _phoneTex) {
        _phoneBgView.hidden = NO;
        _phoneTex.layer.borderColor = [UIColor clearColor].CGColor;
    }
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField == _phoneTex) {
        _phoneBgView.hidden = YES;
        _phoneTex.layer.borderColor = [UIColor colorWithHexString:@"#d5d3d5"].CGColor;
    }
    return YES;
}

-(void)endEditAction
{
    [self.tableView endEditing:YES];
}

- (IBAction)nextBtnAction:(id)sender {
    [self.view endEditing:YES];
    [self verPhoneIsRegister];
}

-(void)verPhoneIsRegister
{
    [self.tableView endEditing:YES];
    _nextStepBtn.enabled = NO;
    if(_phoneTex.text == nil || _phoneTex.text.length <= 0){
        [self showHint:@"请输入手机号码"];
        _nextStepBtn.enabled = YES;
        return;
    }
    
    if (![Utils valiMobile:_phoneTex.text]) {
        [self showHint:@"手机号格式有误!"];
        _nextStepBtn.enabled = YES;
        return;
    }
    
    [self showHudInView:self.view hint:@""];
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/isRegister",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:_phoneTex.text forKey:@"custMobile"];
    [[NetworkClient sharedInstance] GET:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            [self getVerCodeAction];
        }else {
            //        [self showHint:responseObject[@"message"]];
            _nextStepBtn.enabled = YES;
            [self showHint:@"该手机号未注册"];
        }
    } failure:^(NSError *error) {
        _nextStepBtn.enabled = YES;
        [self hideHud];
        [self showHint:@"网络错误,请重试!"];
    }];
}

-(void)getVerCodeAction
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/getSmsVerify",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:_phoneTex.text forKey:@"custMobile"];
    [params setObject:@"2" forKey:@"verifyType"];
    
    [self showHudInView:self.view hint:@""];
    
    [[NetworkClient sharedInstance] GET:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            FVerCodeTableViewController *fCodeVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"FVerCodeTableViewController"];
            fCodeVC.telephoneNum = _phoneTex.text;
            [self.navigationController pushViewController:fCodeVC animated:YES];
        }
        _nextStepBtn.enabled = YES;
    } failure:^(NSError *error) {
        _nextStepBtn.enabled = YES;
        [self hideHud];
        [self showHint:@"网络错误,请重试!"];
    }];
}
@end
