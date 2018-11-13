//
//  PaySuccessTableViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/19.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "PaySuccessTableViewController.h"
#import "AESUtil.h"

@interface PaySuccessTableViewController ()
{
    
    __weak IBOutlet UILabel *moneyNumLab;
    __weak IBOutlet UILabel *collectMoneyLab;
    __weak IBOutlet UIButton *payComBtn;
    __weak IBOutlet UILabel *payPeopleNameLab;
    
}

@end

@implementation PaySuccessTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self _initNavItems];
    
    [self _loadOrderData];
}

-(void)initView
{
    self.tableView.bounces = NO;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    payComBtn.layer.cornerRadius = 6;
    payComBtn.clipsToBounds = YES;
    
    if(![[kUserDefaults objectForKey:KUserCustName] isKindOfClass:[NSNull class]]&&[kUserDefaults objectForKey:KUserCustName] !=nil){
        payPeopleNameLab.text = [NSString stringWithFormat:@"%@",[kUserDefaults objectForKey:KUserCustName]];
    }else{
        payPeopleNameLab.text = @"-";
    }
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

-(void)_loadOrderData
{
    [self showHudInView:self.view hint:@""];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/rechargeOrder/getorderDetails",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:_orderId forKey:@"orderId"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            NSArray *arr = responseObject[@"responseData"];
            NSDictionary *dic = arr[0];

            NSString *price = dic[@"PriceEncrypt"];
            price = [AESUtil decryptAES:price key:AESKey];
            moneyNumLab.text = [NSString stringWithFormat:@"￥%.2f",[price floatValue]/100.00];
        }
    } failure:^(NSError *error) {
        [self hideHud];
    }];
}

- (IBAction)payComBtnAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
