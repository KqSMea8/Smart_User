//
//  BindTableViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/2.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "BindTableViewController.h"
#import "Utils.h"

#import "BindUserModel.h"
#import "CompanyModel.h"

#define timeSendAgain 60

@interface BindTableViewController ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIButton *_sendCodeBtn;
    NSInteger _timeSecond;
    
    BindUserModel *userModel;
    
//    UIPickerView *_companyPickView;
    
//    UIView *_dateView;
    
    NSInteger selectIndex;
    NSMutableArray *_dataArr;
    
    UITextField *_selectTex;
    BOOL isRegister;
}

//@property (weak, nonatomic) IBOutlet UIImageView *companyBgView;
//@property (weak, nonatomic) IBOutlet UITextField *companyTex;
//
//@property (weak, nonatomic) IBOutlet UIImageView *orgBgView;
//@property (weak, nonatomic) IBOutlet UITextField *orgTex;

@property (weak, nonatomic) IBOutlet UIImageView *realNameBgView;
@property (weak, nonatomic) IBOutlet UITextField *realNameTex;
@property (weak, nonatomic) IBOutlet UIImageView *phoneBgView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTex;
@property (weak, nonatomic) IBOutlet UIImageView *verCodeBgView;
@property (weak, nonatomic) IBOutlet UITextField *verCodeTex;
@property (weak, nonatomic) IBOutlet UIImageView *memberNumBgView;
@property (weak, nonatomic) IBOutlet UITextField *memberNumTex;

//@property (nonatomic,strong) NSMutableArray *companyArr;
//@property (nonatomic,strong) NSMutableArray *orgArr;

@end

@implementation BindTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initView];
    
    [self _initNavItems];
    
//    [self _loadCompanyData];
}
/*
-(void)_loadCompanyData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/getCompanyList",MainUrl];
    
    [[NetworkClient sharedInstance] GET:urlStr dict:nil progressFloat:nil succeed:^(id responseObject) {
//        DLog(@"%@",responseObject);
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            
            [_companyArr removeAllObjects];
            
            NSArray *arr = responseObject[@"responseData"];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = (NSDictionary *)obj;
                CompanyModel *model = [[CompanyModel alloc] initWithDataDic:dic];
                [_companyArr addObject:model.COMPANY_NAME_DESC];
            }];
            [_companyPickView reloadAllComponents];
        }
    } failure:^(NSError *error) {
        DLog(@"%@",error);
    }];
}
*/
-(void)_initView
{
    selectIndex = 0;
    
//    _companyArr = @[].mutableCopy;
//
//    _orgArr = @[].mutableCopy;
//
//    _dataArr = @[].mutableCopy;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#E2E2E2"];
    
    self.tableView.bounces = NO;
    
    UITapGestureRecognizer *endDditTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditAction)];
    [self.tableView addGestureRecognizer:endDditTap];
    
    // 初始化textField
    _realNameTex.delegate = self;
    _phoneTex.delegate = self;
    _verCodeTex.delegate = self;
