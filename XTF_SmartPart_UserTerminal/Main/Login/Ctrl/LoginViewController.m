//
//  LoginViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 魏唯隆 on 2017/11/30.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "PersonMsgModel.h"
#import "ForgetPwdTableViewController.h"
#import <WXApi.h>
#import "MD5.h"
#import "Utils.h"
#import "UserModel.h"
#import "RegUserModel.h"
#import <UMSocialQQHandler.h>
#import "RoottabbarController.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    __weak IBOutlet UIImageView *_usernameBgImgView;
    __weak IBOutlet UITextField *_usernameTF;
    
    __weak IBOutlet UIImageView *_pswBgImgView;
    __weak IBOutlet UITextField *_pswTF;
    
    __weak IBOutlet UIButton *_loginBt;
    
    __weak IBOutlet UIButton *remPwdBtn;

    __weak IBOutlet UILabel *remLab;
    
    __weak IBOutlet UIButton *qqLoginBtn;
    __weak IBOutlet UILabel *qqLoginLab;
    
    __weak IBOutlet UIButton *_weiboLoginBtn;
    __weak IBOutlet UILabel *_weiboLoginLab;
    
    __weak IBOutlet UIButton *_weixinLoginBtn;
    __weak IBOutlet UILabel *_weixinLoginLab;
    NSInteger index;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initView];
}

- (void)_initView {
    self.title = @"登录";
    
    index = 1;
    
    UITapGestureRecognizer *endDditTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditAction)];
    [self.tableView addGestureRecognizer:endDditTap];
    
    UIButton *leftBtn = [[UIButton alloc] init];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [leftBtn setImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(_leftBarBtnItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"员工注册" style:UIBarButtonItemStylePlain target:self action:@selector(RegistAction)];
    
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.bounces = NO;
    
    _loginBt.layer.cornerRadius = 4;
    
    // 初始化textField
    _usernameTF.delegate = self;
    _pswTF.delegate = self;
    
    _usernameBgImgView.image = [_usernameBgImgView.image resizableImageWithCapInsets:UIEdgeInsetsMake(20, 40, 20, 40)];
    _pswBgImgView.image = [_pswBgImgView.image resizableImageWithCapInsets:UIEdgeInsetsMake(20, 40, 20, 40)];
    
    UIView *userLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 50)];
    UIImageView *userLeftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 16, 15, 15)];
    userLeftImgView.image = [UIImage imageNamed:@"login_number"];
    [userLeftView addSubview:userLeftImgView];
    _usernameTF.leftView = userLeftView;
    _usernameTF.leftViewMode = UITextFieldViewModeAlways;
    _usernameTF.layer.borderColor = [UIColor colorWithHexString:@"#d5d3d5"].CGColor;
    _usernameTF.layer.borderWidth = 0.8;
    _usernameTF.layer.cornerRadius = 4;
    
    UIView *pwsLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 50)];
    UIImageView *pswLeftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 16, 15, 15)];
    pswLeftImgView.image = [UIImage imageNamed:@"login_tf_psw"];
    [pwsLeftView addSubview:pswLeftImgView];
    _pswTF.leftView = pwsLeftView;
    _pswTF.leftViewMode = UITextFieldViewModeAlways;
    _pswTF.layer.borderColor = [UIColor colorWithHexString:@"#d5d3d5"].CGColor;
    _pswTF.layer.borderWidth = 0.8;
    _pswTF.layer.cornerRadius = 4;
    
    remLab.userInteractionEnabled = YES;
    
    remPwdBtn.selected = NO;
    
    [remPwdBtn setBackgroundImage:[UIImage imageNamed:@"remember_select"] forState:UIControlStateSelected];
    [remPwdBtn setBackgroundImage:[UIImage imageNamed:@"remember_normal"] forState:UIControlStateNormal];
    
    UITapGestureRecognizer *remTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remPwdBtnAction:)];
    [remLab addGestureRecognizer:remTap];
    
    if ([kUserDefaults boolForKey:isRememberPwd]&&[kUserDefaults objectForKey:kUserAccount] != nil&&[kUserDefaults objectForKey:kUserPwd]) {
        remPwdBtn.selected = YES;
        _usernameTF.text = [NSString stringWithFormat:@"%@",[kUserDefaults objectForKey:kUserAccount]];
        _pswTF.text = [NSString stringWithFormat:@"%@",[kUserDefaults objectForKey:kUserPwd]];
    }else{
        _usernameTF.text = @"";
        _pswTF.text = @"";
    }
}

