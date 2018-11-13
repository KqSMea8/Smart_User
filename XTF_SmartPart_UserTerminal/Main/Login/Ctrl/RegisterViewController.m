//
//  RegisterViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 魏唯隆 on 2017/11/30.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "RegisterViewController.h"
#import "PwdTableViewController.h"
#import "Utils.h"
#import "UserAgreementViewController.h"

#define timeSendAgain 60

@interface RegisterViewController ()<UITextFieldDelegate,UIPickerViewDelegate>
{
    UIButton *_sendCodeBtn;
    
    NSInteger _timeSecond;
    
    UIPickerView *_companyPickView;
    
    UIView *_dateView;
    
    NSInteger selectIndex;
    NSMutableArray *_dataArr;
    
    UITextField *_selectTex;
    
    __weak IBOutlet UIButton *argeeBtn;
    
    __weak IBOutlet UILabel *signLab;
    
    BOOL isCorrcert;
    BOOL isNoNetWork;
    BOOL isRegister;
    
    BOOL isMatch;
    
    NSString *_message;
}

@property (weak, nonatomic) IBOutlet UIImageView *cardBgView;
@property (weak, nonatomic) IBOutlet UITextField *cardTex;

@property (weak, nonatomic) IBOutlet UIImageView *phoneBgView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTex;

@property (weak, nonatomic) IBOutlet UIImageView *userNameBgView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTex;

@property (weak, nonatomic) IBOutlet UIImageView *codeBgView;
@property (weak, nonatomic) IBOutlet UITextField *codeTex;

@property (weak, nonatomic) IBOutlet UIButton *agreeRegisterBtn;

@end

@implementation RegisterViewController

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
    
    _agreeRegisterBtn.layer.cornerRadius = 4;
    
    // 初始化textField
    _cardTex.delegate = self;
    _userNameTex.delegate = self;
    _phoneTex.delegate = self;
    _codeTex.delegate = self;
    
    _cardBgView.image = [_cardBgView.image resizableImageWithCapInsets:UIEdgeInsetsMake(20, 40, 20, 40)];
    _userNameBgView.image = [_userNameBgView.image resizableImageWithCapInsets:UIEdgeInsetsMake(20, 40, 20, 40)];
    _phoneBgView.image = [_phoneBgView.image resizableImageWithCapInsets:UIEdgeInsetsMake(20, 40, 20, 40)];
    _codeBgView.image = [_codeBgView.image resizableImageWithCapInsets:UIEdgeInsetsMake(20, 40, 20, 40)];
    
    UIView *realNameLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 50)];
    UIImageView *realNameLeftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 16, 15, 15)];
    realNameLeftImgView.image = [UIImage imageNamed:@"userName"];
    [realNameLeftView addSubview:realNameLeftImgView];
    _userNameTex.leftView = realNameLeftView;
    _userNameTex.leftViewMode = UITextFieldViewModeAlways;
    _userNameTex.layer.borderColor = [UIColor colorWithHexString:@"#d5d3d5"].CGColor;
    _userNameTex.layer.borderWidth = 0.8;
    _userNameTex.layer.cornerRadius = 4;
    
    UIView *cardLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 50)];
    UIImageView *cardLeftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 16, 15, 15)];
    cardLeftImgView.image = [UIImage imageNamed:@"workNum"];
    [cardLeftView addSubview:cardLeftImgView];
    _cardTex.leftView = cardLeftView;
    _cardTex.leftViewMode = UITextFieldViewModeAlways;
    _cardTex.layer.borderColor = [UIColor colorWithHexString:@"#d5d3d5"].CGColor;
    _cardTex.layer.borderWidth = 0.8;
    _cardTex.layer.cornerRadius = 4;
    
    UIView *phoneLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 50)];
    UIImageView *phoneLeftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 16, 15, 15)];
    phoneLeftImgView.image = [UIImage imageNamed:@"phone"];
    [phoneLeftView addSubview:phoneLeftImgView];
    _phoneTex.leftView = phoneLeftView;
    _phoneTex.leftViewMode = UITextFieldViewModeAlways;
    _phoneTex.layer.borderColor = [UIColor colorWithHexString:@"#d5d3d5"].CGColor;
    _phoneTex.layer.borderWidth = 0.8;
    _phoneTex.layer.cornerRadius = 4;
    
    UIView *phoneRightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 50)];
    _sendCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    [phoneRightView addSubview:_sendCodeBtn];
    [_sendCodeBtn addTarget:self action:@selector(getVerCodeAction) forControlEvents:UIControlEventTouchUpInside];
    [_sendCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_sendCodeBtn setTitleColor:[UIColor colorWithHexString:@"#FF4359"] forState:UIControlStateNormal];
    _sendCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    _phoneTex.rightView = phoneRightView;
    _phoneTex.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *codeLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 50)];
    UIImageView *codeLeftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 16, 15, 15)];
    codeLeftImgView.image = [UIImage imageNamed:@"verCode"];
    [codeLeftView addSubview:codeLeftImgView];
    _codeTex.leftView = codeLeftView;
    _codeTex.leftViewMode = UITextFieldViewModeAlways;
    _codeTex.layer.borderColor = [UIColor colorWithHexString:@"#d5d3d5"].CGColor;
    _codeTex.layer.borderWidth = 0.8;
    _codeTex.layer.cornerRadius = 4;
    
    argeeBtn.selected = YES;
    
    [argeeBtn setBackgroundImage:[UIImage imageNamed:@"remember_select"] forState:UIControlStateSelected];
    [argeeBtn setBackgroundImage:[UIImage imageNamed:@"remember_normal"] forState:UIControlStateNormal];
    
    signLab.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(argeeBtnAction:)];
    [signLab addGestureRecognizer:tap];
    
}
- (IBAction)argeeBtnAction:(id)sender {
    argeeBtn.selected = !argeeBtn.selected;
}

