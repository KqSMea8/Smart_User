//
//  PayMentTableViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/19.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "PayMentTableViewController.h"
#import "PaySuccessTableViewController.h"
#import "PopView.h"
#import "FPayPwdTableViewController.h"
#import "SelectPayTypeView.h"
#import "PersonMsgModel.h"
#import "ChangePayPwdTableViewController.h"
#import "AESUtil.h"
#import "YQAlipayTool.h"
#import "NSString+category.h"

#import "BXTextField.h"

#define kMaxNumber 3

@interface PayMentTableViewController ()<DeclarePopViewDelegate,selectPayTypeDelegate,UIGestureRecognizerDelegate, UITextFieldDelegate>
{
    __weak IBOutlet UIImageView *headerView;
    __weak IBOutlet UILabel *nameLab;
    
    __weak IBOutlet BXTextField *moneyNumTex;
    __weak IBOutlet UIImageView *payTypeImgView;
    __weak IBOutlet UILabel *payTypeLab;
    __weak IBOutlet UIButton *payBtn;
    
    PopView *pView;
    NSString *_payType;
    
    NSString *moneyStr;
    SelectPayTypeView *tfSheetView;
    NSString *currentOrderId;
    
    UISwitch *_openSmallSwitch;
    __weak IBOutlet UILabel *balanceLab;
}

@property (nonatomic,assign) BOOL isHaveDian;

@end

@implementation PayMentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self _initNavItems];
    
    [self getBalance];
}

-(void)initView
{
    if([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KLogin]){
        _payType = @"03";
        payTypeLab.text = @"一卡通";
        payTypeImgView.image = [UIImage imageNamed:@"card_pay"];
    }else{
        _payType = @"02";
        payTypeLab.text = @"支付宝";
        payTypeImgView.image = [UIImage imageNamed:@"alipay"];
    }
    
    self.tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    payBtn.layer.cornerRadius = 6;
    payBtn.clipsToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tap.delegate = self;
    [self.tableView addGestureRecognizer:tap];
    
    //监听输入框编辑事件   限制输入长度
//    [moneyNumTex addTarget:self action:@selector(textFiledDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    moneyNumTex.delegate = self;
    [moneyNumTex becomeFirstResponder];
    
    [kNotificationCenter addObserver:self selector:@selector(alipaySuccess:) name:@"alipaySuccess" object:nil];
    [kNotificationCenter addObserver:self selector:@selector(alipayfa:) name:@"alipayfa" object:nil];
    [kNotificationCenter addObserver:self selector:@selector(alipayDidntFinsh:) name:@"alipayDidntFinsh" object:nil];
    [kNotificationCenter addObserver:self selector:@selector(alipayNetWor:) name:@"alipayNetWor" object:nil];
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {//判断如果点击的
        return NO;//关闭手势
    }//否则手势存在
    return YES;
}

-(void)tapAction:(id)sender
{
    [self.tableView endEditing:YES];
}

-(void)_initNavItems
{
    self.title = @"付款";
    
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
//    if (indexPath.row == 2) {
//        if ([[kUserDefaults objectForKey:KLoginWay] isEqualToString:KLogin]) {
//            [self getBalance];
//        }else{
//            tfSheetView = [[SelectPayTypeView alloc]init];
//            tfSheetView.delegate = self;
//            if ([_payType isEqualToString:@"03"]) {
//                tfSheetView.currentSelectIndex = 1;
//            }else if ([_payType isEqualToString:@"02"]){
//                tfSheetView.currentSelectIndex = 2;
//            }else{
//                tfSheetView.currentSelectIndex = 3;
//            }
//            tfSheetView.balanceStr = @"1";
//            [tfSheetView showInView:kAppWindow];
//        }
//
//    }
}

