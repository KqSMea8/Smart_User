//
//  BillsViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/25.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "BillsViewController.h"
#import "OnlinePayViewController.h"
//#import "CheckViewController.h"
#import "ECardViewController.h"

@interface BillsViewController ()

@property (nonatomic, strong) NSArray *titleData;

@end

@implementation BillsViewController
#pragma mark 标题数组
- (NSArray *)titleData {
    if (!_titleData) {
        _titleData = @[@"一卡通", @"网上支付"];
    }
    return _titleData;
}

#pragma mark 初始化代码
- (instancetype)init {
    if (self = [super init]) {
        self.titleSizeNormal = 15;
        self.titleSizeSelected = 15;
        self.titleColorSelected = [UIColor colorWithHexString:@"#1B82D1"];
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuItemWidth = [UIScreen mainScreen].bounds.size.width / self.titleData.count * 0.7;
        self.menuHeight = 60;
        self.menuViewBottomSpace = 0;
        self.progressHeight = 5;
        self.progressColor = [UIColor colorWithHexString:@"#1B82D1"];
        self.view.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    }
    return self;
}

#pragma mark - Datasource & Delegate

#pragma mark 返回子页面的个数
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titleData.count;
}

#pragma mark 返回某个index对应的页面
- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    switch (index) {
        case 0:{
            ECardViewController *eCardVC = [[ECardViewController alloc] init];
            eCardVC.title = @"一卡通";
            return eCardVC;
            
        }
            break;
            
        default:{
            
            OnlinePayViewController *onLinePayVC = [[OnlinePayViewController alloc] init];
            onLinePayVC.title = @"网上支付";
            return onLinePayVC;
            
        }
            break;
    }
}

#pragma mark 返回index对应的标题
- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    
    return self.titleData[index];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initNavItems];
    
    [self _initView];
}

-(void)_initNavItems
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#E2E2E2"];
    
    self.title = @"账单明细";
    
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

-(void)_initView
{
    for (int i=1; i<2; i++) {
        UIImageView *hLineView = [[UIImageView alloc] init];
        hLineView.image = [UIImage imageNamed:@"LED_seperateline_blue"];
        hLineView.frame = CGRectMake(KScreenWidth/2 * i, 15, 0.5, 32);
        [self.menuView addSubview:hLineView];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
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