-(void)_initNavItems
{
    self.title = @"新员工注册";
    
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

- (IBAction)userProtocolBtnAction:(id)sender {
    UserAgreementViewController *userAgreeVC = [[UserAgreementViewController alloc] init];
    [self.navigationController pushViewController:userAgreeVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _cardTex) {
        [self verCardNum:@"1"];
    }else if (textField == _userNameTex){
        [self verFnameAndCardNum:@"1"];
    }
}

-(void)verFnameAndCardNum:(NSString *)code
{
    if(_cardTex.text == nil || _cardTex.text.length <= 0){
        [self showHint:@"请输入员工号" yOffset:-150];
        _sendCodeBtn.enabled = YES;
        return;
    }

    if (!isCorrcert) {
        _sendCodeBtn.enabled = YES;
        [self showHint:_message yOffset:-150];
        return;
    }

    if(_userNameTex.text == nil || _userNameTex.text.length <= 0){
        [self showHint:@"请输入姓名" yOffset:-150];
        _sendCodeBtn.enabled = YES;
        return;
    }

    NSString *urlStr = [NSString stringWithFormat:@"%@/public/isEmployee",MainUrl];

    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setObject:_cardTex.text forKey:@"certIds"];
    [dic setObject:_userNameTex.text forKey:@"custName"];

    NSString *jsonStr = [Utils convertToJsonData:dic];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:jsonStr forKey:@"param"];

    [[NetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        if([responseObject[@"code"] isEqualToString:@"1"]){
            isMatch = YES;
            if (![code isEqualToString:@"1"]) {
                if(_phoneTex.text == nil || _phoneTex.text.length <= 0){
                    [self showHint:@"请输入手机号码" yOffset:-150];
                    _sendCodeBtn.enabled = YES;
                    return;
                }

                if(![Utils valiMobile:_phoneTex.text]){
                    [self showHint:@"请输入正确手机号码" yOffset:-150];
                    _sendCodeBtn.enabled = YES;
                    return;
                }

                [self judgmentIsRegister];
            }

        }else{
            isMatch = NO;
            _sendCodeBtn.enabled = YES;
            if (![responseObject[@"message"] isKindOfClass:[NSNull class]]&&responseObject[@"message"] != nil) {
                [self showHint:responseObject[@"message"] yOffset:-150];
                _message = responseObject[@"message"];
            }

        }

    } failure:^(NSError *error) {
        _sendCodeBtn.enabled = YES;
        [self showHint:@"网络错误,请重试!" yOffset:-150];
    }];

}