#pragma mark 获取账户余额
-(void)getBalance
{
    [self showHudInView:self.view hint:@""];
    
    NSString *custId = [kUserDefaults objectForKey:kCustId];
    NSString *urlStr = [NSString stringWithFormat:@"%@/rechargeOrder/getBalance",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:custId forKey:@"custId"];
    
    [[NetworkClient sharedInstance] GET:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            NSDictionary *dic = responseObject[@"responseData"];
            
            NSString *balance = dic[@"balance"];
            
            balance = [AESUtil decryptAES:balance key:AESKey];
            
            balanceLab.text = [NSString stringWithFormat:@"(%.2f元)",[balance floatValue]/100.00];
//            tfSheetView = [[SelectPayTypeView alloc]init];
//            tfSheetView.delegate = self;
//            if ([_payType isEqualToString:@"03"]) {
//                tfSheetView.currentSelectIndex = 1;
//            }else if ([_payType isEqualToString:@"02"]){
//                tfSheetView.currentSelectIndex = 2;
//            }else{
//                tfSheetView.currentSelectIndex = 3;
//            }
//            tfSheetView.balanceStr = [NSString stringWithFormat:@"一卡通(余额%.2f元)",[balance floatValue]/100];
//            [tfSheetView showInView:kAppWindow];
            
        }
    } failure:^(NSError *error) {
        [self hideHud];
    }];
}

- (IBAction)payBtnAction:(id)sender {
    if ([_payType isEqualToString:@"03"]) {
        //先检查是否设置支付密码
        if (moneyNumTex.text == nil||[moneyNumTex.text floatValue] <= 0) {
            [self showHint:@"请输入正确的金额!"];
            return;
        }
        [self getcustInfo];
    }else if ([_payType isEqualToString:@"02"]){
        [self showHint:@"敬请期待!"];
//        [self conPayAsAlipay];
    }else{
        [self showHint:@"敬请期待!"];
    }
}

- (void)declareAlertView:(PopView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
#pragma mark 付款接口
        if (alertView.type == payPwdPopView) {
            [alertView.importPwdTex resignFirstResponder];
            if (alertView.importPwdTex.text.length == 0) {
                [self showHint:@"请输入密码!"];
                return;
            }
            [self payMoney:alertView.importPwdTex.text];
        }else{
            [self setPayPwd];
        }
    }
}

-(void)forgetPwdClickAction
{
    [pView dismiss];
    
    FPayPwdTableViewController *fpayVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"FPayPwdTableViewController"];
    fpayVC.signStr = @"1";
    [self.navigationController pushViewController:fpayVC animated:YES];
}

-(void)currentSelectPayType:(payType)type
{
    if (type == cardpay) {
        payTypeLab.text = @"一卡通";
        payTypeImgView.image = [UIImage imageNamed:@"card_pay"];
        _payType = @"03";
    }else if (type == alipay){
        payTypeLab.text = @"支付宝";
        payTypeImgView.image = [UIImage imageNamed:@"alipay"];
        _payType = @"02";
    }else{
        payTypeLab.text = @"微信";
        payTypeImgView.image = [UIImage imageNamed:@"wechat"];
        _payType = @"01";
    }
}
#pragma mark 获取用户信息
-(void)getcustInfo
{
    NSString *custId = [[NSUserDefaults standardUserDefaults] objectForKey:kCustId];
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/getCustInfo", MainUrl];
    NSMutableDictionary *param = @{}.mutableCopy;
    if(![custId isKindOfClass:[NSNull class]]&&custId != nil){
        [param setObject:custId forKey:@"custId"];
    }
    
    [[NetworkClient sharedInstance] POST:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
        if([responseObject[@"code"] isEqualToString:@"1"]){
            PersonMsgModel *model = [[PersonMsgModel alloc] initWithDataDic:responseObject[@"responseData"]];
            
            if (model.PAY_PASSWD == nil || [model.PAY_PASSWD isKindOfClass:[NSNull class]]) {
                pView = [[PopView alloc] initWithTitle:@"支付密码设置" message:nil delegate:self leftButtonTitle:@"取消" rightButtonTitle:@"确认" type:setPayPwdPopView];
                if (![model.IS_SMALL_PAY isKindOfClass:[NSNull class]]&&model.IS_SMALL_PAY != nil&&[model.IS_SMALL_PAY isEqualToString:@"1"]) {
                    [kUserDefaults setBool:YES forKey:isAllowSmallPay];
                    pView.paySwitch.on = YES;
                }else{
                    [kUserDefaults setBool:NO forKey:isAllowSmallPay];
                    pView.paySwitch.on = NO;
                }
                [pView.payPwdTex becomeFirstResponder];
                pView.delegate = self;
                [pView show];
            }else{
                [kUserDefaults setBool:YES forKey:isSetPayPwd];
                [self checkSmallPay];
            }
            [kUserDefaults synchronize];
        }
    } failure:^(NSError *error) {
        YYReachability *rech = [YYReachability reachability];
        if (!rech.reachable) {
            [self showHint:@"网络不给力,请重试!"];
        }else{
            [self showHint:@"支付失败,请重试!"];
        }
    }];
}

