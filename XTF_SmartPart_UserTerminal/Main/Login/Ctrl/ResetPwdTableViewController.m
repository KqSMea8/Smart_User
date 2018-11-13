//
//  ResetPwdTableViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/2.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "ResetPwdTableViewController.h"
#import "Utils.h"

@interface ResetPwdTableViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *pwdBgView;
@property (weak, nonatomic) IBOutlet UITextField *pwdTex;
@property (weak, nonatomic) IBOutlet UIImageView *surePwdBgView;
@property (weak, nonatomic) IBOutlet UITextField *surePwdTex;
@property (weak, nonatomic) IBOutlet UIButton *completeResetBtn;

@end

@implementation ResetPwdTableViewController

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
    
    _completeResetBtn.layer.cornerRadius = 4;
    
    // 初始化textField
    _pwdTex.delegate = self;
    _surePwdTex.delegate = self;
    
    _pwdBgView.image = [_pwdBgView.image resizableImageWithCapInsets:UIEdgeInsetsMake(20, 40, 20, 40)];
    _surePwdBgView.image = [_surePwdBgView.image resizableImageWithCapInsets:UIEdgeInsetsMake(20, 40, 20, 40)];
    
    UIView *pwdLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 50)];
    UIImageView *pwdLeftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 16, 15, 15)];
    pwdLeftImgView.image = [UIImage imageNamed:@"loginpwd"];
    [pwdLeftView addSubview:pwdLeftImgView];
    _pwdTex.leftView = pwdLeftView;
    _pwdTex.leftViewMode = UITextFieldViewModeAlways;
    _pwdTex.layer.borderColor = [UIColor colorWithHexString:@"#d5d3d5"].CGColor;
    _pwdTex.layer.borderWidth = 0.8;
    _pwdTex.layer.cornerRadius = 4;
    
    UIView *surePwdLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 50)];
    UIImageView *surePwdLeftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 16, 15, 15)];
    surePwdLeftImgView.image = [UIImage imageNamed:@"surepwd"];
    [surePwdLeftView addSubview:surePwdLeftImgView];
    _surePwdTex.leftView = surePwdLeftView;
    _surePwdTex.leftViewMode = UITextFieldViewModeAlways;
    _surePwdTex.layer.borderColor = [UIColor colorWithHexString:@"#d5d3d5"].CGColor;
    _surePwdTex.layer.borderWidth = 0.8;
    _surePwdTex.layer.cornerRadius = 4;
}

-(void)_initNavItems
{
    self.title = @"重置密码";
    
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

#pragma mark UItextField协议
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if(textField == _pwdTex){
        _pwdBgView.hidden = NO;
        _pwdTex.layer.borderColor = [UIColor clearColor].CGColor;
        _surePwdBgView.hidden = YES;
    }else if (textField == _surePwdTex) {
        _surePwdBgView.hidden = NO;
        _surePwdTex.layer.borderColor = [UIColor clearColor].CGColor;
        _pwdBgView.hidden = YES;
    }
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if(textField == _pwdTex){
        _pwdBgView.hidden = YES;
        _pwdTex.layer.borderColor = [UIColor colorWithHexString:@"#d5d3d5"].CGColor;
    }else if (textField == _surePwdTex) {
        _surePwdBgView.hidden = YES;
        _surePwdTex.layer.borderColor = [UIColor colorWithHexString:@"#d5d3d5"].CGColor;
    }
    return YES;
}

-(void)endEditAction
{
    [self.tableView endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)completeResetBtnAction:(id)sender {
    [self.tableView endEditing:YES];
    
    [self completeresetPwd];
}

#pragma mark 重置密码
-(void)completeresetPwd
{
    if (_pwdTex.text ==nil || _pwdTex.text.length == 0) {
        [self showHint:@"请输入登录密码!"];
        return;
    }
    
    if (![Utils judgePassWordLegal:_pwdTex.text]) {
        UIAlertView *remainInstall = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的新密码必须包括字母和数字，密码长度至少8位" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [remainInstall show];
        return;
    }
    
    if (_surePwdTex.text == nil || _surePwdTex.text.length == 0) {
        [self showHint:@"请确认登录密码!"];
        return;
    }
    
    if (![_pwdTex.text isEqualToString:_surePwdTex.text]) {
        [self showHint:@"两次密码不一致!"];
        return;
    }
    [self showHudInView:self.view hint:@""];
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/setCustPwd",MainUrl];

    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:_telephoneNum forKey:@"custMobile"];
    [params setObject:[_pwdTex.text md5String] forKey:@"newPwd"];
    
    [[NetworkClient sharedInstance] GET:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        [self showHint:responseObject[@"message"]];
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
