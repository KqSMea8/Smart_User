//
//  BillDetailsViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/6.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "BillDetailsViewController.h"
#import "AESUtil.h"

#define weChatIcon @"icon_bill_wechat"
#define aliIcon @"icon_bill_ali"
#define vipIcon @"icon_bill_vip"
#define parkIcon @"icon_funts_parking"

@interface BillDetailsViewController ()
{
    
    __weak IBOutlet UIView *topBgView;
    __weak IBOutlet UIImageView *payTypeView;
    __weak IBOutlet UILabel *rechageTyoe;
    
    __weak IBOutlet UILabel *moneyNumLab;
    __weak IBOutlet UILabel *orderIdLab;
    __weak IBOutlet UILabel *orderPayTimeLab;
    
    __weak IBOutlet UIView *_managementValueView;
    __weak IBOutlet UILabel *_noteLabel;
}

@end

@implementation BillDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initView];
    
    [self _initNavItems];
    
    [self _loadData];
}

-(void)_initNavItems
{
    self.title = @"账单详情";
    
    UIButton *leftBtn = [[UIButton alloc] init];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [leftBtn setImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(_leftBarBtnItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)_initView {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    if(_Base_ManMoney == nil){
        _managementValueView.hidden = YES;
    }else {
        _managementValueView.hidden = NO;
    }
}
- (void)_leftBarBtnItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)_loadData
{
    [self showHudInView:self.view hint:@"加载中~"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/rechargeOrder/getorderDetails",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:_orderId forKey:@"orderId"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
//        DLog(@"%@",responseObject);
        [self hideHud];
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            
            NSArray *arr = responseObject[@"responseData"];
            if ([arr isKindOfClass:[NSNull class]]) {
                return ;
            }
            NSDictionary *dataDic = arr[0];
            
            if ([dataDic[@"orderType"] isEqualToString:@"01"]) {
                if ([dataDic[@"payType"] isEqualToString:@"02"]) {
                    payTypeView.image = [UIImage imageNamed:aliIcon];
                }else{
                    payTypeView.image = [UIImage imageNamed:weChatIcon];
                }
                rechageTyoe.text = @"账户充值";
                if (![dataDic[@"PriceEncrypt"] isKindOfClass:[NSNull class]]) {
                    NSString *price = dataDic[@"PriceEncrypt"];
                    price = [AESUtil decryptAES:price key:AESKey];
                    moneyNumLab.text = [NSString stringWithFormat:@"+%.2f元",[price floatValue]/100.00];

                }
            }else{
                payTypeView.image = [UIImage imageNamed:@"canteenpay"];
                if(_isNetworkPay){
                    rechageTyoe.text = @"食堂消费";
                }else {
                    rechageTyoe.text = @"app支付";
                }
                if (![dataDic[@"PriceEncrypt"] isKindOfClass:[NSNull class]]) {
                    NSString *price = dataDic[@"PriceEncrypt"];
                    price = [AESUtil decryptAES:price key:AESKey];
                    moneyNumLab.text = [NSString stringWithFormat:@"%.2f元",[price floatValue]/100.00];
                }
            }
            
            if (![dataDic[@"orderId"] isKindOfClass:[NSNull class]]) {
                orderIdLab.text = [NSString stringWithFormat:@"%@",dataDic[@"orderId"]];
            }
            
            NSString *timeStr;
            if (![dataDic[@"orderPayTime"] isKindOfClass:[NSNull class]]) {
                timeStr = dataDic[@"orderPayTime"];
            }
            
            NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
            [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
            [inputFormatter setDateFormat:@"yyyyMMddHHmmss"];
            NSDate *inputDate = [inputFormatter dateFromString:timeStr];
    
            NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
            [outputFormatter setLocale:[NSLocale currentLocale]];
            [outputFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
            NSString *str= [outputFormatter stringFromDate:inputDate];
            
            orderPayTimeLab.text = [NSString stringWithFormat:@"%@",str];
            
            // 判断是否收取管理费用
            _noteLabel.text = [NSString stringWithFormat:@"充值%@，收取管理费%.2f元",moneyNumLab.text, _Base_ManMoney.floatValue/100];
        }
    } failure:^(NSError *error) {
        [self hideHud];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
