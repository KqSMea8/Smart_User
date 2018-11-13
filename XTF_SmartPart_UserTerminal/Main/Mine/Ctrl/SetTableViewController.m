//
//  SetTableViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/3.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "SetTableViewController.h"
#import "PwdSetTableViewController.h"
#import "AboutViewController.h"
#import "LoginViewController.h"
#import "BindTableViewController.h"
#import "PopView.h"
#import "PublicModel.h"
#import "FPayPwdTableViewController.h"
#import "ChangePhoneViewController.h"

@interface SetTableViewController ()<DeclarePopViewDelegate,UIAlertViewDelegate>
{
    
    __weak IBOutlet UISwitch *SmallPaySwitch;
    
    __weak IBOutlet UILabel *_cacheSizeLab;
    
    __weak IBOutlet UIView *remaindView;
    PopView *pView;
    
    NSString *isNeedUpdate;
    
    PublicModel *_model;
}

@property (weak, nonatomic) IBOutlet UIButton *loginOutBtn;

@end

@implementation SetTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initNavItems];
    
    [self _initView];
    
    [self queryCache];

}

-(void)_initNavItems
{
    self.title = @"设置";
    
    UIButton *leftBtn = [[UIButton alloc] init];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [leftBtn setImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(_leftBarBtnItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)_leftBarBtnItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self showVersionAlert];
}

- (void)showVersionAlert {
    
    NSString *appVersionPath = [[NSBundle mainBundle] pathForResource:@"appVersion" ofType:@"plist"];
    NSDictionary *appVersionDic = [NSDictionary dictionaryWithContentsOfFile:appVersionPath];
    NSString *appVersion = appVersionDic[@"appVersion"];
    NSString *userName = [kUserDefaults objectForKey:KUserCustName];
    NSString *versionUrl;
    if ([userName isKindOfClass:[NSNull class]]||userName == nil) {
        versionUrl = [NSString stringWithFormat:@"%@/public/getVersion?appType=user&osType=ios&version=%@", MainUrl,appVersion];
    }else{
        versionUrl = [NSString stringWithFormat:@"%@/public/getVersion?appType=user&osType=ios&versionCust=%@&version=%@", MainUrl,userName,appVersion];
    }
    [[NetworkClient sharedInstance] GET:versionUrl dict:nil progressFloat:nil succeed:^(id responseObject) {
        if([responseObject[@"code"] isEqualToString:@"1"]){
            NSDictionary *responseData = responseObject[@"responseData"];
            if(responseData == nil || [responseData isKindOfClass:[NSNull class]]){
                return ;
            }
            PublicModel *model = [[PublicModel alloc] initWithDataDic:responseData];
            
            _model = model;
            
            if(![model.appCode isKindOfClass:[NSNull class]] && model.appCode != nil && model.appCode.integerValue > appVersion.integerValue){
                BOOL isNeedRemain = [kUserDefaults boolForKey:KNeedRemain];
                if (isNeedRemain) {
                    remaindView.hidden = NO;
                    remaindView.layer.cornerRadius = 4;
                    remaindView.clipsToBounds = YES;
                    isNeedUpdate = @"1";
                }else{
                    remaindView.hidden = YES;
                    remaindView.layer.cornerRadius = 4;
                    remaindView.clipsToBounds = YES;
                    isNeedUpdate = @"1";
                }
                
            }else{
                remaindView.hidden = YES;
                isNeedUpdate = @"0";
            }
        }
    } failure:^(NSError *error) {
        
    }];
}


