//
//  RechageSuccseViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/5.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "RechageSuccseViewController.h"
#import "AESUtil.h"

@interface RechageSuccseViewController ()

@property (weak, nonatomic) IBOutlet UIButton *rechageSucBtn;
@property (weak, nonatomic) IBOutlet UILabel *rechageNumLab;
@property (weak, nonatomic) IBOutlet UILabel *purseMoneyNumLab;

@end

@implementation RechageSuccseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _initNavItems];
    
    [self _initView];
    
    [self _loadOrderDetailData];
    
//    [self _loadBalanceData];
}

-(void)_initNavItems
{
    self.title = @"快速充值";
    
    UIButton *leftBtn = [[UIButton alloc] init];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [leftBtn setImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(_leftBarBtnItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}

-(void)_initView
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    _rechageSucBtn.layer.cornerRadius = 6;
    _rechageSucBtn.backgroundColor = [UIColor colorWithHexString:@"#1B82D1"];
    
}

- (void)_leftBarBtnItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)rechageSucBtnAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            
            _purseMoneyNumLab.text = [NSString stringWithFormat:@"%.2f",[dic[@"balance"] floatValue]/100];
            
        }
    } failure:^(NSError *error) {
        DLog(@"%@",error);
    }];
}

-(void)_loadOrderDetailData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/rechargeOrder/getorderDetails",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:_orderId forKey:@"orderId"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            
            NSArray *arr = responseObject[@"responseData"];
            if ([arr isKindOfClass:[NSNull class]]) {
                return ;
            }
            NSDictionary *dataDic = arr[0];
            
            NSString *price = dataDic[@"PriceEncrypt"];
            price = [AESUtil decryptAES:price key:AESKey];
            
            _rechageNumLab.text = [NSString stringWithFormat:@"%.2f",[price floatValue]/100.00];
            
        }
    } failure:^(NSError *error) {
        
    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