#pragma mark 付款
-(void)payMoney:(NSString *)pwd
{
    [self showHudInView:self.view hint:@""];
    
    if (moneyNumTex.text == nil||[moneyNumTex.text floatValue] <= 0) {
        [self hideHud];
        [self showHint:@"请输入正确的金额!"];
        return;
    }
    
    NSString *custId = [kUserDefaults objectForKey:kCustId];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/consumeOrder/addConsumeSourceRecord",MainUrl];
    
    NSString *price = [NSString stringWithFormat:@"%.f",[moneyNumTex.text floatValue]*100];
    
    price = [AESUtil encryptAES:price key:AESKey];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    
    [params setObject:custId forKey:@"custId"];
    [params setObject:_payType forKey:@"payType"];
    [params setObject:price forKey:@"orderPirceEncrypt"];
    if ([pwd isEqualToString:@""]) {
        [params setObject:@"" forKey:@"payPassWd"];
    }else{
        [params setObject:[pwd md5String] forKey:@"payPassWd"];
    }
    [params setObject:_offerId forKey:@"offerId"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {

        [self hideHud];
        if (![responseObject[@"message"] isKindOfClass:[NSNull class]]) {
            [self showHint:responseObject[@"message"]];
        }
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            [pView dismiss];
            NSDictionary *dic = responseObject[@"responseData"];
        
            PaySuccessTableViewController *paySucVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"PaySuccessTableViewController"];
            paySucVC.orderId = dic[@"orderId"];
            [self.navigationController pushViewController:paySucVC animated:YES];
        }
    } failure:^(NSError *error) {
        [self hideHud];
        YYReachability *rech = [YYReachability reachability];
        if (!rech.reachable) {
            [self showHint:@"网络不给力,请重试!"];
        }else{
            [self showHint:@"支付失败,请重试!"];
        }
    }];
}