-(void)_initView
{
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    self.tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    
    _loginOutBtn.layer.cornerRadius = 4;
    _loginOutBtn.layer.borderWidth = 0.5;
    _loginOutBtn.layer.borderColor = [UIColor colorWithHexString:@"#6E6E6E"].CGColor;
    
    if ([kUserDefaults boolForKey:isAllowSmallPay]) {
        SmallPaySwitch.on = YES;
    }else{
        SmallPaySwitch.on = NO;
    }
    
    [SmallPaySwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    if (indexPath.row == 0) {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KAuthLogin]) {

            height = 0.01;
        }else{
            height = 60;
        }
    }else if(indexPath.row == 1){
        if([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KAuthLogin]||[[kUserDefaults objectForKey:KLoginWay] isEqualToString:KAuthLoginMobile]) {
            height = 0.01;
        }else{
            height = 60;
        }
    }else if (indexPath.row == 2){
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KAuthLoginMobile]) {
            height = 60;
        }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KAuthLogin]) {
            height = 0.01;
        }else{
            height = 60;
        }
    }else{
        height = 60;
    }
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if ([[kUserDefaults objectForKey:KLoginWay] isEqualToString:KLogin]||[[kUserDefaults objectForKey:KLoginWay] isEqualToString:KAuthLoginMobile]) {
            PwdSetTableViewController *pwdSetVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"PwdSetTableViewController"];
            [self.navigationController pushViewController:pwdSetVC animated:YES];
        }else
        {
            BindTableViewController *bindVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"BindTableViewController"];
            [self.navigationController pushViewController:bindVC animated:YES];
        }
    }else if (indexPath.row == 1)
    {
        
    }else if (indexPath.row == 2)
    {
        ChangePhoneViewController *cPhoneVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"ChangePhoneViewController"];
        [self.navigationController pushViewController:cPhoneVC animated:YES];
    }else if (indexPath.row == 3)
    {
        
        UIAlertView *remainInstall = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要清除所有缓存数据吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        remainInstall.delegate = self;
        [remainInstall show];
    
    }else
    {
        AboutViewController *aboutVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"AboutViewController"];
        aboutVC.isNeedUpdate = isNeedUpdate;
        aboutVC.model = _model;
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
}

- (IBAction)loginOutBtnAction:(id)sender {
    
    [kUserDefaults removeObjectForKey:KLoginStatus];
    [kUserDefaults removeObjectForKey:KUserCertId];
    [kUserDefaults removeObjectForKey:KAuthLogin];
    [kUserDefaults removeObjectForKey:KAuthType];
    [kUserDefaults removeObjectForKey:KAuthId];
    [kUserDefaults removeObjectForKey:KLoginWay];
    [kUserDefaults removeObjectForKey:kCustId];
    [kUserDefaults removeObjectForKey:KMemberId];
    [kUserDefaults removeObjectForKey:KUserCustName];
    [kUserDefaults removeObjectForKey:KAuthName];
    [kUserDefaults removeObjectForKey:KUserPhoneNum];
    [kUserDefaults removeObjectForKey:KLoginPasword];
    [kUserDefaults removeObjectForKey:KFACE_IMAGE_ID];
    [kUserDefaults removeObjectForKey:kUserLoginToken];
    [kUserDefaults removeObjectForKey:isBindCar];
    [kUserDefaults removeObjectForKey:companyID];
    [kUserDefaults removeObjectForKey:OrgId];
    [kUserDefaults removeObjectForKey:kUserBirthDay];
    [kUserDefaults removeObjectForKey:KUserSex];
    
    UINavigationController *navVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginNavViewController"];
    [UIApplication sharedApplication].delegate.window.rootViewController = navVC;
}

#pragma mark 开关小额支付
-(void)switchAction:(id)sender{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    
    YYReachability *rech = [YYReachability reachability];
    if (!rech.reachable) {
        if (isButtonOn) {
            switchButton.on = NO;
            
        }else {
            switchButton.on = YES;
            
        }
        [self showHint:@"网络不给力,请重试!"];
        return;
    }
    
    BOOL setPayPwd = [kUserDefaults boolForKey:isSetPayPwd];
    if (setPayPwd) {
        if (!isButtonOn) {
            [self changeSwitchStatus:isButtonOn yqswitch:switchButton];
        }else{
            [self checkPayPwd];
        }
    }else{
        [self showHint:@"请先设置支付密码!"];
        switchButton.on = NO;
    }
}

-(void)checkPayPwd
{
    pView = [[PopView alloc] initWithTitle:@"验证支付密码" message:nil delegate:self leftButtonTitle:@"取消" rightButtonTitle:@"确认" type:verPayPwdPopView];
    pView.delegate = self;
    [pView.importPwdTex becomeFirstResponder];
    [pView show];
}

