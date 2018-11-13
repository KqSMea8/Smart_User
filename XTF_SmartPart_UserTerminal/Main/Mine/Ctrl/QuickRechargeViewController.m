//
//  QuickRechargeViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/5.
//  Copyright © 2017年 焦平. All rights reserved.
//

typedef enum {
    aliPay = 0,
    wechatPay,
    bankPay
}PayType;

#import "QuickRechargeViewController.h"

#import "RechageSuccseViewController.h"
#import "YQAlipayTool.h"
#import <WXApi.h>
#import "YQWechatPayTool.h"
#import "RechageModel.h"
#import "BillsViewController.h"
#import "ECardViewController.h"
#import "AESUtil.h"

@interface QuickRechargeViewController ()
{
    // 充值金额
    NSString *_topupNum;
    // 支付方式
    PayType _payType;
    
    RechageModel *_rechageModel;
    NSString *_currentOrderID;
}

@property (weak, nonatomic) IBOutlet UILabel *balanceLab;

@property (weak, nonatomic) IBOutlet UIButton *num20Btn;
@property (weak, nonatomic) IBOutlet UIButton *num50Btn;
@property (weak, nonatomic) IBOutlet UIButton *num100Btn;
@property (weak, nonatomic) IBOutlet UIButton *num150Btn;
@property (weak, nonatomic) IBOutlet UIButton *num200Btn;
@property (weak, nonatomic) IBOutlet UIButton *num300Btn;

@property (weak, nonatomic) IBOutlet UIView *alipayBgView;
@property (weak, nonatomic) IBOutlet UIView *wechatBgView;
@property (weak, nonatomic) IBOutlet UIView *bankcardBgView;

@property (weak, nonatomic) IBOutlet UILabel *alipayLab;
@property (weak, nonatomic) IBOutlet UILabel *wechatLab;
@property (weak, nonatomic) IBOutlet UILabel *bankcardLab;

@property (weak, nonatomic) IBOutlet UIButton *confirmRechageBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *midHeight;

@end

@implementation QuickRechargeViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self _loadBalanceData];
}

#pragma mark 获取用户账户余额
-(void)_loadBalanceData
{
    NSString *custId = [kUserDefaults objectForKey:kCustId];
    NSString *urlStr = [NSString stringWithFormat:@"%@/rechargeOrder/getBalance",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:custId forKey:@"custId"];
    
    [[NetworkClient sharedInstance] GET:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            NSDictionary *dic = responseObject[@"responseData"];
            
            NSString *balance = dic[@"balance"];
            
            balance = [AESUtil decryptAES:balance key:AESKey];
            
            _balanceLab.text = [NSString stringWithFormat:@"%.2f元",[balance floatValue]/100.00];
        }
    } failure:^(NSError *error) {
        DLog(@"%@",error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _initView];
    
    [self _initNavItems];
}

-(void)_initView
{
    
    [kNotificationCenter addObserver:self selector:@selector(alipaySuccess:) name:@"alipaySuccess" object:nil];
    [kNotificationCenter addObserver:self selector:@selector(alipayfa:) name:@"alipayfa" object:nil];
    [kNotificationCenter addObserver:self selector:@selector(alipayDidntFinsh:) name:@"alipayDidntFinsh" object:nil];
    [kNotificationCenter addObserver:self selector:@selector(alipayNetWor:) name:@"alipayNetWor" object:nil];
    
    _topupNum = @"100";
    _topupNum = [NSString stringWithFormat:@"%.f",[_topupNum floatValue]*100];
    _topupNum = [AESUtil encryptAES:_topupNum key:AESKey];
    
    _bankcardBgView.hidden = YES;
    _bankcardLab.hidden = YES;
    _topHeight.constant = _topHeight.constant * hScale;
    _midHeight.constant = _midHeight.constant * hScale;
    
//    self.confirmRechageBtn.layer.cornerRadius = 4;
//    self.confirmRechageBtn.clipsToBounds = YES;
    self.confirmRechageBtn.backgroundColor = [UIColor colorWithHexString:@"#1B82D1"];
    
    NSArray *numBts = @[_num20Btn, _num50Btn, _num100Btn, _num150Btn, _num200Btn, _num300Btn];
    [numBts enumerateObjectsUsingBlock:^(UIButton *numBt, NSUInteger idx, BOOL * _Nonnull stop) {
        numBt.layer.borderWidth = 1;
        if(idx == 0){
            numBt.layer.borderColor = [UIColor colorWithHexString:@"#00C5BF"].CGColor;
            [numBt setTitleColor:[UIColor colorWithHexString:@"#00C5BF"] forState:UIControlStateNormal];
        }else {
            numBt.layer.borderColor = [UIColor colorWithHexString:@"#B9C9C6"].CGColor;
            [numBt setTitleColor:[UIColor colorWithHexString:@"#B9C9C6"] forState:UIControlStateNormal];
        }
        numBt.layer.masksToBounds = YES;
        numBt.layer.cornerRadius = 3;
        
        numBt.tag = 100 + idx;
        [numBt addTarget:self action:@selector(selectNum:) forControlEvents:UIControlEventTouchUpInside];
    }];
    
    NSArray *payViews = @[_alipayBgView, _wechatBgView, _bankcardBgView];
    [payViews enumerateObjectsUsingBlock:^(UIView *payView, NSUInteger idx, BOOL * _Nonnull stop) {
        payView.tag = 200 + idx;
        
        if(idx == 0){
            payView.layer.borderWidth = 1.5;
            payView.layer.borderColor = [UIColor colorWithHexString:@"#00C5BF"].CGColor;
        }else {
            payView.layer.borderWidth = 1;
            payView.layer.borderColor = [UIColor colorWithHexString:@"#B9C9C6"].CGColor;
        }
        payView.layer.masksToBounds = YES;
        payView.layer.cornerRadius = 2;
        
        UITapGestureRecognizer *selPayTypeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selPayType:)];
        payView.userInteractionEnabled = YES;
        [payView addGestureRecognizer:selPayTypeTap];
    }];
    
    NSArray *payLabels = @[_alipayLab, _wechatLab, _bankcardLab];
    [payLabels enumerateObjectsUsingBlock:^(UILabel *payLabel, NSUInteger idx, BOOL * _Nonnull stop) {
        if(idx == 0){
            payLabel.textColor = [UIColor blackColor];
        }else {
            payLabel.textColor = [UIColor colorWithHexString:@"#708382"];
        }
    }];
}