//    _companyTex.delegate = self;
//    _orgTex.delegate = self;
    _memberNumTex.delegate = self;
    
    UIView *realNameLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 50)];
    UIImageView *realNameLeftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 16, 15, 15)];
    realNameLeftImgView.image = [UIImage imageNamed:@"userName"];
    [realNameLeftView addSubview:realNameLeftImgView];
    _realNameTex.leftView = realNameLeftView;
    _realNameTex.leftViewMode = UITextFieldViewModeAlways;
    _realNameTex.layer.borderColor = [UIColor colorWithHexString:@"#d5d3d5"].CGColor;
    _realNameTex.layer.borderWidth = 0.8;
    _realNameTex.layer.cornerRadius = 4;
    
    if ([_type isEqualToString:@"1"]) {
        _realNameTex.text = [kUserDefaults objectForKey:KUserCustName];
        _realNameTex.tintColor = [UIColor clearColor];
        _realNameTex.textColor = [UIColor lightGrayColor];
//        _realNameTex.userInteractionEnabled = NO;
//        _realNameTex.enabled = NO;
    }
    
    UIView *phoneLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 50)];
    UIImageView *phoneLeftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 16, 15, 15)];
    phoneLeftImgView.image = [UIImage imageNamed:@"phone"];
    [phoneLeftView addSubview:phoneLeftImgView];
    _phoneTex.leftView = phoneLeftView;
    _phoneTex.leftViewMode = UITextFieldViewModeAlways;
    _phoneTex.layer.borderColor = [UIColor colorWithHexString:@"#d5d3d5"].CGColor;
    _phoneTex.layer.borderWidth = 0.8;
    _phoneTex.layer.cornerRadius = 4;
    
    if ([_type isEqualToString:@"1"]) {
        _phoneTex.text = [kUserDefaults objectForKey:KUserPhoneNum];
//        _phoneTex.userInteractionEnabled = NO;
//        _phoneTex.enabled = NO;
        _phoneTex.tintColor = [UIColor clearColor];
        _phoneTex.textColor = [UIColor lightGrayColor];
    }
    
    UIView *phoneRightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 50)];
    _sendCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    [phoneRightView addSubview:_sendCodeBtn];
    [_sendCodeBtn addTarget:self action:@selector(adjustIsRegister) forControlEvents:UIControlEventTouchUpInside];
    [_sendCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_sendCodeBtn setTitleColor:[UIColor colorWithHexString:@"#FF4359"] forState:UIControlStateNormal];
    _sendCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    _phoneTex.rightView = phoneRightView;
    _phoneTex.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *verCodeLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 50)];
    UIImageView *verCodeLeftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 16, 15, 15)];
    verCodeLeftImgView.image = [UIImage imageNamed:@"verCode"];
    [verCodeLeftView addSubview:verCodeLeftImgView];
    _verCodeTex.leftView = verCodeLeftView;
    _verCodeTex.leftViewMode = UITextFieldViewModeAlways;
    _verCodeTex.layer.borderColor = [UIColor colorWithHexString:@"#d5d3d5"].CGColor;
    _verCodeTex.layer.borderWidth = 0.8;
    _verCodeTex.layer.cornerRadius = 4;
    
    /*
    UIView *companyLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 50)];
    UIImageView *companyLeftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 16, 15, 15)];
    companyLeftImgView.image = [UIImage imageNamed:@"login_company"];
    [companyLeftView addSubview:companyLeftImgView];
    _companyTex.leftView = companyLeftView;
    _companyTex.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *companyRightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 50)];
    UIImageView *companyRightImgView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 15, 20, 20)];
    companyRightImgView.userInteractionEnabled = YES;
    companyRightView.userInteractionEnabled = YES;
    companyRightImgView.image = [UIImage imageNamed:@"list_right_narrow"];
    [companyRightView addSubview:companyRightImgView];
    _companyTex.rightView = companyRightView;
    _companyTex.rightViewMode = UITextFieldViewModeAlways;
    _companyTex.layer.borderColor = [UIColor colorWithHexString:@"#d5d3d5"].CGColor;
    _companyTex.layer.borderWidth = 0.8;
    _companyTex.layer.cornerRadius = 4;
    
    UITapGestureRecognizer *companyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(companyTapAction)];
    [companyRightView addGestureRecognizer:companyTap];
    
    UIView *orgLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 50)];
    UIImageView *orgLeftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 16, 15, 15)];
    orgLeftImgView.image = [UIImage imageNamed:@"login_org"];
    [orgLeftView addSubview:orgLeftImgView];
    _orgTex.leftView = orgLeftView;
    _orgTex.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *orgRightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 50)];
    UIImageView *orgRightImgView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 15, 20, 20)];
    orgRightImgView.image = [UIImage imageNamed:@"list_right_narrow"];
    orgRightView.userInteractionEnabled = YES;
    orgRightImgView.userInteractionEnabled = YES;
    [orgRightView addSubview:orgRightImgView];
    _orgTex.rightView = orgRightView;
    _orgTex.rightViewMode = UITextFieldViewModeAlways;
    _orgTex.layer.borderColor = [UIColor colorWithHexString:@"#d5d3d5"].CGColor;
    _orgTex.layer.borderWidth = 0.8;
    _orgTex.layer.cornerRadius = 4;
    
    UITapGestureRecognizer *orgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(orgTapAction)];
    [orgRightView addGestureRecognizer:orgTap];
     */

    UIView *memberLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 50)];
    UIImageView *memberLeftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 16, 15, 15)];
    memberLeftImgView.image = [UIImage imageNamed:@"workNum"];
    [memberLeftView addSubview:memberLeftImgView];
    _memberNumTex.leftView = memberLeftView;
    _memberNumTex.leftViewMode = UITextFieldViewModeAlways;
    _memberNumTex.layer.borderColor = [UIColor colorWithHexString:@"#d5d3d5"].CGColor;
    _memberNumTex.layer.borderWidth = 0.8;
    _memberNumTex.layer.cornerRadius = 4;
    
    [kNotificationCenter addObserver:self selector:@selector(textFiledChange:) name:UITextFieldTextDidChangeNotification object:nil];
    /*
    _dateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    _dateView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.1];
    _dateView.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dateCancel)];
    _dateView.userInteractionEnabled = YES;
    [_dateView addGestureRecognizer:tap];
    [self.view addSubview:_dateView];
    
    _companyPickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, _dateView.height-200, KScreenWidth, 200)];
    _companyPickView.delegate = self;
    _companyPickView.dataSource = self;
    _companyPickView.backgroundColor = [UIColor whiteColor];
    [_dateView addSubview:_companyPickView];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, _companyPickView.top - 40, _dateView.width, 40)];
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    toolbar.barTintColor = [UIColor lightGrayColor];
    toolbar.translucent = YES;
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dateCancel)];
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:      UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [spaceButtonItem setWidth:KScreenWidth - 110];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(dateDone)];
    toolbar.items = @[cancelItem,spaceButtonItem, doneItem];
    [_dateView addSubview:toolbar];
     */
}

