//
//  PwdTableViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/2.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "PwdTableViewController.h"
#import "MD5.h"
#import "Utils.h"
#import "LoginViewController.h"
#import "RegUserModel.h"
#import "PersonMsgModel.h"

@interface PwdTableViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *pwdBgView;
@property (weak, nonatomic) IBOutlet UITextField *pwdTex;

@property (weak, nonatomic) IBOutlet UIImageView *surePwdBgView;
@property (weak, nonatomic) IBOutlet UITextField *surePwdTex;

@property (weak, nonatomic) IBOutlet UIButton *complteBtn;

@end

@implementation PwdTableViewController

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
    
    _complteBtn.layer.cornerRadius = 4;
    
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
    self.title = @"设置密码";
    
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

- (IBAction)completeRegisterAction:(id)sender {
    [self.view endEditing:YES];
//    [self.navigationController popToRootViewControllerAnimated:YES];
    
    if(_pwdTex.text == nil || _pwdTex.text.length <= 0){
        [self showHint:@"请输入密码"];
        return;
    }
    
    if (![Utils judgePassWordLegal:_pwdTex.text]) {
        UIAlertView *remainInstall = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的新密码必须包括字母和数字，密码长度至少8位" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [remainInstall show];
        return;
    }

    if(![_pwdTex.text isEqualToString:_surePwdTex.text]){
        [self showHint:@"两次密码不一致"];
        return;
    }
    
    // 注册
    NSString *verCodeUrl = [NSString stringWithFormat:@"%@/public/custReg", MainUrl];
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setObject:_phoneNum forKey:@"custMobile"];
    [param setObject:[_pwdTex.text md5String] forKey:@"custPwd"];
    [param setObject:_workNo forKey:@"certIds"];
    [param setObject:_custName forKey:@"custName"];
    NSString *deviceModel = [[NSUserDefaults standardUserDefaults] objectForKey:KDeviceModel];
    NSString *pushId = [[NSUserDefaults standardUserDefaults] objectForKey:KPushRegisterId];
    if(![deviceModel isKindOfClass:[NSNull class]]&&deviceModel != nil){
        [param setObject:deviceModel forKey:@"mobileModel"];
    }
    if(![pushId isKindOfClass:[NSNull class]]&&pushId != nil){
        [param setObject:pushId forKey:@"equId"];
    }
    [param setObject:@"1" forKey:@"equIdType"];         // 0:ANDROID 1:IOS 2:微信 3：WP];
//    [param setObject:@"" forKey:@"custHeadImage"];    // 客户头像地址 ，若不填，则系统分配
    
    NSString *jsonStr = [Utils convertToJsonData:param];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:jsonStr forKey:@"param"];
    
    [[NetworkClient sharedInstance] POST:verCodeUrl dict:params progressFloat:nil succeed:^(id responseObject) {
        if([responseObject[@"code"] isEqualToString:@"1"]){
            // 注册成功  直接登录
            [self showHint:responseObject[@"message"]];
//            LoginViewController *loginVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
//            [self.navigationController popToViewController:loginVC animated:YES];
            
            RegUserModel *model = [[RegUserModel alloc] initWithDataDic:responseObject[@"responseData"]];
            
            [kUserDefaults setBool:YES forKey:KLoginStatus];
            if(![model.certIds isKindOfClass:[NSNull class]]&&model.certIds != nil){
                [[NSUserDefaults standardUserDefaults] setObject:model.certIds forKey:KUserCertId];
            }
            if(![model.custId isKindOfClass:[NSNull class]]&&model.custId != nil){
                [kUserDefaults setObject:model.custId forKey:kCustId];
            }
            [[NSUserDefaults standardUserDefaults] setObject:KLogin forKey:KLoginWay];
            [kUserDefaults setObject:_pwdTex.text forKey:KLoginPasword];
            [[NSUserDefaults standardUserDefaults] setObject:model.custMobile forKey:KUserPhoneNum];
            
            [kUserDefaults synchronize];
            
            [self loadFaceImageId];
            
        }else {
            if(![responseObject[@"message"] isKindOfClass:[NSNull class]]&&responseObject[@"message"] != nil){
                [self showHint:responseObject[@"message"]];
//                [self showHint:@"注册失败!"];
            }
        }
    } failure:^(NSError *error) {
        [self showHint:@"网络错误,请重试!"];
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
            [UIApplication sharedApplication].delegate.window.rootViewController = [BaseTabbarCtrl new];
        }
    } failure:^(NSError *error) {
        
    }];
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

@end