-(void)verCardNum:(NSString *)code
{
    if(_cardTex.text == nil || _cardTex.text.length <= 0){
        [self showHint:@"请输入员工号" yOffset:-150];
        _sendCodeBtn.enabled = YES;
        return;
    }

    //判断员工号
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/isEmployee",MainUrl];

    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setObject:_cardTex.text forKey:@"certIds"];

    NSString *jsonStr = [Utils convertToJsonData:dic];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:jsonStr forKey:@"param"];

    [[NetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        
        if([responseObject[@"code"] isEqualToString:@"1"]){
            isCorrcert = YES;
            if (![code isEqualToString:@"1"]) {
                if (_userNameTex.text == nil||_userNameTex.text.length<=0) {
                    [self showHint:@"请输入姓名" yOffset:-150];
                    _sendCodeBtn.enabled = YES;
                    return;
                }

                [self verFnameAndCardNum:@"0"];

            }
        }else{

            _sendCodeBtn.enabled = YES;
            //工号有误

            isCorrcert = NO;
            if (![responseObject[@"message"] isKindOfClass:[NSNull class]]&&responseObject[@"message"] != nil) {
                [self showHint:responseObject[@"message"] yOffset:-150];
                _message = responseObject[@"message"];
            }
        }

    } failure:^(NSError *error) {
        
        _sendCodeBtn.enabled = YES;
        [self showHint:@"网络错误,请重试!" yOffset:-150];
    }];
}

#pragma mark UItextField协议
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if(textField == _cardTex){
        _cardBgView.hidden = NO;
        _cardTex.layer.borderColor = [UIColor clearColor].CGColor;
        _userNameBgView.hidden = YES;
        _phoneBgView.hidden = YES;
        _codeBgView.hidden = YES;
    }else if (textField == _userNameTex){
        _cardBgView.hidden = YES;
        _userNameTex.layer.borderColor = [UIColor clearColor].CGColor;
        _userNameBgView.hidden = NO;
        _phoneBgView.hidden = YES;
        _codeBgView.hidden = YES;
    }else if (textField == _phoneTex) {
        _phoneBgView.hidden = NO;
        _userNameBgView.hidden = YES;
        _phoneTex.layer.borderColor = [UIColor clearColor].CGColor;
        _cardBgView.hidden = YES;
        _codeBgView.hidden = YES;
    }else{
        _codeBgView.hidden = NO;
        _userNameBgView.hidden = YES;
        _codeTex.layer.borderColor = [UIColor clearColor].CGColor;
        _cardBgView.hidden = YES;
        _phoneBgView.hidden = YES;
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if(textField == _cardTex){
        _cardBgView.hidden = YES;
        _cardTex.layer.borderColor = [UIColor colorWithHexString:@"#d5d3d5"].CGColor;
    }else if (textField == _userNameTex) {
        _userNameBgView.hidden = YES;
        _userNameTex.layer.borderColor = [UIColor colorWithHexString:@"#d5d3d5"].CGColor;
    }else if (textField == _phoneTex) {
        _phoneBgView.hidden = YES;
        _phoneTex.layer.borderColor = [UIColor colorWithHexString:@"#d5d3d5"].CGColor;
    }else{
        _codeBgView.hidden = YES;
        _codeTex.layer.borderColor = [UIColor colorWithHexString:@"#d5d3d5"].CGColor;
    }
    return YES;
}

#pragma mark 获取验证码
-(void)getVerCodeAction {
    [self.view endEditing:YES];
    
    _sendCodeBtn.enabled = NO;
    
    [self verCardNum:@"2"];
}

-(void)judgmentIsRegister
{
    // 判断用户是否已注册
    NSString *verCodeUrl = [NSString stringWithFormat:@"%@/public/isRegister?custMobile=%@", MainUrl, _phoneTex.text];
    [[NetworkClient sharedInstance] GET:verCodeUrl dict:nil progressFloat:nil succeed:^(id responseObject) {
        if([responseObject[@"code"] isEqualToString:@"1"]){
            isRegister = NO;
            [self sendCode];
        }else {
            // 已注册
            if (![responseObject[@"message"] isKindOfClass:[NSNull class]]&&responseObject[@"message"] != nil) {
                [self showHint:responseObject[@"message"] yOffset:-150];
            }
            isRegister = YES;
            _sendCodeBtn.enabled = YES;
        }
        //        NSLog(@"%@", responseObject[@"message"]);
    } failure:^(NSError *error) {
        [self showHint:@"网络错误,请重试!" yOffset:-150];
        _sendCodeBtn.enabled = YES;
    }];

}

- (void)sendCode {
    
    [self showHudInView:self.view hint:@""];
    
    // 发送验证码    1 注册 2忘记密码 3密码登录
    NSString *verCodeUrl = [NSString stringWithFormat:@"%@/public/getSmsVerify?custMobile=%@&verifyType=%@", MainUrl, _phoneTex.text, @"1"];
    [[NetworkClient sharedInstance] GET:verCodeUrl dict:nil progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        [self showHint:responseObject[@"message"] yOffset:-150];
        
        if([responseObject[@"code"] isEqualToString:@"1"]){
            // 发送成功
            [_codeTex becomeFirstResponder];
            
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
        [self showHint:@"网络错误,请重试!" yOffset:-150];
        [self hideHud];
    }];
}

