//
//  ParkRecordsViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/2.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "ParkRecordsViewController.h"

#import "ParkAllViewController.h"
#import "ParkBookViewController.h"
#import "ParkOutViewController.h"
#import "ParkInViewController.h"

@interface ParkRecordsViewController ()

@property (nonatomic, strong) NSArray *titleData;

@end

@implementation ParkRecordsViewController

#pragma mark 标题数组
- (NSArray *)titleData {
    if (!_titleData) {
//        _titleData = @[@"全部", @"已预约",@"已入场",@"已出场"];
        _titleData = @[@"全部",@"已入场",@"已出场"];
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
        self.menuItemWidth = [UIScreen mainScreen].bounds.size.width / self.titleData.count;
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
            ParkAllViewController *parkAllVC = [[ParkAllViewController alloc] init];
            parkAllVC.title = @"全部";
            return parkAllVC;
        }
            break;
        case 1:{
            
            ParkInViewController *parkInVC = [[ParkInViewController alloc] init];
            parkInVC.title = @"已入场";
            return parkInVC;
        }
            break;
            
        default:{
            ParkOutViewController *parkOutVC = [[ParkOutViewController alloc] init];
            parkOutVC.title = @"已出场";
            return parkOutVC;
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
    
    self.title = @"停车记录";
    
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
    for (int i=1; i<_titleData.count; i++) {
        UIImageView *hLineView = [[UIImageView alloc] init];
        hLineView.image = [UIImage imageNamed:@"LED_seperateline_blue"];
        hLineView.frame = CGRectMake(KScreenWidth/_titleData.count * i, 15, 0.5, 32);
        [self.menuView addSubview:hLineView];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
