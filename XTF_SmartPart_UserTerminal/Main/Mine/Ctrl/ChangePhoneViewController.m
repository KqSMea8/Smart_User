//
//  ChangePhoneViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2018/2/6.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "ChangePhoneViewController.h"
#import "Utils.h"

#define timeSendAgain 60

@interface ChangePhoneViewController ()
{
    __weak IBOutlet UILabel *currentPhoneLab;
    
    __weak IBOutlet UILabel *remindLab;
    __weak IBOutlet UITextField *phoneTex;
    __weak IBOutlet UITextField *verCodeTex;
    __weak IBOutlet UIButton *commitBtn;
    
    UIButton *_sendCodeBtn;
    
    NSInteger _timeSecond;
    
    __weak IBOutlet NSLayoutConstraint *currentPhoneTop;
}

@end

@implementation ChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initNavItems];
    
    [self _initView];
}

-(void)_initNavItems
{
    self.title = @"更换手机号";
    
    UIButton *leftBtn = [[UIButton alloc] init];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [leftBtn setImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(_leftBarBtnItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

-(void)_leftBarBtnItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)_initView
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KAuthLoginMobile]) {
        remindLab.hidden = YES;
        currentPhoneTop.constant = -3;
    }
    
    UITapGestureRecognizer *endDditTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditAction)];
    [self.tableView addGestureRecognizer:endDditTap];
    
    NSString *phone = [kUserDefaults objectForKey:KUserPhoneNum];
    NSString *numberString = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    currentPhoneLab.text = [NSString stringWithFormat:@"当前手机号%@",numberString];
    
    UIView *phoneLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 50)];
    UIImageView *phoneLeftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 18, 15, 15)];
    phoneLeftImgView.image = [UIImage imageNamed:@"phone"];
    [phoneLeftView addSubview:phoneLeftImgView];
    phoneTex.leftView = phoneLeftView;
    phoneTex.leftViewMode = UITextFieldViewModeAlways;
    phoneTex.layer.borderColor = [UIColor colorWithHexString:@"#d5d3d5"].CGColor;
    phoneTex.layer.borderWidth = 0.8;
    phoneTex.layer.cornerRadius = 4;
    
    UIView *phoneRightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 50)];
    _sendCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    [phoneRightView addSubview:_sendCodeBtn];
    [_sendCodeBtn addTarget:self action:@selector(getVerCodeAction) forControlEvents:UIControlEventTouchUpInside];
    [_sendCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_sendCodeBtn setTitleColor:[UIColor colorWithHexString:@"#FF4359"] forState:UIControlStateNormal];
    _sendCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    phoneTex.rightView = phoneRightView;
    phoneTex.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *codeLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 50)];
    UIImageView *codeLeftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 18, 15, 15)];
    codeLeftImgView.image = [UIImage imageNamed:@"verCode"];
    [codeLeftView addSubview:codeLeftImgView];
    verCodeTex.leftView = codeLeftView;
    verCodeTex.leftViewMode = UITextFieldViewModeAlways;
    verCodeTex.layer.borderColor = [UIColor colorWithHexString:@"#d5d3d5"].CGColor;
    verCodeTex.layer.borderWidth = 0.8;
    verCodeTex.layer.cornerRadius = 4;
    
    commitBtn.layer.cornerRadius = 6;
    commitBtn.clipsToBounds = YES;
    
    NSString *phoneholderText = @"请输入手机号码";
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:phoneholderText];
    [placeholder addAttribute:NSForegroundColorAttributeName
                        value:[UIColor colorWithHexString:@"#A3A3A3"]
                        range:NSMakeRange(0, phoneholderText.length)];
    [placeholder addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:16]
                        range:NSMakeRange(0, phoneholderText.length)];
    phoneTex.attributedPlaceholder = placeholder;
    
    NSString *verCodeholderText = @"请输入验证码";
    NSMutableAttributedString *verCodeplaceholder = [[NSMutableAttributedString alloc] initWithString:verCodeholderText];
    [verCodeplaceholder addAttribute:NSForegroundColorAttributeName
                        value:[UIColor colorWithHexString:@"#A3A3A3"]
                        range:NSMakeRange(0, verCodeholderText.length)];
    [verCodeplaceholder addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:16]
                        range:NSMakeRange(0, verCodeholderText.length)];
    verCodeTex.attributedPlaceholder = verCodeplaceholder;
}

- (void)endEditAction {
    [self.tableView endEditing:YES];
}