#pragma mark 记住密码
- (IBAction)remPwdBtnAction:(id)sender {
    UIButton *btn = remPwdBtn;
    
    if (btn.selected) {
        btn.selected = !btn.selected;
        [kUserDefaults setBool:NO forKey:isRememberPwd];
        if ([kUserDefaults objectForKey:kUserAccount] != nil) {
            [kUserDefaults removeObjectForKey:kUserAccount];
            [kUserDefaults removeObjectForKey:kUserPwd];
        }
        [kUserDefaults synchronize];
    }else{
        btn.selected = !btn.selected;
        [kUserDefaults setBool:YES forKey:isRememberPwd];
        [kUserDefaults synchronize];
    }
}

- (void)_leftBarBtnItemClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)endEditAction {
    [self.tableView endEditing:YES];
}

#pragma mark 忘记密码
- (IBAction)forgetPsw:(id)sender {
    
    ForgetPwdTableViewController *forgetVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"ForgetPwdTableViewController"];
    [self.navigationController pushViewController:forgetVC animated:YES];
    
}

#pragma mark 登录
- (IBAction)loginAction:(id)sender {
    
    [self.view endEditing:YES];

    [self employeeLoginAction];
}

#pragma mark 员工登录
-(void)employeeLoginAction
{
    if ([_usernameTF.text isEqualToString:@""] || _usernameTF.text.length == 0)
    {
        [self showHint:@"请输入用户名"];
        return;
    }else if ([_pswTF.text isEqualToString:@""] || _pswTF.text.length == 0)
    {
        [self showHint:@"请输入密码"];
        return;
    }
    
    if (![Utils valiMobile:_usernameTF.text]) {
        [self showHint:@"手机号格式有误!"];
        return;
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/appLogin",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:_usernameTF.text forKey:@"custMobile"];
    [params setObject:[_pswTF.text md5String] forKey:@"custPwd"];
    
    NSString *deviceModel = [kUserDefaults objectForKey:KDeviceModel];
    
    if(![deviceModel isKindOfClass:[NSNull class]]&&deviceModel != nil){
        [params setObject:deviceModel forKey:@"mobileModel"];
    }
    
    NSString *registerId = [kUserDefaults objectForKey:KPushRegisterId];
    
    if(![registerId isKindOfClass:[NSNull class]]&&registerId != nil){
        [params setObject:registerId forKey:@"equId"];
    }
    
    [params setObject:@"1" forKey:@"equIdType"];
    
    NSString *jsonStr = [Utils convertToJsonData:params];

    NSMutableDictionary *param = @{}.mutableCopy;
    [param setObject:jsonStr forKey:@"param"];
    
    [self showHudInView:self.view hint:@""];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            NSDictionary *dic = responseObject[@"responseData"];
            if (![dic isKindOfClass:[NSNull class]]&&dic != nil) {
                UserModel *model = [[UserModel alloc] initWithDataDic:dic];

                [kUserDefaults setBool:YES forKey:KLoginStatus];
                if(![model.CERT_IDS isKindOfClass:[NSNull class]]&&model.CERT_IDS != nil){
                    [[NSUserDefaults standardUserDefaults] setObject:model.CERT_IDS forKey:KUserCertId];
                    [[NSUserDefaults standardUserDefaults] setObject:KLogin forKey:KLoginWay];
                }else{
                    [kUserDefaults setObject:KAuthLoginMobile forKey:KLoginWay];
                }
                
                if (![model.token isKindOfClass:[NSNull class]]&&model.token != nil) {
                    [kUserDefaults setObject:model.token forKey:kUserLoginToken];
                }
                
                if(![model.CUST_ID isKindOfClass:[NSNull class]]&&model.CUST_ID != nil){
                    [kUserDefaults setObject:model.CUST_ID forKey:kCustId];
                }
                
                [[NSUserDefaults standardUserDefaults] setObject:model.CUST_MOBILE forKey:KUserPhoneNum];
                [[NSUserDefaults standardUserDefaults] setObject:_pswTF.text forKey:KLoginPasword];
                
                if(![model.COMPANY_ID isKindOfClass:[NSNull class]]&&model.COMPANY_ID != nil){
                    [kUserDefaults setObject:[model.COMPANY_ID stringValue] forKey:companyID];
                }
                
                if(![model.ORG_ID isKindOfClass:[NSNull class]]&&model.ORG_ID != nil){
                    [kUserDefaults setObject:[model.ORG_ID stringValue] forKey:OrgId];
                }
                
                if (![model.SEX isKindOfClass:[NSNull class]]&&model.SEX != nil) {
                    [kUserDefaults setObject:model.SEX forKey:KUserSex];
                }
                
                if (![model.BIRTHDAY isKindOfClass:[NSNull class]]&&model.BIRTHDAY != nil) {
                    [kUserDefaults setObject:model.BIRTHDAY forKey:kUserBirthDay];
                }
                
                [kUserDefaults setBool:YES forKey:isSetPwd];
                
                if ([kUserDefaults boolForKey:isRememberPwd]) {
                    [kUserDefaults setObject:model.CUST_MOBILE forKey:kUserAccount];
                    [kUserDefaults setObject:_pswTF.text forKey:kUserPwd];
                }
                
                if (![model.CUST_NAME isKindOfClass:[NSNull class]]&&model.CUST_NAME != nil) {
                    [kUserDefaults setObject:model.CUST_NAME forKey:KUserCustName];
                }
            
                NSString *faceimageid = model.FACE_IMAGE_ID;
                if ([faceimageid isKindOfClass:[NSNull class]]||faceimageid == nil||faceimageid.length == 0) {
                    [kUserDefaults setObject:@"" forKey:KFACE_IMAGE_ID];
                }else{
                    [kUserDefaults setObject:model.FACE_IMAGE_ID forKey:KFACE_IMAGE_ID];
                }
                
                [kUserDefaults synchronize];
                
                // 登录完成
                [UIApplication sharedApplication].delegate.window.rootViewController = [RoottabbarController new];
            }
        }
        else{
            [self hideHud];
            if(![responseObject[@"message"] isKindOfClass:[NSNull class]]&&responseObject[@"message"] != nil){
                [self showHint:responseObject[@"message"]];
            }
        }
    } failure:^(NSError *error) {
        [self hideHud];
        YYReachability *rech = [YYReachability reachability];
        if (!rech.reachable) {
            [self showHint:@"网络不给力,请重试!"];
        }else{
            [self showHint:@"登录失败,请重试!"];
        }
    }];
    
}