#pragma mark 注册
- (IBAction)agreeBtnAction:(id)sender {
    [self.view endEditing:YES];
    
    if(_cardTex.text == nil || _cardTex.text.length <= 0){
        [self showHint:@"请输入员工号" yOffset:-150];
        return;
    }
    
    [self verCardNum];
//    if (!isCorrcert) {
//        if (_message != nil&&![_message isKindOfClass:[NSNull class]]&&_message.length != 0) {
//            [self showHint:_message yOffset:-150];
//        }
//        return;
//    }
}

-(void)verCardNum
{
    //判断员工号
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/isEmployee",MainUrl];
    
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setObject:_cardTex.text forKey:@"certIds"];
    
    NSString *jsonStr = [Utils convertToJsonData:dic];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:jsonStr forKey:@"param"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        if([responseObject[@"code"] isEqualToString:@"1"]){
            [self verFnameAndCardNum];
        }else{
            [self showHint:responseObject[@"message"] yOffset:-150];
            return;
        }
        
    } failure:^(NSError *error) {
        [self showHint:@"网络错误,请重试!" yOffset:-150];
    }];
}

-(void)verFnameAndCardNum
{
    if (_userNameTex.text == nil||_userNameTex.text.length<=0) {
        [self showHint:@"请输入姓名" yOffset:-150];
        return;
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/isEmployee",MainUrl];
    
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setObject:_cardTex.text forKey:@"certIds"];
    [dic setObject:_userNameTex.text forKey:@"custName"];
    
    NSString *jsonStr = [Utils convertToJsonData:dic];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:jsonStr forKey:@"param"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        
        if([responseObject[@"code"] isEqualToString:@"1"]){
            [self cheakAll];
            
        }else{
            [self showHint:responseObject[@"message"] yOffset:-150];
            return;
            
        }
        
    } failure:^(NSError *error) {
        
        
        [self showHint:@"网络错误,请重试!" yOffset:-150];
        
    }];
}

-(void)cheakAll
{
    
//    if (!isMatch) {
//        if (_message != nil&&![_message isKindOfClass:[NSNull class]]&&_message.length != 0) {
//            [self showHint:_message yOffset:-150];
//        }
//        return;
//    }
    
    if(_phoneTex.text == nil || _phoneTex.text.length <= 0){
        [self showHint:@"请输入手机号码" yOffset:-150];
        return;
    }
    
    if(![Utils valiMobile:_phoneTex.text]){
        [self showHint:@"请输入正确手机号码" yOffset:-150];
        return;
    }
    
    if (isRegister) {
        [self showHint:@"该手机号已被注册,请重新输入!" yOffset:-150];
        return;
    }
    
    if (_codeTex.text == nil || _codeTex.text.length <= 0) {
        [self showHint:@"请输入验证码" yOffset:-150];
        return;
    }
    
    if (argeeBtn.selected) {
        // 验证验证码正确 1 注册 2忘记密码 3密码登录
        [self showHudInView:self.view hint:@""];
        NSString *verCodeUrl = [NSString stringWithFormat:@"%@/public/isSmsVerify?custMobile=%@&smsCode=%@&verifyType=%@", MainUrl, _phoneTex.text, _codeTex.text, @"1"];
        [[NetworkClient sharedInstance] GET:verCodeUrl dict:nil progressFloat:nil succeed:^(id responseObject) {
            [self hideHud];
            if([responseObject[@"code"] isEqualToString:@"1"]){
                // 验证通过
                PwdTableViewController *pwdVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"PwdTableViewController"];
                pwdVC.workNo = _cardTex.text;
                pwdVC.phoneNum = _phoneTex.text;
                pwdVC.custName = _userNameTex.text;
                [self.navigationController pushViewController:pwdVC animated:YES];
            }else {
                if (![responseObject[@"message"] isKindOfClass:[NSNull class]]&&responseObject[@"message"] != nil) {
                    [self showHint:responseObject[@"message"] yOffset:-150];
                }
                
            }
        } failure:^(NSError *error) {
            [self showHint:@"网络错误,请重试!" yOffset:-150];
            [self hideHud];
        }];
    }else{
        [self showHint:@"请阅读并同意用户协议!" yOffset:-150];
    }
}

- (void)endEditAction {
    [self.tableView endEditing:YES];
}

@end