#pragma mark 设置支付密码
-(void)setPayPwd
{
    if (pView.payPwdTex.text == nil || pView.payPwdTex.text.length == 0) {
        [self showHint:@"请设置支付密码!"];
        return;
    }
    
    if (pView.payPwdTex.text.length < 6) {
        [self showHint:@"支付密码必须为6位数字!"];
        return;
    }
    
    if (pView.surePayPwdTex.text == nil || pView.surePayPwdTex.text.length == 0) {
        [self showHint:@"请确认支付密码!"];
        return;
    }
    if (![pView.payPwdTex.text isEqualToString:pView.surePayPwdTex.text]) {
        [self showHint:@"两次输入的密码不一致!"];
        return;
    }
    
    [self showHudInView:self.view hint:@""];
    
    NSString *custId = [kUserDefaults objectForKey:kCustId];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/payPassword",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:custId forKey:@"custId"];
    [params setObject:[pView.surePayPwdTex.text md5String] forKey:@"payPassword"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        [self showHint:responseObject[@"message"]];
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            [self payMoney:pView.surePayPwdTex.text];
            BOOL isButtonOn = [_openSmallSwitch isOn];
            if (isButtonOn) {
                [self openSmallPayAction];
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

#pragma mark 检查是否满足小额支付条件
-(void)checkSmallPay
{
    [self showHudInView:self.view hint:@""];
    
    NSString *custId = [kUserDefaults objectForKey:kCustId];
    
    NSString *price = [NSString stringWithFormat:@"%.f",[moneyNumTex.text floatValue]*100];
    price = [AESUtil encryptAES:price key:AESKey];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/consumeOrder/chcekCustInfoForConsume",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:custId forKey:@"custId"];
    [params setObject:price forKey:@"conOrderPrice"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            NSDictionary *dic = responseObject[@"responseData"];
            if (![dic[@"canSmalPay"] isKindOfClass:[NSNull class]]) {
                NSString *canSmalPay = dic[@"canSmalPay"];
                NSString *isSmallPay = dic[@"isSmalPay"];
                if ([canSmalPay isEqualToString:@"1"]) {
                    if (![isSmallPay isKindOfClass:[NSNull class]]&&isSmallPay != nil&&[isSmallPay isEqualToString:@"1"]) {
                        [self payMoney:@""];
                    }else{
                        pView = [[PopView alloc] initWithTitle:@"支付密码" message:nil delegate:self leftButtonTitle:@"取消" rightButtonTitle:@"确认" type:payPwdPopView];
                        [pView.importPwdTex becomeFirstResponder];
                        pView.delegate = self;
                        [pView show];
                    }
                }else{
                    pView = [[PopView alloc] initWithTitle:@"支付密码" message:nil delegate:self leftButtonTitle:@"取消" rightButtonTitle:@"确认" type:payPwdPopView];
                    [pView.importPwdTex becomeFirstResponder];
                    pView.delegate = self;
                    [pView show];
                }
            }
        }
    } failure:^(NSError *error) {
        [self hideHud];
    }];
}

#pragma mark 开关小额支付
-(void)openSmallPaySwtichAction:(UISwitch *)statusSwitch
{
    _openSmallSwitch = statusSwitch;
}

#pragma mark 开关小额支付
-(void)openSmallPayAction
{
    BOOL isButtonOn = [_openSmallSwitch isOn];
    
//    BOOL setPayPwd = [kUserDefaults boolForKey:isSetPayPwd];
//    if (!setPayPwd) {
//        _openSmallSwitch.on = NO;
//        [self showHint:@"请先设置支付密码!"];
//        return;
//    }
    
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
        
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            
            if (isButtonOn) {
                _openSmallSwitch.on = YES;
                [kUserDefaults setBool:YES forKey:isAllowSmallPay];
            }else {
                _openSmallSwitch.on = NO;
                [kUserDefaults setBool:NO forKey:isAllowSmallPay];
            }
        }
    } failure:^(NSError *error) {
        if (isButtonOn) {
            _openSmallSwitch.on = NO;
        }else {
            _openSmallSwitch.on = YES;
        }
    }];
}

#pragma mark 支付宝支付
-(void)conPayAsAlipay
{
    [self showHudInView:self.view hint:@""];
    
    NSString *custId = [kUserDefaults objectForKey:kCustId];
    
    NSString *price = [NSString stringWithFormat:@"%.f",[moneyNumTex.text floatValue]*100];
    
    price = [AESUtil encryptAES:price key:AESKey];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/consumeOrder/addConsumeSourceRecordForAlipay",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:custId forKey:@"custId"];
    [params setObject:@"02" forKey:@"payType"];
    [params setObject:price forKey:@"orderPirceEncrypt"];
    [params setObject:_offerId forKey:@"offerId"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            
            NSDictionary *dic = responseObject[@"responseData"];
            NSString *orderId = dic[@"orderId"];
            currentOrderId = orderId;
            [YQAlipayTool aliPayWithOrderId:orderId withComplete:^(NSString *stateCode) {
                [self hideHud];
                if([stateCode isEqualToString:@"6001"]){
                    [self showHint:@"您取消了支付"];
                }
            } type:@"0"];
        }
    } failure:^(NSError *error) {
        [self hideHud];
    }];
}

-(void)alipaySuccess:(NSNotification *)notification
{
    PaySuccessTableViewController *paySuccessVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"PaySuccessTableViewController"];
    paySuccessVC.orderId = currentOrderId;
    [self.navigationController pushViewController:paySuccessVC animated:YES];
}

