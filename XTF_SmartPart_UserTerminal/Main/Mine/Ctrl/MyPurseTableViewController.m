//
//  MyPurseTableViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/5.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "MyPurseTableViewController.h"
#import "AESUtil.h"
#import "QuickRechargeViewController.h"
#import "BillsViewController.h"
#import "BindTableViewController.h"
#import "ECardViewController.h"

@interface MyPurseTableViewController ()
{
    
    __weak IBOutlet UILabel *balanceLab;
    
}

@end

@implementation MyPurseTableViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //获取用户账户余额
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KLogin]) {
        [self _loadBalanceData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initView];

    [self _initNavItems];
}

-(void)_initView
{
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
}

-(void)_initNavItems
{
    self.title = @"我的钱包";
    
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
            
            balanceLab.text = [NSString stringWithFormat:@"余额 %.2f元",[balance floatValue]/100.00];
            
        }
    } failure:^(NSError *error) {
        DLog(@"%@",error);
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KLogin]) {
            QuickRechargeViewController *qrVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"QuickRechargeViewController"];
            qrVC.titleStr = @"一卡通充值";
            [self.navigationController pushViewController:qrVC animated:YES];
        }else{
            BindTableViewController *bindVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"BindTableViewController"];
            [self.navigationController pushViewController:bindVC animated:YES];
        }
    }else if (indexPath.row == 1) {
//        BillsViewController *billsVC = [[BillsViewController alloc] init];
//        [self.navigationController pushViewController:billsVC animated:YES];
        ECardViewController *eCardVC = [[ECardViewController alloc] init];
        eCardVC.title = @"账单明细";
        [self.navigationController pushViewController:eCardVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