#pragma mark 第三方登录
/*
 2 qq认证
 3 微信认证
 4 新浪微博
 */
- (IBAction)weChatLoginAction:(id)sender {
    
    BOOL isInstallWeChat = [[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"weixin://"]];
    if (!isInstallWeChat) {
        [self showHint:@"请先安装微信!"];
        return;
    }
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            // 第三方平台SDK源数据
            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
            
            [self authLogin:@"3" authId:resp.uid nick:resp.name iconUrl:resp.iconurl];
        }
    }];
}

- (IBAction)weiboLoginAction:(id)sender {
    BOOL isInstallWeiBo = [[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_Sina];
    if (!isInstallWeiBo) {
        [self showHint:@"请先安装微博!"];
        return;
    }
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Sina currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            // 第三方平台SDK源数据
            NSLog(@"Sina originalResponse: %@", resp.originalResponse);
            
            [self authLogin:@"4" authId:resp.uid nick:resp.name iconUrl:resp.iconurl];
        }
    }];
}

- (IBAction)qqLoginAction:(id)sender {
    
    BOOL isInstallQQ = [[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"mqqapi://"]];
//    BOOL isInstallQQ = [[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ];
    if (!isInstallQQ) {
        [self showHint:@"请先安装QQ!"];
        return;
    }
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            // 第三方平台SDK源数据
            NSLog(@"QQ originalResponse: %@", resp.originalResponse);
            [self authLogin:@"2" authId:resp.uid nick:resp.name iconUrl:resp.iconurl];
        }
    }];
}