#pragma mark 选择金额
- (void)selectNum:(UIButton *)numBt {
    switch (numBt.tag - 100) {
        case 0:
            _topupNum = @"100";
            _topupNum = [NSString stringWithFormat:@"%.f",[_topupNum floatValue]*100];
            _topupNum = [AESUtil encryptAES:_topupNum key:AESKey];
            [self changeBtState:numBt];
            break;
            
        case 1:
            _topupNum = @"200";
            _topupNum = [NSString stringWithFormat:@"%.f",[_topupNum floatValue]*100];
            _topupNum = [AESUtil encryptAES:_topupNum key:AESKey];
            [self changeBtState:numBt];
            break;
            
        case 2:
            _topupNum = @"300";
            _topupNum = [NSString stringWithFormat:@"%.f",[_topupNum floatValue]*100];
            _topupNum = [AESUtil encryptAES:_topupNum key:AESKey];
            [self changeBtState:numBt];
            break;
            
        case 3:
            _topupNum = @"400";
            _topupNum = [NSString stringWithFormat:@"%.f",[_topupNum floatValue]*100];
            _topupNum = [AESUtil encryptAES:_topupNum key:AESKey];
            [self changeBtState:numBt];
            break;
            
        case 4:
            _topupNum = @"500";
            _topupNum = [NSString stringWithFormat:@"%.f",[_topupNum floatValue]*100];
            _topupNum = [AESUtil encryptAES:_topupNum key:AESKey];
            [self changeBtState:numBt];
            break;
            
        case 5:
            _topupNum = @"600";
            _topupNum = [NSString stringWithFormat:@"%.f",[_topupNum floatValue]*100];
            _topupNum = [AESUtil encryptAES:_topupNum key:AESKey];
            [self changeBtState:numBt];
            break;
            
    }
}

- (void)changeBtState:(UIButton *)selBt {
    NSArray *numBts = @[_num20Btn, _num50Btn, _num100Btn, _num150Btn, _num200Btn, _num300Btn];
    [numBts enumerateObjectsUsingBlock:^(UIButton *numBt, NSUInteger idx, BOOL * _Nonnull stop) {
        numBt.layer.borderColor = [UIColor colorWithHexString:@"#B9C9C6"].CGColor;
        [numBt setTitleColor:[UIColor colorWithHexString:@"#B9C9C6"] forState:UIControlStateNormal];
    }];
    
    selBt.layer.borderColor = [UIColor colorWithHexString:@"#00C5BF"].CGColor;
    [selBt setTitleColor:[UIColor colorWithHexString:@"#00C5BF"] forState:UIControlStateNormal];
}

#pragma mark 选支付方式
- (void)selPayType:(UITapGestureRecognizer *)tapGestureRecognizer {
    switch (tapGestureRecognizer.view.tag - 200) {
        case 0:
            _payType = aliPay;
            [self returnPayState];
            _alipayBgView.layer.borderColor = [UIColor colorWithHexString:@"#00C5BF"].CGColor;
            _alipayBgView.layer.borderWidth = 1.5;
            _alipayLab.textColor = [UIColor blackColor];
            break;
            
        case 1:
            _payType = wechatPay;
            [self returnPayState];
            _wechatBgView.layer.borderColor = [UIColor colorWithHexString:@"#00C5BF"].CGColor;
            _wechatBgView.layer.borderWidth = 1.5;
            _wechatLab.textColor = [UIColor blackColor];
            break;
            
        case 2:
            _payType = bankPay;
            [self returnPayState];
            _bankcardBgView.layer.borderColor = [UIColor colorWithHexString:@"#00C5BF"].CGColor;
            _bankcardBgView.layer.borderWidth = 1.5;
            _bankcardLab.textColor = [UIColor blackColor];
            break;
    }
}

