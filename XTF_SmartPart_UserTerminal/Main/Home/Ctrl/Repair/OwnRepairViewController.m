//
//  OwnRepairViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by jiaop on 2018/5/7.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "OwnRepairViewController.h"
#import "RepairAllViewController.h"
#import "RepairWaitRecivedViewController.h"
#import "RepairingViewController.h"
#import "RepairCompletedViewController.h"

@interface OwnRepairViewController ()

@property (nonatomic, strong) NSArray *titleData;

@end

@implementation OwnRepairViewController

#pragma mark 标题数组
- (NSArray *)titleData {
    if (!_titleData) {
        _titleData = @[@"全部", @"待处理",@"处理中",@"已完成"];
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
        self.menuItemWidth = KScreenWidth / self.titleData.count;
        self.menuHeight = 60;
        self.progressHeight = 5;
        self.progressColor = [UIColor colorWithHexString:@"#1B82D1"];
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
            RepairAllViewController *repairAllVc = [[RepairAllViewController alloc] init];
            return repairAllVc;
        }
            break;
        case 1:{
            RepairWaitRecivedViewController *waitRecivedVc = [[RepairWaitRecivedViewController alloc] init];
            return waitRecivedVc;
        }
            break;
        case 2:{
            RepairingViewController *repairingVc = [[RepairingViewController alloc] init];
            return repairingVc;
        }
            break;
        default:{
            RepairCompletedViewController *repairCompletedVc = [[RepairCompletedViewController alloc] init];
            return repairCompletedVc;
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
    
    self.title = @"我的报修";
    
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
    for (int i=1; i<4; i++) {
        UIImageView *hLineView = [[UIImageView alloc] init];
        hLineView.image = [UIImage imageNamed:@"LED_seperateline_blue"];
        hLineView.frame = CGRectMake(KScreenWidth/4 * i, 15, 0.5, 32);
        [self.menuView addSubview:hLineView];
    }
}

@end
