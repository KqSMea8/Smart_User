//
//  VisitTabbarViewController.m
//  DXWingGate
//
//  Created by coder on 2018/8/14.
//  Copyright © 2018年 com.Transfar. All rights reserved.
//

#import "VisitTabbarViewController.h"
#import "YQTabbar.h"
#import "UITabBar+CustomBadge.h"
#import "VisitRecordViewController.h"
#import "VisitResViewController.h"

@interface VisitTabbarViewController ()<UITabBarControllerDelegate>
{
    UIButton *rightBtn;
}

@property (nonatomic,strong) NSMutableArray * VCS;//tabbar root VC

@end

@implementation VisitTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [kNotificationCenter addObserver:self selector:@selector(tabbarDidSelectItem) name:@"VisittabbarDidSelectItemNotification" object:nil];
    
    self.delegate = self;
    //初始化tabbar
    [self setUpTabBar];
    //添加子控制器
    [self setUpAllChildViewController];
    
    [self _initNavItems];
}

-(void)_initNavItems
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#E2E2E2"];
    
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

//-(void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//    self.navigationController.navigationBarHidden = YES;
//}

#pragma mark ————— 初始化TabBar —————
-(void)setUpTabBar{
    //设置背景色 去掉分割线
    [self setValue:[YQTabbar new] forKey:@"tabBar"];
    [self.tabBar setBackgroundColor:[UIColor colorWithHexString:@"#F6F6F6"]];
    [self.tabBar setBackgroundImage:[UIImage new]];
    //通过这两个参数来调整badge位置
    //    [self.tabBar setTabIconWidth:29];
    //    [self.tabBar setBadgeTop:9];
    
    rightBtn = [[UIButton alloc] init];
    rightBtn.hidden = YES;
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    [rightBtn setImage:[UIImage imageNamed:@"visit_nav_filter_icon"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - ——————— 初始化VC ————————
-(void)setUpAllChildViewController{
    _VCS = @[].mutableCopy;
    
    VisitResViewController *homeVC = [[UIStoryboard storyboardWithName:@"Visit" bundle:nil] instantiateViewControllerWithIdentifier:@"VisitResViewController"];
    [self setupChildViewController:homeVC title:@"来访预约" imageName:@"visit_tabbar_res_normal" seleceImageName:@"visit_tabbar_res_select"];
    
    VisitRecordViewController *msgVC = [[VisitRecordViewController alloc] init];
    [self setupChildViewController:msgVC title:@"申请记录" imageName:@"visit_tabbar_record_normal" seleceImageName:@"visit_tabbar_record_select"];
    
    self.viewControllers = _VCS;
}

-(void)setupChildViewController:(UIViewController*)controller title:(NSString *)title imageName:(NSString *)imageName seleceImageName:(NSString *)selectImageName{
    controller.title = title;
    controller.tabBarItem.title = title;//跟上面一样效果
    controller.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //未选中字体颜色
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:SYSTEMFONT(12.0f)} forState:UIControlStateNormal];
    
    //选中字体颜色
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#1B82D1"],NSFontAttributeName:SYSTEMFONT(12.0f)} forState:UIControlStateSelected];
    
    [_VCS addObject:controller];
    
}


-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    //    DLog(@"选中 %ld",tabBarController.selectedIndex);
}

-(void)setRedDotWithIndex:(NSInteger)index isShow:(BOOL)isShow{
    if (isShow) {
        [self.tabBar setBadgeStyle:kCustomBadgeStyleRedDot value:0 atIndex:index];
    }else{
        [self.tabBar setBadgeStyle:kCustomBadgeStyleNone value:0 atIndex:index];
    }
}

- (BOOL)shouldAutorotate {
    return [self.selectedViewController shouldAutorotate];
}

-(void)tabbarDidSelectItem{
    if(self.selectedIndex == 0){
        rightBtn.hidden = YES;
        self.title = @"来访预约";
    }else if(self.selectedIndex == 1){
        rightBtn.hidden = NO;
        self.title = @"来访预约申请";
    }else{
        rightBtn.hidden = YES;
    }
}

-(void)rightBtnClick
{
    [kNotificationCenter postNotificationName:@"VisitRecordFilterNotification" object:nil];
}

-(void)dealloc
{
    [kNotificationCenter removeObserver:self name:@"VisittabbarDidSelectItemNotification" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