-(void)getVerCodeAction
{
    [self.view endEditing:YES];
    
    _sendCodeBtn.enabled = NO;
    
    if(phoneTex.text.length == 0||phoneTex.text == nil){
        [self showHint:@"请输入手机号码"];
        _sendCodeBtn.enabled = YES;
        return;
    }
    
    if(![Utils valiMobile:phoneTex.text]){
        [self showHint:@"请输入正确手机号码"];
        _sendCodeBtn.enabled = YES;
        return;
    }
    
    NSString *phone = [kUserDefaults objectForKey:KUserPhoneNum];
    if ([phone isEqualToString:phoneTex.text]) {
        [self showHint:@"修改绑定的号码不能与原号码一致!"];
        _sendCodeBtn.enabled = YES;
        return;
    }
    
    [self judgmentIsRegister];
    
}

-(void)judgmentIsRegister
{
    // 判断用户是否已注册
    NSString *verCodeUrl = [NSString stringWithFormat:@"%@/public/isRegister?custMobile=%@", MainUrl, phoneTex.text];
    [[NetworkClient sharedInstance] GET:verCodeUrl dict:nil progressFloat:nil succeed:^(id responseObject) {
        if([responseObject[@"code"] isEqualToString:@"1"]){

            [self sendCode];
        }else {
            // 已注册
            [self showHint:responseObject[@"message"]];
            _sendCodeBtn.enabled = YES;
        }
        //        NSLog(@"%@", responseObject[@"message"]);
    } failure:^(NSError *error) {
        [self showHint:@"网络错误,请重试!"];
        _sendCodeBtn.enabled = YES;
    }];
    
}

-(void)sendCode
{
    [self showHudInView:self.view hint:@""];
    
    // 发送验证码    1 注册 2忘记密码 3密码登录
    NSString *verCodeUrl = [NSString stringWithFormat:@"%@/public/getSmsVerify?custMobile=%@&verifyType=%@", MainUrl, phoneTex.text, @"8"];
    [[NetworkClient sharedInstance] GET:verCodeUrl dict:nil progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        [self showHint:responseObject[@"message"]];
        
        if([responseObject[@"code"] isEqualToString:@"1"]){
            // 发送成功
            [verCodeTex becomeFirstResponder];
            
            _timeSecond = timeSendAgain;
            [_sendCodeBtn setTitle:[NSString stringWithFormat:@"%ld S", _timeSecond] forState:UIControlStateNormal];
            // 倒计时
            [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
                _timeSecond --;
                if(_timeSecond <= 0){
                    [_sendCodeBtn setTitle:@"重获验证码" forState:UIControlStateNormal];
                    _sendCodeBtn.enabled = YES;
                    [timer invalidate];
                }else {
                    [_sendCodeBtn setTitle:[NSString stringWithFormat:@"%ld S", _timeSecond] forState:UIControlStateNormal];
                }
            } repeats:YES];
        }else {
            _sendCodeBtn.enabled = YES;
        }
    } failure:^(NSError *error) {
        _sendCodeBtn.enabled = YES;
        [self showHint:@"网络错误,请重试!"];
        [self hideHud];
    }];
}

- (IBAction)commitBtnClick:(id)sender {
    
    if(phoneTex.text == nil || phoneTex.text.length <= 0){
        [self showHint:@"请输入手机号码"];
        return;
    }
    
    if(verCodeTex.text == nil || verCodeTex.text.length <= 0){
        [self showHint:@"请输入验证码"];
        return;
    }
    
    // 验证验证码正确 1 注册 2忘记密码 3密码登录
    [self showHudInView:self.view hint:@""];
    NSString *verCodeUrl = [NSString stringWithFormat:@"%@/public/isSmsVerify?custMobile=%@&smsCode=%@&verifyType=%@", MainUrl, phoneTex.text, verCodeTex.text, @"8"];
    [[NetworkClient sharedInstance] GET:verCodeUrl dict:nil progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        [self showHint:responseObject[@"message"]];
        if([responseObject[@"code"] isEqualToString:@"1"]){
            // 验证通过
            [self changePhoneAction:phoneTex.text];
        }
        
    } failure:^(NSError *error) {
        [self hideHud];
    }];
}

-(void)changePhoneAction:(NSString *)phoneNum
{
    NSString *custId = [kUserDefaults objectForKey:kCustId];
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/upCustMobile",MainUrl];
    
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setObject:custId forKey:@"custId"];
    [param setObject:phoneNum forKey:@"custMobile"];
    
    NSString *jsonStr = [Utils convertToJsonData:param];
    
    NSMutableArray *params = @{}.mutableCopy;
    [params setValue:jsonStr forKey:@"param"];
    
    [self showHudInView:self.view hint:@""];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        [self showHint:responseObject[@"message"]];
        if([responseObject[@"code"] isEqualToString:@"1"]){
            [kUserDefaults removeObjectForKey:KMemberId];
            [kUserDefaults setObject:phoneNum forKey:KUserPhoneNum];
            [kUserDefaults setObject:phoneNum forKey:kUserAccount];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        [self showHint:@"网络错误,请重试!"];
        [self hideHud];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


@end