// 第三方登录
- (void)authLogin:(NSString *)authType authId:(NSString *)authId nick:(NSString *)nick iconUrl:(NSString *)iconUrl {
    if(authId && authId.length > 0){
        // 判断是否注册过
        [self showHudInView:self.view hint:@""];
        NSString *authUrl = [NSString stringWithFormat:@"%@/public/isAuth?authType=%@&authId=%@", MainUrl, authType, authId];
        [[NetworkClient sharedInstance] GET:authUrl dict:nil progressFloat:nil succeed:^(id responseObject) {
            if([responseObject[@"code"] isEqualToString:@"1"]){
                // 未注册  注册 登录
                [self RegisterUser:authId authType:authType nick:nick iconUrl:iconUrl];
            }else {
                // 已注册 掉接口登录
                [self loginClient:authId authType:authType nick:nick iconUrl:iconUrl];
            }
            
        } failure:^(NSError *error) {
            [self hideHud];
            [self showHint:@"网络错误,请重试!"];
        }];
    }
}

// 已注册 掉接口登录
- (void)loginClient:(NSString *)authId authType:(NSString *)authType nick:(NSString *)nick iconUrl:(NSString *)iconUrl{
    // 已注册  登录
    NSString *mobileModel = [[NSUserDefaults standardUserDefaults] objectForKey:KDeviceModel];
    NSString *pushId = [[NSUserDefaults standardUserDefaults] objectForKey:KPushRegisterId];
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/authLogin", MainUrl];
    
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setObject:authType forKey:@"authType"];
    [param setObject:authId forKey:@"authId"];
    [param setObject:mobileModel forKey:@"mobileModel"];
    if(![pushId isKindOfClass:[NSNull class]]&&pushId != nil){
        [param setObject:pushId forKey:@"equId"];
    }
    [param setObject:@"1" forKey:@"equIdType"];
    
    NSString *jsonStr = [Utils convertToJsonData:param];

    NSMutableDictionary *jsonParam = @{}.mutableCopy;
    [jsonParam setObject:jsonStr forKey:@"param"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:jsonParam progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if([responseObject[@"code"] isEqualToString:@"1"]){
            UserModel *userModel = [[UserModel alloc] initWithDataDic:responseObject[@"responseData"]];
            
            if(![userModel.CUST_ID isKindOfClass:[NSNull class]]&&userModel.CUST_ID != nil){
                [kUserDefaults setObject:userModel.CUST_ID forKey:kCustId];
            }

            if(![userModel.IS_MOBILE isKindOfClass:[NSNull class]]&&userModel.IS_MOBILE != nil && [userModel.IS_MOBILE isEqualToString:@"0"]){
                // 游客
                [[NSUserDefaults standardUserDefaults] setObject:KAuthLogin forKey:KLoginWay];
                [kUserDefaults setObject:nick forKey:KAuthName];
                
            }else if(![userModel.CERT_IDS isKindOfClass:[NSNull class]]&&[userModel.IS_MOBILE isEqualToString:@"1"] && userModel.CERT_IDS != nil && userModel.CERT_IDS.length > 0){
                // 员工
                [[NSUserDefaults standardUserDefaults] setObject:KLogin forKey:KLoginWay];
                if( ![userModel.CUST_MOBILE isKindOfClass:[NSNull class]]&&userModel.CUST_MOBILE != nil){
                    [[NSUserDefaults standardUserDefaults] setObject:userModel.CUST_MOBILE forKey:KUserPhoneNum];
                }
                if(![userModel.CUST_NAME isKindOfClass:[NSNull class]]&&userModel.CUST_NAME != nil){
                    [kUserDefaults setObject:userModel.CUST_NAME forKey:KUserCustName];
                }
                
            }else {
                // 访客
                [[NSUserDefaults standardUserDefaults] setObject:KAuthLoginMobile forKey:KLoginWay];
                if(![userModel.CUST_MOBILE isKindOfClass:[NSNull class]]&&userModel.CUST_MOBILE != nil){
                    [[NSUserDefaults standardUserDefaults] setObject:userModel.CUST_MOBILE forKey:KUserPhoneNum];
                }
                
                if(![userModel.CUST_NAME isKindOfClass:[NSNull class]]&&userModel.CUST_NAME != nil){
                    [kUserDefaults setObject:userModel.CUST_NAME forKey:KUserCustName];
                }
            }

            [[NSUserDefaults standardUserDefaults] setObject:authId forKey:KAuthId];
            [[NSUserDefaults standardUserDefaults] setObject:authType forKey:KAuthType];
            [kUserDefaults setBool:YES forKey:KLoginStatus];
            
            if(![userModel.CERT_IDS isKindOfClass:[NSNull class]]&&userModel.CERT_IDS != nil){
                [kUserDefaults setObject:userModel.CERT_IDS forKey:KUserCertId];
            }
            
            if (![userModel.CUST_PASSWD isKindOfClass:[NSNull class]]&&userModel.CUST_PASSWD != nil) {
                [kUserDefaults setObject:userModel.CUST_PASSWD forKey:KLoginPasword];
                [kUserDefaults setBool:NO forKey:isSetPwd];
            }
            
            if ([userModel.FACE_IMAGE_ID isKindOfClass:[NSNull class]]||userModel.FACE_IMAGE_ID == nil) {
                [kUserDefaults setObject:@"" forKey:KFACE_IMAGE_ID];
            }else{
                [kUserDefaults setObject:userModel.FACE_IMAGE_ID forKey:KFACE_IMAGE_ID];
            }
            
            if (![userModel.SEX isKindOfClass:[NSNull class]]&&userModel.SEX != nil) {
                [kUserDefaults setObject:userModel.SEX forKey:KUserSex];
            }
            
            if (![userModel.BIRTHDAY isKindOfClass:[NSNull class]]&&userModel.BIRTHDAY != nil) {
                [kUserDefaults setObject:userModel.BIRTHDAY forKey:kUserBirthDay];
            }
            
            [kUserDefaults synchronize];
            // 登录完成
            [UIApplication sharedApplication].delegate.window.rootViewController = [RoottabbarController new];
            
        }else {
            if (![responseObject[@"message"] isKindOfClass:[NSNull class]]) {
                [self showHint:responseObject[@"message"]];
            }
        }
        
    } failure:^(NSError *error) {
        [self showHint:@"网络错误,请重试!"];
        [self hideHud];
    }];
}