- (void)returnPayState {
    NSArray *payViews = @[_alipayBgView, _wechatBgView, _bankcardBgView];
    [payViews enumerateObjectsUsingBlock:^(UIView *payView, NSUInteger idx, BOOL * _Nonnull stop) {
        payView.layer.borderColor = [UIColor colorWithHexString:@"#B9C9C6"].CGColor;
        payView.layer.borderWidth = 1;
    }];
    
    NSArray *payLabels = @[_alipayLab, _wechatLab, _bankcardLab];
    [payLabels enumerateObjectsUsingBlock:^(UILabel *payLabel, NSUInteger idx, BOOL * _Nonnull stop) {
        payLabel.textColor = [UIColor colorWithHexString:@"#708382"];
    }];
}

-(void)setTitleStr:(NSString *)titleStr
{
    _titleStr = titleStr;
}

-(void)_initNavItems
{
    self.title = _titleStr;
    
    UIButton *leftBtn = [[UIButton alloc] init];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [leftBtn setImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(_leftBarBtnItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *rightBtn = [[UIButton alloc] init];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [rightBtn setImage:[UIImage imageNamed:@"slide"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(_rightBarBtnItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)_leftBarBtnItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)_rightBarBtnItemClick
{
//    BillsViewController *billsVC = [[BillsViewController alloc] init];
//    [self.navigationController pushViewController:billsVC animated:YES];
    ECardViewController *eCardVC = [[ECardViewController alloc] init];
    eCardVC.title = @"账单明细";
    [self.navigationController pushViewController:eCardVC animated:YES];
}

- (IBAction)confirmRechageBtnAction:(id)sender {
    
    [self showHudInView:self.view hint:@""];
    
    [self hideHud];
    [self showHint:@"敬请期待!"];
    return;
    
//    _topupNum = @"0.1";
//    _topupNum = [NSString stringWithFormat:@"%.f",[_topupNum floatValue]*100];
//    _topupNum = [AESUtil encryptAES:_topupNum key:AESKey];
    
    NSString *custId = [kUserDefaults objectForKey:kCustId];
    
    NSString *topupUrl = [NSString stringWithFormat:@"%@/rechargeOrder/addRchargeOrder",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:custId forKey:@"custId"];
    [params setObject:_topupNum forKey:@"orderTotalPriceForEncrypt"];
    [params setObject:@"01" forKey:@"orderStatus"];
    if (_payType == aliPay) {
        [params setObject:@"02" forKey:@"orderPayType"];
    }else{
        [params setObject:@"01" forKey:@"orderPayType"];
    }
    //生成订单号
    [[NetworkClient sharedInstance] POST:topupUrl dict:params progressFloat:nil succeed:^(id responseObject) {

        [self hideHud];
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            NSDictionary *dic = responseObject[@"responseData"];
            NSDictionary *dataDic = dic[@"orderInfo"];
            NSString *orderId = dataDic[@"orderId"];
            _currentOrderID = orderId;
            if (_payType == aliPay) {
                
                [YQAlipayTool aliPayWithOrderId:orderId withComplete:^(NSString *stateCode) {
                    [self hideHud];
                    if([stateCode isEqualToString:@"6001"]){
                        [self showHint:@"您取消了支付"];
                    }
                } type:@"1"];

            }else{
                [self showHint:@"敬请期待!"];
                /*
                if([WXApi isWXAppInstalled]){
                    [YQWechatPayTool weChatPayWithOrderId:orderId];
                }else {
                    [self hideHud];
                    [self showHint:@"未安装微信应用"];
                }
                 */
            }
        }
    } failure:^(NSError *error) {
        DLog(@"%@",error);
        [self hideHud];
    }];
}

-(void)alipaySuccess:(NSNotification *)notification
{
    RechageSuccseViewController *reVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"RechageSuccseViewController"];
    reVC.orderId = _currentOrderID;
    [self.navigationController pushViewController:reVC animated:YES];
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

-(void)dealloc
{
    [kNotificationCenter removeObserver:self name:@"alipaySuccess" object:nil];
    [kNotificationCenter removeObserver:self name:@"alipayDidntFinsh" object:nil];
    [kNotificationCenter removeObserver:self name:@"alipayNetWor" object:nil];
    [kNotificationCenter removeObserver:self name:@"alipayfa" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
