//
//  BaseTabbarCtrl.m
//  ZHYQ
//
//  Created by 焦平 on 2017/10/22.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "BaseTabbarCtrl.h"
#import "YQTabbar.h"
#import "RootNavigationController.h"
#import "UITabBar+CustomBadge.h"

#import "HomeViewController.h"
#import "StyleViewController.h"
#import "MessageViewController.h"
#import "Mine_ViewController.h"

@interface BaseTabbarCtrl ()<UITabBarControllerDelegate>

@property (nonatomic,strong) NSMutableArray * VCS;//tabbar root VC

@end

@implementation BaseTabbarCtrl

//只支持竖屏
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskPortrait;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    //初始化tabbar
    [self setUpTabBar];
    //添加子控制器
    [self setUpAllChildViewController];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


#pragma mark ————— 初始化TabBar —————
-(void)setUpTabBar{
    //设置背景色 去掉分割线
    [self setValue:[YQTabbar new] forKey:@"tabBar"];
    [self.tabBar setBackgroundColor:[UIColor colorWithHexString:@"#F6F6F6"]];
    [self.tabBar setBackgroundImage:[UIImage new]];
    //通过这两个参数来调整badge位置
    //    [self.tabBar setTabIconWidth:29];
    //    [self.tabBar setBadgeTop:9];
}

#pragma mark - ——————— 初始化VC ————————
-(void)setUpAllChildViewController{
    _VCS = @[].mutableCopy;
    
    
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    homeVC.isHidenNaviBar = YES;
    [self setupChildViewController:homeVC title:@"服务" imageName:@"tabbar_service" seleceImageName:@"tabbar_service_selected"];
    
//    StyleViewController *styleVC = [[StyleViewController alloc] init];
//    styleVC.view.backgroundColor = [UIColor blackColor];
//    [self setupChildViewController:styleVC title:@"风采" imageName:@"tabbar_style" seleceImageName:@"tabbar_style_selected"];
    
    MessageViewController *msgVC = [[MessageViewController alloc] init];
    msgVC.view.backgroundColor = [UIColor redColor];
    [self setupChildViewController:msgVC title:@"消息" imageName:@"tabbar_message" seleceImageName:@"tabbar_message_selected"];
    
//    MineViewController *mineVC = [[MineViewController alloc]init];
//    MineViewController *mineVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"MineViewController"];
    Mine_ViewController *mineVC = [[Mine_ViewController alloc]init];
    mineVC.isHidenNaviBar = YES;
    [self setupChildViewController:mineVC title:@"我的" imageName:@"tabbar_mine" seleceImageName:@"tabbar_mine_selected"];
    
    self.viewControllers = _VCS;
}

-(void)setupChildViewController:(UIViewController*)controller title:(NSString *)title imageName:(NSString *)imageName seleceImageName:(NSString *)selectImageName{
    controller.title = title;
    controller.tabBarItem.title = title;//跟上面一样效果
    controller.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //未选中字体颜色
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:KBlackColor,NSFontAttributeName:SYSTEMFONT(12.0f)} forState:UIControlStateNormal];
    
    //选中字体颜色
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#6cd2ff"],NSFontAttributeName:SYSTEMFONT(12.0f)} forState:UIControlStateSelected];
    
    RootNavigationController *nav = [[RootNavigationController alloc]initWithRootViewController:controller];
    
    [_VCS addObject:nav];
    
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
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    return [self.selectedViewController supportedInterfaceOrientations];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

