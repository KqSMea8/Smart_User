//
//  RoottabbarController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/9/5.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "RoottabbarController.h"
#import "YQTabbar.h"
#import "YQTabbarItem.h"
#import "UITabBar+CustomBadge.h"
#import <iflyMSC/iflyMSC.h>
#import "ISRDataHelper.h"
#import "FirstMenuModel.h"
#import "IFLYResultViewController.h"
#import "Utils.h"
#import "ParkHomeViewController.h"
#import "ScanViewController.h"
#import "AccessListViewController.h"
#import "WeatherDetailController.h"
#import "KqTabbarViewController.h"
#import "ParkReservationViewController.h"
#import "BookDetailsViewController.h"
#import "BookRecordDetailController.h"
#import "BookRecordModel.h"
#import "BookRecordParkAreaModel.h"
#import "BookRecordParkSpaceModel.h"
#import "CarListModel.h"
#import "BindCarTableViewController.h"
#import "FoodViewController.h"
#import "FindCarViewController.h"
#import "QuickRechargeViewController.h"
#import "HomeViewController.h"
#import "MessageViewController.h"
#import "Mine_ViewController.h"
#import "SetTableViewController.h"
#import "BindTableViewController.h"
#import "ParkRecordsViewController.h"
#import "MyCarViewController.h"
#import "IFLYPopView.h"
#import "IFLYViewController.h"

@interface RoottabbarController ()<YQTabBarDelegate,IFLYCompleteDelegate,IFLYRecCompleteDelegate>
{
    NSMutableArray *bindCarDataArr;
    BOOL isCancleRecord;
}

@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,copy) NSString *resultStringFromJson;

@end

@implementation RoottabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    bindCarDataArr = @[].mutableCopy;
    
    [self initView];
    
    [self initData];
}

-(void)initData
{
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@{@"MENU_NAME": @"智能停车",@"MENU_ICON": @"ifly_park",@"MENU_ID":@1},@{@"MENU_NAME": @"扫一扫",@"MENU_ICON": @"ifly_scan",@"MENU_ID":@2},@{@"MENU_NAME": @"智能开门",@"MENU_ICON": @"ifly_opendoor",@"MENU_ID":@3},@{@"MENU_NAME": @"天气",@"MENU_ICON": @"ifly_weather",@"MENU_ID":@4},@{@"MENU_NAME": @"员工考勤",@"MENU_ICON": @"home_sign",@"MENU_ID":@5},@{@"MENU_NAME": @"车位预约",@"MENU_ICON": @"car_seat",@"MENU_ID":@6},@{@"MENU_NAME": @"今日菜谱",@"MENU_ICON": @"home_food",@"MENU_ID":@7},@{@"MENU_NAME": @"反向寻车",@"MENU_ICON": @"home_searchcar",@"MENU_ID":@8},@{@"MENU_NAME": @"一卡通充值",@"MENU_ICON": @"home_rechage",@"MENU_ID":@9},@{@"MENU_NAME": @"停车记录",@"MENU_ICON": @"mine_park_all",@"MENU_ID":@10},@{@"MENU_NAME": @"我的车辆",@"MENU_ICON": @"mine_car",@"MENU_ID":@11}, nil];
    
    _dataArr = [NSMutableArray array];
    [_dataArr removeAllObjects];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic = obj;
        [_dataArr addObject:[[FirstMenuModel alloc] initWithDataDic:dic]];
    }];
}