-(void)forgetPwdClickAction
{
    SmallPaySwitch.on = NO;
    [pView dismiss];
    
    FPayPwdTableViewController *fpayVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"FPayPwdTableViewController"];
    fpayVC.signStr = @"2";
    [self.navigationController pushViewController:fpayVC animated:YES];
}

-(void)declareAlertView:(PopView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self checkPayPwdAction];
    }else{
        SmallPaySwitch.on = NO;
    }
}

-(void)changeSwitchStatus:(BOOL)isButtonOn yqswitch:(UISwitch *)switchButton
{
    [self showHudInView:self.view hint:@""];
    
    NSString *custId = [kUserDefaults objectForKey:kCustId];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/smallPay",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:custId forKey:@"custId"];
    if (isButtonOn) {
        [params setObject:@"1" forKey:@"isSmallPay"];
    }else {
        [params setObject:@"0" forKey:@"isSmallPay"];
    }
    
    [[NetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        
        if (![responseObject[@"message"] isKindOfClass:[NSNull class]]&&responseObject[@"message"]!=nil) {
            [self showHint:responseObject[@"message"]];
        }
        [pView dismiss];
        
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            
            if (isButtonOn) {
                switchButton.on = YES;
                [kUserDefaults setBool:YES forKey:isAllowSmallPay];
            }else {
                switchButton.on = NO;
                [kUserDefaults setBool:NO forKey:isAllowSmallPay];
            }
        }
    } failure:^(NSError *error) {
        [self hideHud];
        [pView dismiss];
        if (isButtonOn) {
            switchButton.on = NO;
        }else {
            switchButton.on = YES;
        }
        YYReachability *rech = [YYReachability reachability];
        if (!rech.reachable) {
            [self showHint:@"网络不给力,请重试!"];
        }else{
            [self showHint:@"开启失败,请重试!"];
        }
        
    }];

}

-(void)checkPayPwdAction
{
    [self showHudInView:self.view hint:@""];
    
    BOOL isButtonOn = SmallPaySwitch.on;
    NSString *pwd = pView.importPwdTex.text;
    
    if (pwd == nil||pwd.length == 0) {
        [self hideHud];
        if (isButtonOn) {
            SmallPaySwitch.on = YES;
        }else {
            SmallPaySwitch.on = NO;
        }
        [self showHint:@"请输入支付密码!"];
        return;
    }
    
    NSString *custId = [kUserDefaults objectForKey:kCustId];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/checkPayPassword",MainUrl];

    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:custId forKey:@"custId"];
    [params setObject:[pView.importPwdTex.text md5String] forKey:@"payPassword"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        [self showHint:responseObject[@"message"]];
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            [self changeSwitchStatus:YES yqswitch:SmallPaySwitch];
        }else{
            SmallPaySwitch.on = NO;
        }
    } failure:^(NSError *error) {
        [self hideHud];
        [pView dismiss];
        
        if (isButtonOn) {
            SmallPaySwitch.on = NO;
        }else {
            SmallPaySwitch.on = YES;
        }
        YYReachability *rech = [YYReachability reachability];
        if (!rech.reachable) {
            [self showHint:@"网络不给力,请重试!"];
        }else{
            [self showHint:@"开启失败,请重试!"];
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // 清除缓存
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            [self showHint:@"缓存已清除"];
            _cacheSizeLab.text = @"0.00K";
        }];
    }
}

#pragma mark 计算缓存
- (void)queryCache {
    float allCache = [self caculateCache];
    NSString *clearCacheName = allCache >= 1 ? [NSString stringWithFormat:@"%.2fM",allCache] : [NSString stringWithFormat:@"%.2fK",allCache * 1024];
    _cacheSizeLab.text = clearCacheName;
}

- (float)caculateCache {
    float SDTmpCache = [[SDImageCache sharedImageCache] getSize]/(1024*1024.2f);
    
    return SDTmpCache;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