// 使用时间戳作为用户名 注册用户
- (void)RegisterUser:(NSString *)authId authType:(NSString *)authType nick:(NSString *)nick iconUrl:(NSString *)iconUrl{
    NSString *timeStr = [NSString stringWithFormat:@"%f", [NSDate date].timeIntervalSince1970 * 1000000];
    NSString *time = [timeStr componentsSeparatedByString:@"."].firstObject;
    NSString *userName = [time substringFromIndex:time.length - 11];
    
    NSString *mobileModel = [[NSUserDefaults standardUserDefaults] objectForKey:KDeviceModel];
    NSString *pushId = [[NSUserDefaults standardUserDefaults] objectForKey:KPushRegisterId];
    
    NSString *registUrl = [NSString stringWithFormat:@"%@/public/authCreateCust", MainUrl];
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setObject:authType forKey:@"authType"];
    [param setObject:authId forKey:@"authId"];
    [param setObject:userName forKey:@"timeStamp"];
    [param setObject:@"" forKey:@"custName"];
    [param setObject:mobileModel forKey:@"mobileModel"];
    [param setObject:pushId forKey:@"equId"];
    [param setObject:@"1" forKey:@"equIdType"];
    [param setObject:iconUrl forKey:@"custHeadImage"];
    
    NSString *jsonStr = [Utils convertToJsonData:param];

    NSMutableDictionary *jsonParam = @{}.mutableCopy;
    [jsonParam setObject:jsonStr forKey:@"param"];
    
    [[NetworkClient sharedInstance] POST:registUrl dict:jsonParam progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if([responseObject[@"code"] isEqualToString:@"1"]){
            RegUserModel *model = [[RegUserModel alloc] initWithDataDic:responseObject[@"responseData"]];
            
            // 注册成功保存信息 (登录完成)
            [[NSUserDefaults standardUserDefaults] setObject:KAuthLogin forKey:KLoginWay];
            
            [[NSUserDefaults standardUserDefaults] setObject:authId forKey:KAuthId];
            [[NSUserDefaults standardUserDefaults] setObject:authType forKey:KAuthType];
            [kUserDefaults setBool:YES forKey:KLoginStatus];
            if(![model.custId isKindOfClass:[NSNull class]]&&model.custId != nil){
                [kUserDefaults setObject:model.custId forKey:kCustId];
            }
            [kUserDefaults setObject:nick forKey:KAuthName];
            
            [kUserDefaults synchronize];
            
            [self loadFaceImageId];
        }else {
            if (![responseObject[@"message"] isKindOfClass:[NSNull class]]) {
                [self showHint:responseObject[@"message"]];
            }
        }
        
    } failure:^(NSError *error) {
        [self showHint:@"网络错误,请重试!"];
        [self hideHud];
    }];
}