-(void)initView
{
    HomeViewController *homeVc = [[HomeViewController alloc] init];
    homeVc.isHidenNaviBar = YES;
    RootNavigationController *homNav = [[RootNavigationController alloc] initWithRootViewController:homeVc];
    
    MessageViewController *mesVc = [[MessageViewController alloc] init];
    RootNavigationController *mesNav = [[RootNavigationController alloc] initWithRootViewController:mesVc];
    
    Mine_ViewController *mineVc = [[Mine_ViewController alloc] init];
    mineVc.isHidenNaviBar = YES;
    RootNavigationController *mineNav = [[RootNavigationController alloc] initWithRootViewController:mineVc];
    
    SetTableViewController *setVc = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"SetTableViewController"];
    RootNavigationController *setNav = [[RootNavigationController alloc] initWithRootViewController:setVc];
    
    self.viewControllers = @[homNav, mesNav, mineNav, setNav];
    
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    YQTabbar *tabBar = [[YQTabbar alloc] initWithFrame:self.tabBar.bounds];
    
    tabBar.tabBarItemAttributes = @[@{kYQTabBarItemAttributeTitle : @"服务", kYQTabBarItemAttributeNormalImageName : @"tabbar_service", kYQTabBarItemAttributeSelectedImageName : @"tabbar_service_selected", kYQTabBarItemAttributeType : @(YQTabBarItemNormal)},
                                    @{kYQTabBarItemAttributeTitle : @"消息", kYQTabBarItemAttributeNormalImageName : @"tabbar_message", kYQTabBarItemAttributeSelectedImageName : @"tabbar_message_selected", kYQTabBarItemAttributeType : @(YQTabBarItemNormal)},
                                    @{kYQTabBarItemAttributeNormalImageName : @"tabbar_record", kYQTabBarItemAttributeSelectedImageName : @"tabbar_record", kYQTabBarItemAttributeType : @(YQTabBarItemRise)},
                                    @{kYQTabBarItemAttributeTitle : @"我的", kYQTabBarItemAttributeNormalImageName : @"tabbar_mine", kYQTabBarItemAttributeSelectedImageName : @"tabbar_mine_selected", kYQTabBarItemAttributeType : @(YQTabBarItemNormal)},
                                    @{kYQTabBarItemAttributeTitle : @"设置", kYQTabBarItemAttributeNormalImageName : @"tabbar_set", kYQTabBarItemAttributeSelectedImageName : @"tabbar_set_select", kYQTabBarItemAttributeType : @(YQTabBarItemNormal)}];
    
    tabBar.delegate = self;
    [self.tabBar addSubview:tabBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)tabBarDidSelectedRiseButton
{
    //    [[Utils getCurrentVC] showHint:@"按住说话,松开识别搜索"];
    //    IFLYPopView *popView = [[IFLYPopView alloc] initWithType:IFLYPopViewType];
    //    popView.delegate = self;
    //    [popView show];
    
    IFLYViewController *iflyVc = [[IFLYViewController alloc] init];
    iflyVc.delegate = self;
    [[Utils getCurrentVC] presentViewController:iflyVc animated:YES completion:nil];
}

#pragma mark IFLYCompleteDelegate
-(void)IFLYOviceComplete:(NSString *)resultStr
{
    _resultStringFromJson = resultStr;
    [self faliter];
}

-(void)IFLYRecComplete:(NSString *)resultStr
{
    _resultStringFromJson = resultStr;
    [self faliter];
}

-(void)faliter
{
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableArray *placeholderArr = [NSMutableArray array];
    NSMutableArray *matchStrArr = [NSMutableArray array];
    [_dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FirstMenuModel *model = obj;
        NSArray *failterArr = [Utils matchLongestSubstrings:_resultStringFromJson with:model.MENU_NAME];
        if (failterArr != nil&&failterArr.count >0) {
            [arr addObject:model];
            NSString *str = failterArr.firstObject;
            [matchStrArr addObject:str];
            [placeholderArr addObject:[NSString stringWithFormat:@"%ld",str.length]];
        }
    }];
    
    NSMutableArray *resultArr = [NSMutableArray array];
    NSMutableArray *matchPlaceholderArr = [NSMutableArray array];
    CGFloat max_value = [[placeholderArr valueForKeyPath:@"@max.floatValue"] floatValue];
    for (int i =0; i < placeholderArr.count; i++) {
        NSString *lengthStr = placeholderArr[i];
        if (lengthStr.floatValue == max_value) {
            [resultArr addObject:arr[i]];
            [matchPlaceholderArr addObject:matchStrArr[i]];
        }
    }
    
    if (resultArr.count == 1) {
        // 根据结果跳转
        if (placeholderArr.count == 1) {
            NSString *str = placeholderArr[0];
            if (![str isKindOfClass:[NSNull class]]&&[str integerValue] == 1) {
                //                [self resultPush:resultArr matchStrArr:matchPlaceholderArr];
                [self resultPush:resultArr matchStr:_resultStringFromJson];
            }else{
                [self resultPushOne:resultArr];
            }
        }else{
            [self resultPushOne:resultArr];
        }
    }else{
        //        [self resultPush:resultArr matchStrArr:matchPlaceholderArr];
        [self resultPush:resultArr matchStr:_resultStringFromJson];
    }
}