-(void)_initNavItems
{
    self.title = @"身份绑定";
    
    UIButton *leftBtn = [[UIButton alloc] init];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [leftBtn setImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(_leftBarBtnItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *rightBtn = [[UIButton alloc] init];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    [rightBtn setTitle:@"绑定" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [rightBtn addTarget:self action:@selector(_rightBarBtnItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)_leftBarBtnItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)_rightBarBtnItemClick {
    [self.tableView endEditing:YES];
#pragma mark 验证验证码是否正确
    [self verCode];
}

#pragma 游客绑定验证手机号是否已被绑定或注册
-(void)adjustIsRegister
{
    if ([[kUserDefaults objectForKey:KLoginWay] isEqualToString:KAuthLoginMobile]) {
        [self getVerCodeAction];
    }else{
        if(_phoneTex.text == nil || _phoneTex.text.length <= 0){
            [self hideHud];
            [self showHint:@"请输入手机号码"];
            _sendCodeBtn.enabled = YES;
            return;
        }
        
        if(![Utils valiMobile:_phoneTex.text]){
            [self hideHud];
            [self showHint:@"请输入正确手机号码"];
            _sendCodeBtn.enabled = YES;
            return;
        }
        
        // 判断用户是否已注册
        NSString *verCodeUrl = [NSString stringWithFormat:@"%@/public/isRegister?custMobile=%@", MainUrl, _phoneTex.text];
        [[NetworkClient sharedInstance] GET:verCodeUrl dict:nil progressFloat:nil succeed:^(id responseObject) {
            if([responseObject[@"code"] isEqualToString:@"1"]){
                isRegister = NO;
                [self getVerCodeAction];
            }else {
                // 已注册
                [self showHint:responseObject[@"message"]];
                isRegister = YES;
                _sendCodeBtn.enabled = YES;
            }
            //        NSLog(@"%@", responseObject[@"message"]);
        } failure:^(NSError *error) {
            [self showHint:@"网络错误,请重试!"];
            _sendCodeBtn.enabled = YES;
        }];
    }
}

#pragma mark 获取验证码
-(void)getVerCodeAction
{
    [self.view endEditing:YES];
    [self showHudInView:self.view hint:@""];
    _sendCodeBtn.enabled = NO;
    
    if(_phoneTex.text == nil || _phoneTex.text.length <= 0){
        [self hideHud];
        [self showHint:@"请输入手机号码"];
        _sendCodeBtn.enabled = YES;
        return;
    }
    
    if(![Utils valiMobile:_phoneTex.text]){
        [self hideHud];
        [self showHint:@"请输入正确手机号码"];
        _sendCodeBtn.enabled = YES;
        return;
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/getSmsVerify",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:_phoneTex.text forKey:@"custMobile"];
    [params setObject:@"4" forKey:@"verifyType"];
    
    [[NetworkClient sharedInstance] GET:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
//        DLog(@"%@",responseObject);
        [self hideHud];
        [self showHint:responseObject[@"message"]];
        
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            // 发送成功
            [_verCodeTex becomeFirstResponder];
            
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
            
        }else{
            _sendCodeBtn.enabled = YES;
        }
        
    } failure:^(NSError *error) {
        [self hideHud];
        _sendCodeBtn.enabled = YES;
    }];
    
}

-(void)verCode
{
    if (isRegister) {
        [self showHint:@"该手机号已被注册,请重新输入!"];
        return;
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/isSmsVerify",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:_phoneTex.text forKey:@"custMobile"];
    [params setObject:_verCodeTex.text forKey:@"smsCode"];
    [params setObject:@"4" forKey:@"verifyType"];
    
    [[NetworkClient sharedInstance] GET:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
            [self showHint:responseObject[@"message"]];
            if ([responseObject[@"code"] isEqualToString:@"1"]) {
                [self bindAction];
        }
    } failure:^(NSError *error) {
//        DLog(@"%@",error);
    }];
}

#pragma mark 绑定
-(void)bindAction
{
    if (_realNameTex.text == nil||_realNameTex.text.length == 0) {
        [self showHint:@"请输入您的真实姓名!"];
        return;
    }
    
    if (![Utils valiMobile:_phoneTex.text]) {
        [self showHint:@"手机号格式有误!"];
        return;
    }
    
    [self showHudInView:self.view hint:@""];
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/authBindMobile",MainUrl];
    
    NSString *authType = [kUserDefaults objectForKey:KAuthType];
    NSString *authId = [kUserDefaults objectForKey:KAuthId];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    if (![[kUserDefaults objectForKey:KLoginWay] isEqualToString:KAuthLoginMobile]) {
        [params setObject:authType forKey:@"authType"];
        [params setObject:authId forKey:@"authId"];
    }
    
    [params setObject:_phoneTex.text forKey:@"custMobile"];
    [params setObject:_realNameTex.text forKey:@"custName"];
    if (_memberNumTex.text.length != 0) {
        [params setObject:_memberNumTex.text forKey:@"certIds"];
    }else{
//        [params setObject:@"" forKey:@"certIds"];
    }
    
    NSString *jsonStr = [Utils convertToJsonData:params];
    
    NSMutableDictionary *jsonParam = @{}.mutableCopy;
    [jsonParam setObject:jsonStr forKey:@"param"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:jsonParam progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        [self showHint:responseObject[@"message"]];
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            
            NSDictionary *dic = responseObject[@"responseData"];
            
            userModel = [[BindUserModel alloc] initWithDataDic:dic];
            
            if(![userModel.custId isKindOfClass:[NSNull class]]&&userModel.custId != nil){
                [kUserDefaults setObject:userModel.custId forKey:kCustId];
            }
            
            if(![userModel.certIds isKindOfClass:[NSNull class]]&&userModel.certIds != nil){
                [kUserDefaults setObject:userModel.certIds forKey:KUserCertId];
            }
            
            if(![userModel.custMobile isKindOfClass:[NSNull class]]&&userModel.custMobile != nil){
                [kUserDefaults setObject:userModel.custMobile forKey:KUserPhoneNum];
            }
            
            if(![userModel.custName isKindOfClass:[NSNull class]]&&userModel.custName != nil){
                [kUserDefaults setObject:userModel.custName forKey:KUserCustName];
            }
            
            if(![userModel.certIds isKindOfClass:[NSNull class]]&&[userModel.isMobile isEqualToString:@"1"] && userModel.certIds != nil && userModel.certIds.length > 0){
                // 员工
                [[NSUserDefaults standardUserDefaults] setObject:KLogin forKey:KLoginWay];
            }else {
                // 访客
                [[NSUserDefaults standardUserDefaults] setObject:KAuthLoginMobile forKey:KLoginWay];
            }

            [kUserDefaults synchronize];
            
            [kNotificationCenter postNotificationName:UserbindSuccess object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    } failure:^(NSError *error) {
        [self hideHud];
        [self showHint:@"绑定失败!"];
    }];
}

- (void)endEditAction {
    [self.tableView endEditing:YES];
}

#pragma mark UItextField协议
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if(textField == _realNameTex){
        if (![_type isEqualToString:@"1"]) {
            _realNameBgView.hidden = NO;
            _realNameTex.layer.borderColor = [UIColor clearColor].CGColor;
            _phoneBgView.hidden = YES;
            _verCodeBgView.hidden = YES;
            _memberNumBgView.hidden = YES;
        }else{
            return NO;
        }
//        _companyBgView.hidden = YES;
//        _orgBgView.hidden = YES;
    }else if (textField == _phoneTex) {
        if (![_type isEqualToString:@"1"]) {
            _phoneBgView.hidden = NO;
            _phoneTex.layer.borderColor = [UIColor clearColor].CGColor;
            _memberNumBgView.hidden = YES;
            _realNameBgView.hidden = YES;
            _verCodeBgView.hidden = YES;
        }else{
            return NO;
        }
//        _companyBgView.hidden = YES;
//        _orgBgView.hidden = YES;
    }else if(textField == _verCodeTex){
        _verCodeBgView.hidden = NO;
        _verCodeTex.layer.borderColor = [UIColor clearColor].CGColor;
        _realNameBgView.hidden = YES;
        _phoneBgView.hidden = YES;
        _memberNumBgView.hidden = YES;
//        _companyBgView.hidden = YES;
//        _orgBgView.hidden = YES;
    }
    /*
    else if (textField == _companyTex) {
        _companyBgView.hidden = NO;
        _companyTex.layer.borderColor = [UIColor clearColor].CGColor;
        _memberNumBgView.hidden = YES;
        _orgBgView.hidden = YES;
        _phoneBgView.hidden = YES;
        _realNameBgView.hidden = YES;
        _verCodeBgView.hidden = YES;
    }else if (textField == _orgTex) {
        _orgBgView.hidden = NO;
        _orgTex.layer.borderColor = [UIColor clearColor].CGColor;
        _phoneBgView.hidden = YES;
        _companyBgView.hidden = YES;
        _memberNumBgView.hidden = YES;
        _realNameBgView.hidden = YES;
        _verCodeBgView.hidden = YES;
    }
     */
    else{
        _memberNumBgView.hidden = NO;
        _memberNumTex.layer.borderColor = [UIColor clearColor].CGColor;
        _realNameBgView.hidden = YES;
//        _orgBgView.hidden = YES;
//        _companyBgView.hidden = YES;
        _phoneBgView.hidden = YES;
        _verCodeBgView.hidden = YES;
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if(textField == _realNameTex){
        if (![_type isEqualToString:@"1"]) {
            _realNameBgView.hidden = YES;
            _realNameTex.layer.borderColor = [UIColor colorWithHexString:@"#d5d3d5"].CGColor;
        }
    }else if (textField == _phoneTex) {
        if (![_type isEqualToString:@"1"]) {
            _phoneBgView.hidden = YES;
            _phoneTex.layer.borderColor = [UIColor colorWithHexString:@"#d5d3d5"].CGColor;
        }
    }else if(textField == _verCodeTex){
        _verCodeBgView.hidden = YES;
        _verCodeTex.layer.borderColor = [UIColor colorWithHexString:@"#d5d3d5"].CGColor;
    }
    /*
    else if(textField == _companyTex){
        _companyBgView.hidden = YES;
        _companyTex.layer.borderColor = [UIColor colorWithHexString:@"#d5d3d5"].CGColor;
    }else if(textField == _orgTex){
        _orgBgView.hidden = YES;
        _orgTex.layer.borderColor = [UIColor colorWithHexString:@"#d5d3d5"].CGColor;
    }*/
    else{
        _memberNumBgView.hidden = YES;
        _memberNumTex.layer.borderColor = [UIColor colorWithHexString:@"#d5d3d5"].CGColor;
    }
    
    return YES;
}

-(void)textFiledChange:(NSNotification *)notification
{
    if ([_type isEqualToString:@"1"]) {
        _phoneTex.text = [kUserDefaults objectForKey:KUserPhoneNum];
        _realNameTex.text = [kUserDefaults objectForKey:KUserCustName];
    }
}
/*
#pragma mark 选择所在公司
-(void)companyTapAction
{
    [self.tableView endEditing:YES];
    _dateView.hidden = NO;
    _dataArr = _companyArr;
    _selectTex = _companyTex;
    [_companyPickView reloadAllComponents];
}

#pragma mark 选择所在部门
-(void)orgTapAction
{
    [self.tableView endEditing:YES];
    _dateView.hidden = NO;
    _dataArr = _orgArr;
    _selectTex = _orgTex;
    [_companyPickView reloadAllComponents];
}
*/
#pragma mark - Picker view data source

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return _dataArr.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return self.view.bounds.size.width;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    if (!view) {
        view = [[UIView alloc] init];
    }
    UILabel *textlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    textlabel.textAlignment = NSTextAlignmentCenter;
    textlabel.text = _dataArr[row];
    textlabel.font = [UIFont systemFontOfSize:19];
    [view addSubview:textlabel];
    return view;
}

// didSelectRow
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectIndex = row;
}
/*
// 取消
- (void)dateCancel {
    self.tableView.scrollEnabled = YES;
    _dateView.hidden = YES;
}

// 完成
- (void)dateDone {
    self.tableView.scrollEnabled = YES;
    _dateView.hidden = YES;
    _selectTex.text = _dataArr[selectIndex];
}
*/
-(void)dealloc
{
    [kNotificationCenter removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