-(void)loadFaceImageId{
    NSString *custId = [[NSUserDefaults standardUserDefaults] objectForKey:kCustId];
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/getCustInfo", MainUrl];
    NSMutableDictionary *param = @{}.mutableCopy;
    if(![custId isKindOfClass:[NSNull class]]&&custId != nil){
        [param setObject:custId forKey:@"custId"];
    }
    
    [[NetworkClient sharedInstance] POST:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
        if([responseObject[@"code"] isEqualToString:@"1"]){
            PersonMsgModel *model = [[PersonMsgModel alloc] initWithDataDic:responseObject[@"responseData"]];
            
            if ([model.FACE_IMAGE_ID isKindOfClass:[NSNull class]]||model.FACE_IMAGE_ID == nil) {
                [kUserDefaults setObject:@"" forKey:KFACE_IMAGE_ID];
            }else{
                [kUserDefaults setObject:model.FACE_IMAGE_ID forKey:KFACE_IMAGE_ID];
            }
            // 登录完成
            [UIApplication sharedApplication].delegate.window.rootViewController = [RoottabbarController new];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 注册
- (void)RegistAction {
    RegisterViewController *registVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    [self.navigationController pushViewController:registVC animated:YES];
}

#pragma mark UItextField协议
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if(textField == _usernameTF){
        _usernameBgImgView.hidden = NO;
        _usernameTF.layer.borderColor = [UIColor clearColor].CGColor;
        _pswBgImgView.hidden = YES;
    }else if (textField == _pswTF) {
        _pswBgImgView.hidden = NO;
        _pswTF.layer.borderColor = [UIColor clearColor].CGColor;
        _usernameBgImgView.hidden = YES;
    }
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if(textField == _usernameTF){
        _usernameBgImgView.hidden = YES;
        _usernameTF.layer.borderColor = [UIColor colorWithHexString:@"#d5d3d5"].CGColor;
    }else if (textField == _pswTF) {
        _pswBgImgView.hidden = YES;
        _pswTF.layer.borderColor = [UIColor colorWithHexString:@"#d5d3d5"].CGColor;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    [self employeeLoginAction];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