-(void)resultPushOne:(NSMutableArray *)arr
{
    FirstMenuModel *model = arr[0];
    NSInteger menuid = [model.MENU_ID integerValue];
    UINavigationController *nav = self.viewControllers[self.selectedIndex];
    switch (menuid) {
        case 1:
        {
            ParkHomeViewController *parkVC = [[ParkHomeViewController alloc] init];
            parkVC.hidesBottomBarWhenPushed = YES;
            parkVC.title = model.MENU_NAME;
            [nav pushViewController:parkVC animated:YES];
        }
            break;
        case 2:
        {
            if([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KLogin]){
                ScanViewController *scanVC = [[ScanViewController alloc] init];
                scanVC.title = model.MENU_NAME;
                [nav pushViewController:scanVC animated:YES];
            }else {
                BindTableViewController *bindVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"BindTableViewController"];
                if ([[kUserDefaults objectForKey:KLoginWay] isEqualToString:KAuthLoginMobile]) {
                    bindVC.type = @"1";
                }else{
                    bindVC.type = @"0";
                }
                bindVC.custName = [kUserDefaults objectForKey:KUserCustName];
                bindVC.custMobile = [kUserDefaults objectForKey:KUserPhoneNum];
                [nav pushViewController:bindVC animated:YES];
            }
        }
            break;
        case 3:
        {
            if([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KLogin]){
                AccessListViewController *accessCtrlVC = [[AccessListViewController alloc] init];
                accessCtrlVC.titleStr = model.MENU_NAME;
                [nav pushViewController:accessCtrlVC animated:YES];
            }else{
                BindTableViewController *bindVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"BindTableViewController"];
                if ([[kUserDefaults objectForKey:KLoginWay] isEqualToString:KAuthLoginMobile]) {
                    bindVC.type = @"1";
                }else{
                    bindVC.type = @"0";
                }
                bindVC.custName = [kUserDefaults objectForKey:KUserCustName];
                bindVC.custMobile = [kUserDefaults objectForKey:KUserPhoneNum];
                [nav pushViewController:bindVC animated:YES];
            }
        }
            break;
        case 4:
        {
            WeatherDetailController *weaDetailVC = [[WeatherDetailController alloc] init];
            [nav pushViewController:weaDetailVC animated:YES];
        }
            break;
        case 5:
        {
            // 考勤
            if ([[kUserDefaults objectForKey:KLoginWay] isEqualToString:KLogin]) {
                KqTabbarViewController *kqtabbarVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"KqTabbarViewController"];
                kqtabbarVC.selectedIndex = 0;
                kqtabbarVC.titleStr = model.MENU_NAME;
                [nav pushViewController:kqtabbarVC animated:YES];
            }else
            {
                BindTableViewController *bindVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"BindTableViewController"];
                if ([[kUserDefaults objectForKey:KLoginWay] isEqualToString:KAuthLoginMobile]) {
                    bindVC.type = @"1";
                }else{
                    bindVC.type = @"0";
                }
                bindVC.custName = [kUserDefaults objectForKey:KUserCustName];
                bindVC.custMobile = [kUserDefaults objectForKey:KUserPhoneNum];
                [nav pushViewController:bindVC animated:YES];
            }
            
        }
            break;
        case 6:
        {
            [self loadBindCarData];
        }
            break;
        case 7:
        {
            // 菜谱
            FoodViewController *foodVC = [[FoodViewController alloc] init];
            foodVC.titleStr = model.MENU_NAME;
            [nav pushViewController:foodVC animated:YES];
        }
            break;
        case 8:
        {
            // 寻车
            if([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KAuthLogin]){
                BindTableViewController *bindVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"BindTableViewController"];
                [nav pushViewController:bindVC animated:YES];
            }else {
                FindCarViewController *findcarVC = [[FindCarViewController alloc] init];
                findcarVC.title = model.MENU_NAME;
                [nav pushViewController:findcarVC animated:YES];
            }
        }
            break;
        case 9:
        {
            if([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KLogin]){
                QuickRechargeViewController *quickRechageVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"QuickRechargeViewController"];
                quickRechageVC.titleStr = model.MENU_NAME;
                [nav pushViewController:quickRechageVC animated:YES];
            }else{
                BindTableViewController *bindVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"BindTableViewController"];
                if ([[kUserDefaults objectForKey:KLoginWay] isEqualToString:KAuthLoginMobile]) {
                    bindVC.type = @"1";
                }else{
                    bindVC.type = @"0";
                }
                bindVC.custName = [kUserDefaults objectForKey:KUserCustName];
                bindVC.custMobile = [kUserDefaults objectForKey:KUserPhoneNum];
                [nav pushViewController:bindVC animated:YES];
            }
            
        }
            break;
        case 10:
        {
            if([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KAuthLogin]){
                BindTableViewController *bindVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"BindTableViewController"];
                [nav pushViewController:bindVC animated:YES];
            }else {
                ParkRecordsViewController *parkReVc = [[ParkRecordsViewController alloc] init];
                [nav pushViewController:parkReVc animated:YES];
            }
        }
            break;
        case 11:
        {
            if([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KAuthLogin]){
                BindTableViewController *bindVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"BindTableViewController"];
                [nav pushViewController:bindVC animated:YES];
            }else {
                MyCarViewController *myCarVC = [[MyCarViewController alloc] init];
                [nav pushViewController:myCarVC animated:YES];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark 检查是否已经预定车位
-(void)cheakIsBookParkArea
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/parking/getCustReservationOrder",MainUrl];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:[kUserDefaults objectForKey:kCustId] forKey:@"custId"];
    
    NSString *jsonStr = [Utils convertToJsonData:params];
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setObject:jsonStr forKey:@"param"];
    
    UIViewController *Vc = [Utils getCurrentVC];
    [Vc showHudInView:Vc.view hint:nil];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
        [Vc hideHud];
        if (![responseObject[@"code"] isKindOfClass:[NSNull class]]&&[responseObject[@"code"] isEqualToString:@"1"]) {
            NSDictionary *dic = responseObject[@"responseData"];
            NSArray *arr = dic[@"items"];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dataDic = obj;
                BookRecordModel *_orderModel = [[BookRecordModel alloc] initWithDataDic:dataDic[@"order"]];
                BookRecordParkAreaModel *_parkAreaModel = [[BookRecordParkAreaModel alloc] initWithDataDic:dataDic[@"parkingArea"]];
                BookRecordParkSpaceModel *_parkSpaceModel = [[BookRecordParkSpaceModel alloc] initWithDataDic:dataDic[@"parkingSpace"]];
                if ([_orderModel.status isEqualToString:@"1"]) {
                    BookRecordDetailController *bookRecordDetailVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"BookRecordDetailController"];
                    bookRecordDetailVC.orderId = _orderModel.orderId;
                    [[Utils getCurrentVC].navigationController pushViewController:bookRecordDetailVC animated:YES];
                }else{
                    BookDetailsViewController *bookDetailVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"BookDetailsViewController"];
                    bookDetailVC.orderModel = _orderModel;
                    bookDetailVC.parkAreaModel = _parkAreaModel;
                    bookDetailVC.parkSpaceModel = _parkSpaceModel;
                    bookDetailVC.currentTime = dic[@"cunrentTime"];
                    [[Utils getCurrentVC].navigationController pushViewController:bookDetailVC animated:YES];
                }
            }];
            
        }else{
            ParkReservationViewController *parkReserVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"ParkReservationViewController"];
            parkReserVC.title = @"车位预约";
            [[Utils getCurrentVC].navigationController pushViewController:parkReserVC animated:YES];
        }
    } failure:^(NSError *error) {
        [Vc hideHud];
        [Vc showHint:@"请重试!"];
    }];
}