-(void)alipayfa:(NSNotification *)notification
{
    [self showHint:@"订单支付失败"];
}

-(void)alipayDidntFinsh:(NSNotification *)notification
{
    [self showHint:@"您取消了支付"];
}

-(void)alipayNetWor:(NSNotification *)notification
{
    [self showHint:@"网络连接出错"];
}

-(void)setOfferId:(NSString *)offerId
{
    _offerId = offerId;
}

/*
- (void)textFiledDidChange:(UITextField *)textField
{
    if (kMaxNumber == 0) return;
    NSString *toBeString = textField.text;
    
    NSString *lang = [[textField textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        //判断markedTextRange是不是为Nil，如果为Nil的话就说明你现在没有未选中的字符
        //可以计算文字长度。否则此时计算出来的字符长度可能不正确
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分(感觉输入中文的时候才有)
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            //中文和字符一起检测  中文是两个字符
            if ([toBeString getStringLenthOfBytes] > kMaxNumber)
            {
                textField.text = [toBeString subBytesOfstringToIndex:kMaxNumber];
            }
        }
    }
    else
    {
        if ([toBeString getStringLenthOfBytes] > kMaxNumber)
        {
            textField.text = [toBeString subBytesOfstringToIndex:kMaxNumber];
        }
    }
}
 */

#pragma mark UITextField 协议
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == moneyNumTex) {
        NSScanner      *scanner    = [NSScanner scannerWithString:string];
        NSCharacterSet *numbers;
        NSRange         pointRange = [textField.text rangeOfString:@"."];
        
        if ((pointRange.length > 0) && (pointRange.location < range.location  || pointRange.location > range.location + range.length)) {
            numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        } else {
            numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
        }
        
        if ([textField.text isEqualToString:@""] && [string isEqualToString:@"."] ) {
            return NO;
        }
        
        short remain = 2; //默认保留2位小数
        
        NSString *tempStr = [textField.text stringByAppendingString:string];
        // 原来的字符+当前输入的字符
        NSUInteger strlen = [tempStr length];
        if(pointRange.length > 0 && pointRange.location > 0) {
            //判断输入框内是否含有“.”。
            if([string isEqualToString:@"."]) {
                //当输入框内已经含有“.”时，如果再输入“.”则被视为无效。
                return NO;
            }
            if(strlen > 0 && (strlen - pointRange.location) > remain+1) {
                //当输入框内已经含有“.”，当字符串长度减去小数点前面的字符串长度大于需要要保留的小数点位数，则视当次输入无效。
                return NO;
            }
        }
        
        NSRange zeroRange = [textField.text rangeOfString:@"0"];
        if(zeroRange.length == 1 && zeroRange.location == 0){
            //判断输入框第一个字符是否为“0”
            if(![string isEqualToString:@"0"] && ![string isEqualToString:@"."] && [textField.text length] == 1){
                //当输入框只有一个字符并且字符为“0”时，再输入不为“0”或者“.”的字符时，则将此输入替换输入框的这唯一字符。
                textField.text = string;
                return NO;
            }else{
                if(pointRange.length == 0 && pointRange.location > 0){
                    //当输入框第一个字符为“0”时，并且没有“.”字符时，如果当此输入的字符为“0”，则视当此输入无效。
                    if([string isEqualToString:@"0"]){
                        return NO;
                    }
                }
            }
        }
        
        NSString *buffer;
        if ( ![scanner scanCharactersFromSet:numbers intoString:&buffer] && ([string length] != 0) )
        {
            return NO;
        }
        // 大于1000的时候不能再编辑
        if ([tempStr longLongValue] >= 1001) {
            return NO;
        }
    }
    return YES;
}

-(void)dealloc
{
    [kNotificationCenter removeObserver:self name:@"alipaySuccess" object:nil];
    [kNotificationCenter removeObserver:self name:@"alipayDidntFinsh" object:nil];
    [kNotificationCenter removeObserver:self name:@"alipayNetWor" object:nil];
    [kNotificationCenter removeObserver:self name:@"alipayfa" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