#pragma mark 是否绑定车辆
-(void)loadBindCarData
{
    UINavigationController *nav = self.viewControllers[self.selectedIndex];
    UIViewController *Vc = [Utils getCurrentVC];
    [Vc showHudInView:Vc.view hint:nil];
    NSString *urlStr = [NSString stringWithFormat:@"%@park-service/member/getMemberCards",[kUserDefaults objectForKey:KParkUrl]];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    NSString *memberId = [[NSUserDefaults standardUserDefaults] objectForKey:KMemberId];
    if(memberId != nil){
        [params setObject:memberId forKey:@"memberId"];
    }
    [params setObject:KToken forKey:@"token"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        [Vc hideHud];
        if([responseObject[@"success"] boolValue]){
            
            NSArray *carList = responseObject[@"data"][@"carList"];
            [carList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CarListModel *carModel = [[CarListModel alloc] initWithDataDic:obj];
                [bindCarDataArr addObject:[NSString stringWithFormat:@"%@ %@",carModel.carArea,carModel.carNum]];
            }];
            
            if (carList.count ==1) {
                [self cheakIsBookParkArea];
            }else if(carList.count == 0){
                [Vc showHint:@"请先绑定你要预定的车辆!"];
                [self performSelector:@selector(bindCarAction) withObject:nil afterDelay:1];
            }else{
                ParkReservationViewController *parkReserVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"ParkReservationViewController"];
                parkReserVC.title = @"车位预约";
                [nav pushViewController:parkReserVC animated:YES];
            }
        }else{
            [Vc showHint:@"请重试!"];
        }
    } failure:^(NSError *error) {
        [Vc hideHud];
    }];
}

-(void)bindCarAction{
    UINavigationController *nav = self.viewControllers[self.selectedIndex];
    BindCarTableViewController *bindCarVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"BindCarTableViewController"];
    [nav pushViewController:bindCarVC animated:YES];
}

//- (void)resultPush:(NSMutableArray *)arr matchStrArr:(NSMutableArray *)matcharr
- (void)resultPush:(NSMutableArray *)arr matchStr:(NSString *)matchstr
{
    UINavigationController *nav = self.viewControllers[self.selectedIndex];
    IFLYResultViewController *resVc = [[IFLYResultViewController alloc] init];
    resVc.dataArr = arr;
    //    resVc.matchArr = matcharr;
    resVc.matchStr = matchstr;
    [nav pushViewController:resVc animated:YES];
}

- (BOOL)shouldAutorotate {
    return [self.selectedViewController shouldAutorotate];
}

@end
